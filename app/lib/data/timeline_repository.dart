// Chemin **unique** vers les données Timeline côté Dart (§5.4).
//
// Toutes les méthodes publiques d'ici renvoient des types déjà passés par le
// pipeline Rust : zones privées écartées, noms résolus, corrections
// appliquées, filtres de vue appliqués. Aucune ne renvoie de ligne brute.
//
// C'est délibérément la seule classe de l'app autorisée à lire les tables
// §5.1 : `_gather` est privée, et les vues n'ont aucun moyen d'obtenir un
// `RawPoint` de la base. Une vue qui voudrait contourner les zones privées
// devrait modifier ce fichier — ce qui se voit en revue.

import 'package:drift/drift.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

import '../bridge/generated/api/timeline.dart';
import 'database.dart';

/// Convertit un entier Dart vers l'entier 64 bits du pont.
///
/// Nécessaire parce que JavaScript n'a pas d'entier 64 bits : `PlatformInt64`
/// vaut `int` en natif et `BigInt` en web. Passer par ce helper est ce qui
/// permet au même code de compiler pour les deux cibles (§3.8).
PlatformInt64 _i64(int value) => PlatformInt64Util.from(value);

/// Fenêtre temporelle demandée par une vue.
class Period {
  /// Crée une fenêtre.
  const Period({required this.startUtc, required this.endUtc});

  /// Début inclus, en millisecondes UTC.
  final int startUtc;

  /// Fin incluse, en millisecondes UTC.
  final int endUtc;
}

/// Accès aux données Timeline, via le pipeline §5.4 et lui seul.
class TimelineRepository {
  /// Crée le dépôt sur une base ouverte.
  TimelineRepository(this._db);

  final OdysseiaDatabase _db;

  /// Taille de maille de la heatmap, en degrés (§3.4).
  static const double heatmapCellSizeDeg = 0.01;

  /// Données du Récit pour une période (§3.3).
  Future<PipelineResponse> story(Period period, {FiltersInput? filters}) async {
    final request = await _gather(period, filters);
    return runPipeline(request: request);
  }

  /// Statistiques pour une période et des filtres (§3.4).
  Future<StatsOutput> stats(Period period, {FiltersInput? filters}) async {
    final request = await _gather(period, filters);
    return computeStats(request: request, cellSizeDeg: heatmapCellSizeDeg);
  }

  /// Plan de frames de la vidéo souvenir (§3.5).
  Future<VideoPlanResult> videoPlan(
    Period period,
    VideoParams params, {
    FiltersInput? filters,
  }) async {
    final request = await _gather(period, filters);
    return planVideo(request: request, params: params);
  }

  /// Rassemble ce dont le pipeline a besoin : les données de la période
  /// (§5.1) **et** toute la zone utilisateur (§5.2).
  ///
  /// Les deux partent ensemble, en un seul appel. Il n'existe pas de variante
  /// qui livrerait les unes sans les autres, donc pas de fenêtre pendant
  /// laquelle une donnée privée pourrait ressortir (§3.7).
  Future<PipelineRequest> _gather(Period period, FiltersInput? filters) async {
    final points = await (_db.select(_db.rawPoints)
          ..where(
            (t) =>
                t.timestampUtc.isBiggerOrEqualValue(period.startUtc) &
                t.timestampUtc.isSmallerOrEqualValue(period.endUtc),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.timestampUtc)]))
        .get();

    final visits = await (_db.select(_db.visits)
          ..where(
            (t) =>
                t.arrivalTsUtc.isSmallerOrEqualValue(period.endUtc) &
                t.departureTsUtc.isBiggerOrEqualValue(period.startUtc),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.arrivalTsUtc)]))
        .get();

    final segments = await (_db.select(_db.segments)
          ..where(
            (t) =>
                t.startTsUtc.isSmallerOrEqualValue(period.endUtc) &
                t.endTsUtc.isBiggerOrEqualValue(period.startUtc),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.startTsUtc)]))
        .get();

    // Zone utilisateur : toujours en entier, jamais filtrée par période. Une
    // zone privée définie l'an dernier doit s'appliquer aux données
    // d'aujourd'hui (§3.7).
    final userPlaces = await _db.select(_db.userPlaces).get();
    final privateZones = await _db.select(_db.privateZones).get();
    final overrides = await _db.select(_db.userSegmentOverrides).get();

    return PipelineRequest(
      points: [
        for (final row in points)
          PointInput(
            timestampUtc: _i64(row.timestampUtc),
            tzOffsetMinutes: row.tzOffsetMinutes,
            lat: row.lat,
            lon: row.lon,
          ),
      ],
      visits: [
        for (final row in visits)
          VisitInput(
            id: _i64(row.id),
            arrivalTsUtc: _i64(row.arrivalTsUtc),
            arrivalTzOffsetMinutes: row.arrivalTzOffsetMinutes,
            departureTsUtc: _i64(row.departureTsUtc),
            departureTzOffsetMinutes: row.departureTzOffsetMinutes,
            lat: row.lat,
            lon: row.lon,
          ),
      ],
      segments: [
        for (final row in segments)
          SegmentInput(
            id: _i64(row.id),
            startTsUtc: _i64(row.startTsUtc),
            startTzOffsetMinutes: row.startTzOffsetMinutes,
            endTsUtc: _i64(row.endTsUtc),
            endTzOffsetMinutes: row.endTzOffsetMinutes,
            startLat: row.startLat,
            startLon: row.startLon,
            endLat: row.endLat,
            endLon: row.endLon,
            distanceM: row.distanceM,
            detectedMode: travelModeFromKey(row.detectedMode),
          ),
      ],
      userPlaces: [
        for (final row in userPlaces)
          UserPlaceInput(
            id: _i64(row.id),
            label: row.label,
            lat: row.lat,
            lon: row.lon,
            radiusM: row.radiusM,
          ),
      ],
      privateZones: [
        for (final row in privateZones)
          PrivateZoneInput(
            id: _i64(row.id),
            label: row.label,
            lat: row.lat,
            lon: row.lon,
            radiusM: row.radiusM,
            polygon: _polygonOf(row.polygonGeojson),
          ),
      ],
      overrides: [
        for (final row in overrides)
          OverrideInput(
            id: _i64(row.id),
            localDate: row.localDate,
            startLatR: row.startLatR,
            startLonR: row.startLonR,
            endLatR: row.endLatR,
            endLonR: row.endLonR,
            correctedMode: travelModeFromKey(row.correctedMode),
            sourceStartTsUtc: _i64(row.sourceStartTsUtc),
          ),
      ],
      filters: filters ?? const FiltersInput(modes: []),
    );
  }

  /// Aplatit un tracé GeoJSON en paires (latitude, longitude).
  ///
  /// Aucune géométrie n'est calculée ici : le test d'appartenance appartient
  /// au pipeline (§6.1). On ne fait que transporter les sommets.
  Float64List _polygonOf(String? geojson) {
    if (geojson == null || geojson.isEmpty) return Float64List(0);
    final numbers = RegExp(r'-?\d+(?:\.\d+)?')
        .allMatches(geojson)
        .map((match) => double.parse(match.group(0)!))
        .toList();
    return Float64List.fromList(numbers);
  }
}

/// Traduit la clé stockée en base vers l'énumération du pont.
///
/// Les clés viennent du parseur Rust (§5.1) ; cette fonction ne fait que les
/// relire, elle n'invente aucune règle de détection.
TravelMode travelModeFromKey(String key) => switch (key) {
  'walking' => TravelMode.walking,
  'running' => TravelMode.running,
  'cycling' => TravelMode.cycling,
  'in_vehicle' => TravelMode.inVehicle,
  'in_bus' => TravelMode.inBus,
  'in_train' => TravelMode.inTrain,
  'boat' => TravelMode.boat,
  'motorcycling' => TravelMode.motorcycling,
  'flight' => TravelMode.flight,
  _ => TravelMode.unknown,
};
