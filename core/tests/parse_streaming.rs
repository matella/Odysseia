//! Preuve que le parsing est bien **en streaming** (§4) : la mémoire allouée
//! reste bornée quelle que soit la taille de l'entrée.
//!
//! Ce binaire de test ne contient **qu'un seul test** : l'allocateur global
//! instrumenté ci-dessous compte les allocations de tout le processus, et des
//! tests concurrents fausseraient la mesure.

use std::alloc::{GlobalAlloc, Layout, System};
use std::io::Read;
use std::sync::atomic::{AtomicUsize, Ordering};

use timeline_core::model::{RawPoint, Segment, Visit};
use timeline_core::parse::{ParseOptions, RecordSink, TimelineImporter, google::GoogleImporter};

static CURRENT: AtomicUsize = AtomicUsize::new(0);
static PEAK: AtomicUsize = AtomicUsize::new(0);

struct Tracking;

// SAFETY: délègue tout au System allocator, ne fait qu'incrémenter des
// compteurs atomiques autour.
unsafe impl GlobalAlloc for Tracking {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let ptr = unsafe { System.alloc(layout) };
        if !ptr.is_null() {
            let current = CURRENT.fetch_add(layout.size(), Ordering::Relaxed) + layout.size();
            PEAK.fetch_max(current, Ordering::Relaxed);
        }
        ptr
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        CURRENT.fetch_sub(layout.size(), Ordering::Relaxed);
        unsafe { System.dealloc(ptr, layout) };
    }
}

#[global_allocator]
static ALLOCATOR: Tracking = Tracking;

/// Génère un export `[{...},{...}]` à la volée, sans jamais le matérialiser.
struct GeneratedExport {
    remaining: usize,
    buffer: Vec<u8>,
    cursor: usize,
    started: bool,
    finished: bool,
    total: usize,
}

impl GeneratedExport {
    fn new(records: usize) -> Self {
        Self {
            remaining: records,
            buffer: Vec::with_capacity(256),
            cursor: 0,
            started: false,
            finished: false,
            total: 0,
        }
    }

    fn refill(&mut self) {
        self.buffer.clear();
        self.cursor = 0;

        if !self.started {
            self.started = true;
            self.buffer.extend_from_slice(b"[");
            return;
        }
        if self.remaining == 0 {
            if !self.finished {
                self.finished = true;
                self.buffer.extend_from_slice(b"]");
            }
            return;
        }

        if self.remaining > 1 {
            self.buffer.extend_from_slice(RECORD.as_bytes());
            self.buffer.extend_from_slice(b",");
        } else {
            self.buffer.extend_from_slice(RECORD.as_bytes());
        }
        self.remaining -= 1;
    }
}

const RECORD: &str = r#"{"startTime":"2024-01-02T10:00:00.000Z","endTime":"2024-01-02T11:00:00.000Z","visit":{"topCandidate":{"placeId":"ChIJxxxxxxxxxxxxxxxxxxxxxxx","placeLocation":{"latLng":"48.8584°, 2.2945°"}}}}"#;

impl Read for GeneratedExport {
    fn read(&mut self, out: &mut [u8]) -> std::io::Result<usize> {
        if self.cursor >= self.buffer.len() {
            if self.finished {
                return Ok(0);
            }
            self.refill();
            if self.buffer.is_empty() {
                return Ok(0);
            }
        }
        let n = (self.buffer.len() - self.cursor).min(out.len());
        out[..n].copy_from_slice(&self.buffer[self.cursor..self.cursor + n]);
        self.cursor += n;
        self.total += n;
        Ok(n)
    }
}

/// Compte sans rien accumuler.
#[derive(Default)]
struct CountingSink {
    visits: u64,
}

impl RecordSink for CountingSink {
    fn point(&mut self, _: RawPoint) {}
    fn segment(&mut self, _: Segment) {}
    fn visit(&mut self, _: Visit) {
        self.visits += 1;
    }
}

const RECORDS: usize = 40_000;
/// Plafond volontairement large : on vérifie un ordre de grandeur (« borné »),
/// pas une valeur exacte qui rendrait le test fragile.
const PEAK_MAX_BYTES: usize = 1024 * 1024;

#[test]
fn la_memoire_reste_bornee_sur_un_gros_export() {
    let input_bytes = RECORDS * (RECORD.len() + 1) + 1;
    assert!(
        input_bytes > 4 * 1024 * 1024,
        "entrée trop petite pour être probante : {input_bytes} octets"
    );

    let mut reader = GeneratedExport::new(RECORDS);
    let mut sink = CountingSink::default();

    let baseline = CURRENT.load(Ordering::Relaxed);
    PEAK.store(baseline, Ordering::Relaxed);

    let summary = GoogleImporter
        .parse(&mut reader, &mut sink, &ParseOptions::default())
        .expect("import réussi");

    let peak = PEAK.load(Ordering::Relaxed).saturating_sub(baseline);

    assert_eq!(summary.visit_count, RECORDS as u64);
    assert_eq!(sink.visits, RECORDS as u64);
    assert_eq!(summary.bytes_read, input_bytes as u64);
    assert!(
        peak < PEAK_MAX_BYTES,
        "pic mémoire {peak} octets pour {input_bytes} octets d'entrée — le \
         document est chargé en mémoire, ce n'est plus du streaming (§4)"
    );
}
