//! Parsing des exports Google Timeline (§3.1, §5.1).
//!
//! Deux formats à couvrir : legacy `semanticSegments` et direct-array.
//! Le format détecté est enregistré dans `import_batch.source_format_detected`.
//!
//! # Streaming (§4)
//!
//! Le document n'est jamais chargé en entier. La détection de format se fait
//! sur le premier jeton, puis les enregistrements sont désérialisés **un par
//! un** et poussés dans le [`RecordSink`] au fil de la lecture. La mémoire
//! utilisée est bornée par le plus gros enregistrement — une journée de
//! trajectoire — pas par la taille du fichier.
//!
//! # Tolérance
//!
//! Un enregistrement illisible est ignoré et compté, il ne fait pas échouer
//! l'import (§3.10) : un export de dix ans contient des aberrations, et
//! perdre l'import entier pour une ligne serait le pire des comportements.
//! Seules les erreurs *structurelles* — JSON invalide, format inconnu — sont
//! fatales.

use std::cell::Cell;
use std::fmt;
use std::io::{self, BufRead, BufReader, Read};

use serde::de::{self, DeserializeSeed, IgnoredAny, MapAccess, SeqAccess, Visitor};
use serde_json::Value;
use serde_json::error::Category;

use crate::error::{CoordError, ParseError, RecordError, TimeError};
use crate::model::{RawPoint, Segment, SourceFormat, SourceKind, TravelMode, Visit};
use crate::parse::time::Timestamp;
use crate::parse::{
    ImportStep, ImportSummary, ParseOptions, Progress, RecordSink, SkippedRecord, TimelineImporter,
    coords, time,
};

/// Taille du tampon de lecture. Compromis entre le nombre d'appels système et
/// l'empreinte mémoire, qui doit rester constante (§4).
const READ_BUFFER: usize = 64 * 1024;

/// Nombre maximal de clés de premier niveau remontées dans
/// [`ParseError::UnrecognisedFormat`] — de quoi diagnostiquer un format futur
/// sans recopier tout le document dans un message d'erreur.
const MAX_REPORTED_KEYS: usize = 8;

/// Clés portant le début d'un enregistrement, par ordre de préférence.
const START_KEYS: [&str; 2] = ["startTime", "startTimestamp"];
/// Clés portant la fin d'un enregistrement, par ordre de préférence.
const END_KEYS: [&str; 2] = ["endTime", "endTimestamp"];

/// Sentinelle d'interruption.
///
/// serde n'a pas de canal pour remonter une erreur applicative : on
/// interrompt la désérialisation avec cette erreur bidon et la vraie cause,
/// typée, attend dans [`Ctx::fatal`].
const ABORT: &str = "odysseia:abort";

/// Importeur d'exports Google Timeline — une implémentation du trait commun
/// [`TimelineImporter`] parmi d'autres à venir (§3.1).
#[derive(Debug, Default, Clone, Copy)]
pub struct GoogleImporter;

impl TimelineImporter for GoogleImporter {
    fn source_kind(&self) -> SourceKind {
        SourceKind::GoogleTimeline
    }

    fn parse(
        &self,
        reader: &mut dyn Read,
        sink: &mut dyn RecordSink,
        options: &ParseOptions,
    ) -> Result<ImportSummary, ParseError> {
        let meter = Meter::default();
        let counting = CountingReader {
            inner: reader,
            meter: &meter,
            limit: options.max_bytes,
        };
        let mut buffered = BufReader::with_capacity(READ_BUFFER, counting);

        sink.progress(Progress {
            step: ImportStep::DetectingFormat,
            bytes_read: 0,
            total_bytes: options.total_bytes_hint,
            records_emitted: 0,
        });

        // Un document vide ou blanc est un export vide, pas un JSON corrompu :
        // le message utilisateur qui en découle n'est pas le même (§3.10).
        if first_meaningful_byte(&mut buffered, &meter, options)?.is_none() {
            return Err(ParseError::EmptyExport);
        }

        let mut ctx = Ctx::new(sink, options, &meter);
        let mut deserializer = serde_json::Deserializer::from_reader(&mut buffered);
        let outcome = Document(&mut ctx)
            .deserialize(&mut deserializer)
            .and_then(|()| deserializer.end());

        if let Some(fatal) = ctx.fatal.take() {
            return Err(fatal);
        }
        outcome.map_err(|err| classify(&meter, options, &err))?;

        let Some(format) = ctx.format else {
            return Err(ParseError::UnrecognisedFormat { found: Vec::new() });
        };
        if ctx.records_emitted() == 0 && ctx.skipped_count == 0 {
            return Err(ParseError::EmptyExport);
        }

        ctx.emit_progress(ImportStep::Done);
        Ok(ctx.into_summary(format))
    }
}

// ---------------------------------------------------------------------------
// Comptage d'octets et limite de taille
// ---------------------------------------------------------------------------

/// Compteurs partagés entre le lecteur et le contexte d'analyse.
#[derive(Debug, Default)]
struct Meter {
    bytes: Cell<u64>,
    too_large: Cell<bool>,
}

/// Lecteur qui compte les octets consommés et applique la limite de taille.
struct CountingReader<'a> {
    inner: &'a mut dyn Read,
    meter: &'a Meter,
    limit: Option<u64>,
}

impl Read for CountingReader<'_> {
    fn read(&mut self, out: &mut [u8]) -> io::Result<usize> {
        let read = self.inner.read(out)?;
        let total = self.meter.bytes.get() + read as u64;
        self.meter.bytes.set(total);

        if let Some(limit) = self.limit
            && total > limit
        {
            self.meter.too_large.set(true);
            return Err(io::Error::other("limite de taille dépassée"));
        }
        Ok(read)
    }
}

/// Consomme les blancs de tête et renvoie le premier octet significatif, sans
/// le consommer — il appartient au document que serde va lire.
fn first_meaningful_byte(
    reader: &mut impl BufRead,
    meter: &Meter,
    options: &ParseOptions,
) -> Result<Option<u8>, ParseError> {
    loop {
        let step = {
            let buffer = reader
                .fill_buf()
                .map_err(|err| classify_io(meter, options, &err))?;
            if buffer.is_empty() {
                return Ok(None);
            }
            match buffer.iter().position(|byte| !byte.is_ascii_whitespace()) {
                Some(index) => Step::Found(buffer[index], index),
                None => Step::SkipAll(buffer.len()),
            }
        };

        match step {
            Step::Found(byte, index) => {
                reader.consume(index);
                return Ok(Some(byte));
            }
            Step::SkipAll(count) => reader.consume(count),
        }
    }
}

enum Step {
    Found(u8, usize),
    SkipAll(usize),
}

/// Traduit une erreur serde en erreur typée (§3.10).
fn classify(meter: &Meter, options: &ParseOptions, err: &serde_json::Error) -> ParseError {
    if meter.too_large.get() {
        return too_large(meter, options);
    }
    match err.classify() {
        Category::Io => ParseError::Io {
            detail: err.to_string(),
        },
        _ => ParseError::CorruptJson {
            line: err.line(),
            column: err.column(),
            detail: err.to_string(),
        },
    }
}

/// Traduit une erreur d'E/S brute en erreur typée.
fn classify_io(meter: &Meter, options: &ParseOptions, err: &io::Error) -> ParseError {
    if meter.too_large.get() {
        return too_large(meter, options);
    }
    ParseError::Io {
        detail: err.to_string(),
    }
}

fn too_large(meter: &Meter, options: &ParseOptions) -> ParseError {
    ParseError::FileTooLarge {
        size_bytes: meter.bytes.get(),
        limit_bytes: options.max_bytes.unwrap_or_default(),
    }
}

// ---------------------------------------------------------------------------
// Contexte d'analyse
// ---------------------------------------------------------------------------

/// État mutable porté d'un enregistrement à l'autre.
struct Ctx<'a> {
    sink: &'a mut dyn RecordSink,
    options: &'a ParseOptions,
    meter: &'a Meter,
    format: Option<SourceFormat>,
    top_level_keys: Vec<String>,
    point_count: u64,
    segment_count: u64,
    visit_count: u64,
    skipped_count: u64,
    period_start: Option<i64>,
    period_end: Option<i64>,
    record_index: u64,
    since_progress: u64,
    fatal: Option<ParseError>,
}

impl<'a> Ctx<'a> {
    fn new(sink: &'a mut dyn RecordSink, options: &'a ParseOptions, meter: &'a Meter) -> Self {
        Self {
            sink,
            options,
            meter,
            format: None,
            top_level_keys: Vec::new(),
            point_count: 0,
            segment_count: 0,
            visit_count: 0,
            skipped_count: 0,
            period_start: None,
            period_end: None,
            record_index: 0,
            since_progress: 0,
            fatal: None,
        }
    }

    fn records_emitted(&self) -> u64 {
        self.point_count + self.segment_count + self.visit_count
    }

    /// Étend la période couverte — alimente `import_batch` (§5.1), qui sert à
    /// avertir avant écrasement au ré-import (§4).
    fn cover(&mut self, from: i64, to: i64) {
        let (low, high) = if from <= to { (from, to) } else { (to, from) };
        self.period_start = Some(self.period_start.map_or(low, |current| current.min(low)));
        self.period_end = Some(self.period_end.map_or(high, |current| current.max(high)));
    }

    fn emit_point(&mut self, point: RawPoint) {
        self.cover(point.timestamp_utc, point.timestamp_utc);
        self.point_count += 1;
        self.sink.point(point);
    }

    fn emit_segment(&mut self, segment: Segment) {
        self.cover(segment.start_ts_utc, segment.end_ts_utc);
        self.segment_count += 1;
        self.sink.segment(segment);
    }

    fn emit_visit(&mut self, visit: Visit) {
        self.cover(visit.arrival_ts_utc, visit.departure_ts_utc);
        self.visit_count += 1;
        self.sink.visit(visit);
    }

    /// Rejette l'enregistrement courant — jamais silencieusement (§3.10).
    fn skip(&mut self, error: RecordError) {
        self.skipped_count += 1;
        self.sink.skipped(SkippedRecord {
            index: self.record_index,
            error,
        });
    }

    fn emit_progress(&mut self, step: ImportStep) {
        let progress = Progress {
            step,
            bytes_read: self.meter.bytes.get(),
            total_bytes: self.options.total_bytes_hint,
            records_emitted: self.records_emitted(),
        };
        self.sink.progress(progress);
    }

    /// Remonte la progression tous les `progress_every` enregistrements (§4).
    fn tick(&mut self) {
        self.since_progress += 1;
        if self.since_progress >= self.options.progress_every.max(1) {
            self.since_progress = 0;
            self.emit_progress(ImportStep::ReadingRecords);
        }
    }

    fn into_summary(self, format: SourceFormat) -> ImportSummary {
        ImportSummary {
            source_kind: SourceKind::GoogleTimeline,
            format,
            period_start_utc: self.period_start,
            period_end_utc: self.period_end,
            point_count: self.point_count,
            segment_count: self.segment_count,
            visit_count: self.visit_count,
            skipped_count: self.skipped_count,
            bytes_read: self.meter.bytes.get(),
        }
    }
}

// ---------------------------------------------------------------------------
// Détection de format et parcours en streaming
// ---------------------------------------------------------------------------

fn abort<E: de::Error>() -> E {
    E::custom(ABORT)
}

/// Racine du document : décide du format sur le premier jeton.
struct Document<'a, 'b>(&'a mut Ctx<'b>);

impl<'de> DeserializeSeed<'de> for Document<'_, '_> {
    type Value = ();

    fn deserialize<D: de::Deserializer<'de>>(self, deserializer: D) -> Result<(), D::Error> {
        deserializer.deserialize_any(self)
    }
}

impl<'a, 'b> Document<'a, 'b> {
    /// Le document est du JSON valide, mais pas un export connu (§3.10).
    fn unrecognised<E: de::Error>(self) -> Result<(), E> {
        let found = std::mem::take(&mut self.0.top_level_keys);
        self.0.fatal = Some(ParseError::UnrecognisedFormat { found });
        Err(abort())
    }
}

impl<'de> Visitor<'de> for Document<'_, '_> {
    type Value = ();

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("un export Google Timeline (tableau ou objet semanticSegments)")
    }

    fn visit_seq<A: SeqAccess<'de>>(self, mut seq: A) -> Result<(), A::Error> {
        self.0.format = Some(SourceFormat::GoogleDirectArray);
        drain(self.0, &mut seq)
    }

    fn visit_map<A: MapAccess<'de>>(self, mut map: A) -> Result<(), A::Error> {
        let ctx = self.0;

        while let Some(key) = map.next_key::<String>()? {
            if key == "semanticSegments" {
                ctx.format = Some(SourceFormat::GoogleSemanticSegments);
                map.next_value_seed(RecordArray(&mut *ctx))?;
            } else {
                if ctx.top_level_keys.len() < MAX_REPORTED_KEYS {
                    ctx.top_level_keys.push(key);
                }
                // Les clés sœurs inconnues sont sautées sans être matérialisées.
                map.next_value::<IgnoredAny>()?;
            }
        }

        if ctx.format.is_none() {
            return Document(ctx).unrecognised();
        }
        Ok(())
    }

    fn visit_bool<E: de::Error>(self, _: bool) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_i64<E: de::Error>(self, _: i64) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_u64<E: de::Error>(self, _: u64) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_f64<E: de::Error>(self, _: f64) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_str<E: de::Error>(self, _: &str) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_unit<E: de::Error>(self) -> Result<(), E> {
        self.unrecognised()
    }

    fn visit_none<E: de::Error>(self) -> Result<(), E> {
        self.unrecognised()
    }
}

/// Valeur de la clé `semanticSegments` : un tableau d'enregistrements.
struct RecordArray<'a, 'b>(&'a mut Ctx<'b>);

impl<'de> DeserializeSeed<'de> for RecordArray<'_, '_> {
    type Value = ();

    fn deserialize<D: de::Deserializer<'de>>(self, deserializer: D) -> Result<(), D::Error> {
        deserializer.deserialize_seq(self)
    }
}

impl<'de> Visitor<'de> for RecordArray<'_, '_> {
    type Value = ();

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("un tableau de segments")
    }

    fn visit_seq<A: SeqAccess<'de>>(self, mut seq: A) -> Result<(), A::Error> {
        drain(self.0, &mut seq)
    }
}

/// Cœur du streaming : un enregistrement est désérialisé, converti, poussé,
/// puis libéré avant de passer au suivant.
fn drain<'de, A: SeqAccess<'de>>(ctx: &mut Ctx<'_>, seq: &mut A) -> Result<(), A::Error> {
    while let Some(value) = seq.next_element::<Value>()? {
        match build(&value) {
            Ok(Record::Visit(visit)) => ctx.emit_visit(visit),
            Ok(Record::Segment(segment)) => ctx.emit_segment(segment),
            Ok(Record::Points(points)) => {
                for point in points {
                    ctx.emit_point(point);
                }
            }
            Err(error) => ctx.skip(error),
        }
        ctx.record_index += 1;
        ctx.tick();
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// Conversion d'un enregistrement
// ---------------------------------------------------------------------------

enum Record {
    Visit(Visit),
    Segment(Segment),
    Points(Vec<RawPoint>),
}

fn build(record: &Value) -> Result<Record, RecordError> {
    if let Some(visit) = record.get("visit") {
        return build_visit(record, visit).map(Record::Visit);
    }
    if let Some(activity) = record.get("activity") {
        return build_segment(record, activity).map(Record::Segment);
    }
    if let Some(path) = record.get("timelinePath") {
        return build_points(record, path).map(Record::Points);
    }
    Err(RecordError::UnknownShape)
}

fn build_visit(record: &Value, visit: &Value) -> Result<Visit, RecordError> {
    let arrival = field_time(record, &START_KEYS)?;
    let departure = field_time(record, &END_KEYS)?;
    let candidate = visit.get("topCandidate").unwrap_or(visit);
    let location = coords::from_json(candidate)?;

    Ok(Visit {
        arrival_ts_utc: arrival.utc_millis,
        arrival_tz_offset_minutes: arrival.tz_offset_minutes,
        departure_ts_utc: departure.utc_millis,
        departure_tz_offset_minutes: departure.tz_offset_minutes,
        lat: location.lat,
        lon: location.lon,
        radius_m: first_number(candidate, &["radiusMeters", "radius"]),
        external_place_ref: candidate
            .get("placeId")
            .and_then(Value::as_str)
            .map(str::to_owned),
        detection_confidence: probability(candidate).or_else(|| probability(visit)),
        source_kind: SourceKind::GoogleTimeline,
    })
}

fn build_segment(record: &Value, activity: &Value) -> Result<Segment, RecordError> {
    let start_ts = field_time(record, &START_KEYS)?;
    let end_ts = field_time(record, &END_KEYS)?;
    let start = coords::from_json(field(activity, &["start", "startLocation"])?)?;
    let end = coords::from_json(field(activity, &["end", "endLocation"])?)?;
    let candidate = activity.get("topCandidate").unwrap_or(activity);

    Ok(Segment {
        start_ts_utc: start_ts.utc_millis,
        start_tz_offset_minutes: start_ts.tz_offset_minutes,
        end_ts_utc: end_ts.utc_millis,
        end_tz_offset_minutes: end_ts.tz_offset_minutes,
        start_lat: start.lat,
        start_lon: start.lon,
        end_lat: end.lat,
        end_lon: end.lon,
        distance_m: first_number(activity, &["distanceMeters", "distance"]),
        detected_mode: candidate
            .get("type")
            .and_then(Value::as_str)
            .map_or(TravelMode::Unknown, travel_mode),
        mode_confidence: probability(candidate),
        source_kind: SourceKind::GoogleTimeline,
    })
}

fn build_points(record: &Value, path: &Value) -> Result<Vec<RawPoint>, RecordError> {
    let start = field_time(record, &START_KEYS)?;
    let entries = path.as_array().ok_or(RecordError::UnknownShape)?;

    let mut points = Vec::with_capacity(entries.len());
    for entry in entries {
        let location = coords::from_json(entry)?;
        let offset_minutes = entry
            .get("durationMinutesOffsetFromStartTime")
            .and_then(coords::as_f64)
            .unwrap_or_default();

        points.push(RawPoint {
            timestamp_utc: start.utc_millis + (offset_minutes * 60_000.0).round() as i64,
            // Un point de trajectoire hérite du fuseau du segment : il n'en
            // porte pas dans l'export (§5.5).
            tz_offset_minutes: start.tz_offset_minutes,
            lat: location.lat,
            lon: location.lon,
            accuracy_m: None,
            altitude_m: None,
            speed_ms: None,
            source_kind: SourceKind::GoogleTimeline,
        });
    }
    Ok(points)
}

/// Première clé présente parmi `keys`.
fn field<'v>(value: &'v Value, keys: &[&str]) -> Result<&'v Value, CoordError> {
    keys.iter()
        .find_map(|key| value.get(key))
        .ok_or(CoordError::Missing)
}

/// Horodatage porté par la première clé présente, y compris sous `duration`,
/// où les exports plus anciens rangent les bornes du segment.
fn field_time(record: &Value, keys: &[&str]) -> Result<Timestamp, TimeError> {
    for key in keys {
        if let Some(value) = record.get(key) {
            return time::from_json(value);
        }
    }
    if let Some(duration) = record.get("duration") {
        for key in keys {
            if let Some(value) = duration.get(key) {
                return time::from_json(value);
            }
        }
    }
    Err(TimeError::Missing)
}

fn first_number(value: &Value, keys: &[&str]) -> Option<f64> {
    keys.iter()
        .find_map(|key| value.get(key))
        .and_then(coords::as_f64)
}

fn probability(value: &Value) -> Option<f32> {
    value
        .get("probability")
        .and_then(coords::as_f64)
        .map(|p| p as f32)
}

/// Traduit le libellé de mode de la source vers le modèle (§5.1).
///
/// Les exports mélangent les casses (`walking`, `IN_PASSENGER_VEHICLE`) et
/// font évoluer le vocabulaire ; une valeur inconnue devient
/// [`TravelMode::Unknown`] plutôt que de faire échouer l'enregistrement.
fn travel_mode(raw: &str) -> TravelMode {
    match raw.trim().to_ascii_lowercase().replace('-', "_").as_str() {
        "walking" | "on_foot" | "walk" => TravelMode::Walking,
        "running" | "run" => TravelMode::Running,
        "cycling" | "on_bicycle" | "biking" => TravelMode::Cycling,
        "in_passenger_vehicle" | "in_vehicle" | "driving" | "in_taxi" | "in_car" => {
            TravelMode::InVehicle
        }
        "in_bus" => TravelMode::InBus,
        "in_train" | "in_subway" | "in_tram" | "in_rail" => TravelMode::InTrain,
        "in_ferry" | "sailing" | "boating" => TravelMode::Boat,
        "motorcycling" => TravelMode::Motorcycling,
        "flying" | "in_flight" | "flight" => TravelMode::Flight,
        _ => TravelMode::Unknown,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn modes_insensibles_a_la_casse_et_au_separateur() {
        assert_eq!(travel_mode("walking"), TravelMode::Walking);
        assert_eq!(travel_mode("IN_PASSENGER_VEHICLE"), TravelMode::InVehicle);
        assert_eq!(travel_mode("in-passenger-vehicle"), TravelMode::InVehicle);
        assert_eq!(travel_mode(" Flying "), TravelMode::Flight);
    }

    #[test]
    fn mode_inconnu_ne_fait_pas_echouer() {
        assert_eq!(travel_mode("TELEPORTATION"), TravelMode::Unknown);
    }
}
