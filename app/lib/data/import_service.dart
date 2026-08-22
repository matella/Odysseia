// Import d'un export Timeline (§3.1, §4).
//
// Le parseur Rust pousse des lots au fil de la lecture ; ce service les insère
// par transactions groupées (§4). Le fichier n'est jamais chargé en entier,
// d'aucun côté.
//
// Aucune logique de parsing ici (§6.1) : ce fichier orchestre une transaction
// et rien d'autre. Il ne sait pas ce qu'est un `semanticSegments`.

import 'package:drift/drift.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

import '../bridge/generated/api/import.dart';
import 'database.dart';

/// Limite de taille appliquée à l'import (§4).
///
/// 500 Mo confortables en natif. La politique appartient à l'app, pas au
/// cœur : c'est elle qui connaît la plateforme.
const int nativeMaxImportBytes = 500 * 1024 * 1024;

/// Seuil au-delà duquel le web est déconseillé (§4).
const int webWarnImportBytes = 200 * 1024 * 1024;

/// État d'un import en cours ou terminé, tel que l'UI l'affiche.
sealed class ImportState {
  const ImportState();
}

/// Rien en cours.
class ImportIdle extends ImportState {
  /// Crée l'état.
  const ImportIdle();
}

/// Import en cours (§4).
class ImportRunning extends ImportState {
  /// Crée l'état.
  const ImportRunning({required this.step, this.percent, this.records = 0});

  /// Étape en cours.
  final ImportStepKind step;

  /// Avancement, de 0 à 100, si la taille est connue.
  final double? percent;

  /// Enregistrements lus jusqu'ici.
  final int records;
}

/// Import terminé.
class ImportDone extends ImportState {
  /// Crée l'état.
  const ImportDone({required this.summary, this.shorterThanPrevious = false});

  /// Bilan renvoyé par le cœur.
  final ImportSummaryOutput summary;

  /// Le nouvel export couvre-t-il **moins** que le précédent ?
  ///
  /// §4 impose d'avertir : Google ne garantit pas que les exports successifs
  /// couvrent tout l'historique, et remplacer sans prévenir ferait perdre des
  /// données plus anciennes.
  final bool shorterThanPrevious;
}

/// Import échoué (§3.10) — une cause, un message traduit.
class ImportFailed extends ImportState {
  /// Crée l'état.
  const ImportFailed(this.kind);

  /// Cause de l'échec.
  final ImportErrorKind kind;
}

/// Orchestre un import de bout en bout.
class ImportService {
  /// Crée le service sur une base ouverte.
  ImportService(this._db);

  final OdysseiaDatabase _db;

  /// Importe `path`, en remplaçant l'import courant (§3.1).
  ///
  /// Tout se joue dans une transaction : un échec à mi-chemin laisse l'ancien
  /// import en place plutôt qu'une base à moitié vide (§3.10). La zone
  /// utilisateur (§5.2) n'est jamais touchée.
  Stream<ImportState> import(String path, {int? maxBytes}) async* {
    final previous = await _db.currentImport();
    final events = importTimeline(
      path: path,
      maxBytes: PlatformInt64Util.from(maxBytes ?? nativeMaxImportBytes),
    );

    ImportSummaryOutput? summary;
    ImportErrorKind? failure;
    final buffered = <ImportState>[];

    await _db.transaction(() async {
      await _db.wipeImportedZone();
      final batchId = await _db.into(_db.importBatches).insert(
        ImportBatchesCompanion.insert(
          importedAt: DateTime.now().millisecondsSinceEpoch,
          sourceKind: 'google_timeline',
          sourceFilePath: path,
          sourceFormatDetected: 'pending',
        ),
      );

      await for (final event in events) {
        switch (event) {
          case ImportEvent_Progress(field0: final progress):
            buffered.add(
              ImportRunning(
                step: progress.step,
                percent: progress.percent,
                records: progress.records,
              ),
            );
          case ImportEvent_Chunk(field0: final chunk):
            await _insert(batchId, chunk);
          case ImportEvent_Finished(field0: final value):
            summary = value;
          case ImportEvent_Failed(field0: final kind):
            failure = kind;
        }
      }

      if (failure != null || summary == null) {
        // Annule le lot fantôme et tout ce qui a pu être inséré : un import
        // raté ne laisse pas de trace (§3.10).
        throw _ImportAborted();
      }

      await (_db.update(_db.importBatches)
            ..where((t) => t.id.equals(batchId)))
          .write(
            ImportBatchesCompanion(
              sourceFormatDetected: Value(summary!.format),
              periodStart: Value(summary!.periodStartUtc?.toInt()),
              periodEnd: Value(summary!.periodEndUtc?.toInt()),
              pointCount: Value(summary!.pointCount),
            ),
          );
    }).onError<_ImportAborted>((_, _) {});

    yield* Stream.fromIterable(buffered);

    if (failure != null) {
      yield ImportFailed(failure!);
      return;
    }
    yield ImportDone(
      summary: summary!,
      shorterThanPrevious: _isShorter(previous, summary!),
    );
  }

  /// Insertion par lots, jamais ligne par ligne (§4).
  Future<void> _insert(int batchId, ImportChunk chunk) async {
    await _db.batch((b) {
      b.insertAll(_db.rawPoints, [
        for (final point in chunk.points)
          RawPointsCompanion.insert(
            batchId: batchId,
            timestampUtc: point.timestampUtc.toInt(),
            tzOffsetMinutes: point.tzOffsetMinutes,
            lat: point.lat,
            lon: point.lon,
            sourceKind: 'google_timeline',
          ),
      ]);
      b.insertAll(_db.visits, [
        for (final visit in chunk.visits)
          VisitsCompanion.insert(
            batchId: batchId,
            arrivalTsUtc: visit.arrivalTsUtc.toInt(),
            arrivalTzOffsetMinutes: visit.arrivalTzOffsetMinutes,
            departureTsUtc: visit.departureTsUtc.toInt(),
            departureTzOffsetMinutes: visit.departureTzOffsetMinutes,
            lat: visit.lat,
            lon: visit.lon,
            radiusM: Value(visit.radiusM),
            externalPlaceRef: Value(visit.externalPlaceRef),
            sourceKind: 'google_timeline',
          ),
      ]);
      b.insertAll(_db.segments, [
        for (final segment in chunk.segments)
          SegmentsCompanion.insert(
            batchId: batchId,
            startTsUtc: segment.startTsUtc.toInt(),
            startTzOffsetMinutes: segment.startTzOffsetMinutes,
            endTsUtc: segment.endTsUtc.toInt(),
            endTzOffsetMinutes: segment.endTzOffsetMinutes,
            startLat: segment.startLat,
            startLon: segment.startLon,
            endLat: segment.endLat,
            endLon: segment.endLon,
            distanceM: Value(segment.distanceM),
            detectedMode: segment.detectedMode,
            sourceKind: 'google_timeline',
          ),
      ]);
    });
  }

  /// Le nouvel export couvre-t-il une période plus courte ? (§4)
  bool _isShorter(ImportBatch? previous, ImportSummaryOutput summary) {
    if (previous == null) return false;
    final oldStart = previous.periodStart;
    final oldEnd = previous.periodEnd;
    final newStart = summary.periodStartUtc?.toInt();
    final newEnd = summary.periodEndUtc?.toInt();
    if (oldStart == null || oldEnd == null || newStart == null || newEnd == null) {
      return false;
    }
    return newStart > oldStart || newEnd < oldEnd;
  }
}

class _ImportAborted implements Exception {}
