// Golden tests des trois vues (§3.10), en anglais et en français (§3.9).
//
// Les données sont de la **sortie de pipeline** figée : ce que les vues
// reçoivent en vrai, à ceci près qu'aucun appel au pont n'est nécessaire. Une
// donnée absente ici est une donnée que le pipeline a écartée — c'est le
// contrat, et c'est ce qui permet de tester le rendu sans rejouer §5.4.

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/bridge/generated/api/timeline.dart';
import 'package:odysseia/bridge/generated/api/import.dart';
import 'package:odysseia/data/import_service.dart';
import 'package:odysseia/features/import/import_view.dart';
import 'package:odysseia/features/settings/settings_view.dart';
import 'package:odysseia/features/stats/stats_view.dart';
import 'package:odysseia/features/story/story_view.dart';
import 'package:odysseia/features/video/video_view.dart';

import 'golden_harness.dart';

/// 2024-03-15, heure de Paris.
const int _morning = 1710486720000;

ResolvedVisitOutput _visit({
  required int id,
  required int arrival,
  required int minutes,
  String? label,
  PlaceOrigin origin = PlaceOrigin.userPlace,
}) => ResolvedVisitOutput(
  id: id,
  arrivalTsUtc: arrival,
  arrivalTzOffsetMinutes: 60,
  departureTsUtc: arrival + minutes * 60000,
  departureTzOffsetMinutes: 60,
  lat: 48.8584,
  lon: 2.2945,
  placeLabel: label,
  placeOrigin: origin,
  placeId: label == null ? null : 1,
);

ResolvedSegmentOutput _segment({
  required int id,
  required int start,
  required int minutes,
  required TravelMode mode,
  bool corrected = false,
  String? from,
  String? to,
}) => ResolvedSegmentOutput(
  id: id,
  startTsUtc: start,
  startTzOffsetMinutes: 60,
  endTsUtc: start + minutes * 60000,
  endTzOffsetMinutes: 60,
  startLat: 48.8584,
  startLon: 2.2945,
  endLat: 48.8606,
  endLon: 2.3376,
  distanceM: 3210.5,
  mode: mode,
  corrected: corrected,
  startPlaceLabel: from,
  endPlaceLabel: to,
);

BucketOutput _bucket(String key, {int count = 1, int durationMs = 0, double distanceM = 0, int? placeId}) =>
    BucketOutput(
      key: key,
      placeId: placeId,
      count: count,
      durationMs: durationMs,
      distanceM: distanceM,
    );

void main() {
  group('Récit (§3.3)', () {
    goldenTest(
      'une journée typique',
      name: 'story_day',
      () => StoryView(
        granularity: StoryGranularity.day,
        periodLabel: '15/03/2024',
        visits: [
          _visit(id: 1, arrival: _morning, minutes: 53, label: 'Maison'),
          _visit(
            id: 2,
            arrival: _morning + 7200000,
            minutes: 480,
            label: 'Bureau',
          ),
        ],
        segments: [
          _segment(
            id: 1,
            start: _morning + 3180000,
            minutes: 36,
            mode: TravelMode.cycling,
            corrected: true,
            from: 'Maison',
            to: 'Bureau',
          ),
          _segment(
            id: 2,
            start: _morning + 36000000,
            minutes: 42,
            mode: TravelMode.inTrain,
            from: 'Bureau',
            to: 'Maison',
          ),
        ],
      ),
    );

    goldenTest(
      'un lieu que le pipeline n\'a pas su nommer',
      name: 'story_unnamed',
      () => StoryView(
        granularity: StoryGranularity.day,
        periodLabel: '15/03/2024',
        visits: [
          // §5.4 : dernier recours, ni user_place ni geo_place.
          _visit(
            id: 1,
            arrival: _morning,
            minutes: 25,
            origin: PlaceOrigin.coordinates,
          ),
        ],
        segments: const [],
      ),
    );

    goldenTest(
      'période vide',
      name: 'story_empty',
      () => const StoryView(
        granularity: StoryGranularity.week,
        periodLabel: '11–17/03/2024',
        visits: [],
        segments: [],
      ),
    );

    goldenTest(
      'zones privées actives',
      name: 'story_private_zones',
      () => StoryView(
        granularity: StoryGranularity.day,
        periodLabel: '15/03/2024',
        privateZonesActive: true,
        visits: [_visit(id: 1, arrival: _morning, minutes: 53, label: 'Maison')],
        segments: const [],
      ),
    );
  });

  group('Stats (§3.4)', () {
    goldenTest(
      'les six statistiques',
      name: 'stats_full',
      () => StatsView(
        stats: StatsOutput(
          density: [
            HeatCellOutput(lat: 48.85, lon: 2.29, count: 42),
            HeatCellOutput(lat: 48.86, lon: 2.33, count: 17),
          ],
          places: [
            _bucket('Maison', count: 128, durationMs: 486000000, placeId: 1),
            _bucket('Bureau', count: 96, durationMs: 302000000, placeId: 2),
            _bucket('Salle de sport', count: 24, durationMs: 43200000, placeId: 3),
          ],
          modes: [
            _bucket('cycling', count: 210, durationMs: 226800000, distanceM: 1_240_000),
            _bucket('walking', count: 180, durationMs: 129600000, distanceM: 320_000),
            _bucket('in_train', count: 42, durationMs: 151200000, distanceM: 2_100_000),
          ],
          hours: [
            for (var hour = 6; hour < 12; hour++)
              _bucket('$hour', count: 10 + hour * 3),
          ],
          weekdays: [
            _bucket('monday', count: 48),
            _bucket('tuesday', count: 52),
            _bucket('wednesday', count: 44),
            _bucket('thursday', count: 50),
            _bucket('friday', count: 46),
            _bucket('saturday', count: 22),
            _bucket('sunday', count: 18),
          ],
          totalDistanceM: 3_660_000,
          visitCount: 248,
          segmentCount: 432,
        ),
        activeModes: const [TravelMode.cycling],
      ),
    );

    goldenTest(
      'aucune donnée pour ces filtres',
      name: 'stats_empty',
      () => StatsView(stats: emptyStats()),
    );
  });

  group('Vidéo (§3.5)', () {
    goldenTest(
      'réglages et plan calculé',
      name: 'video_plan',
      () => VideoView(
        settings: const VideoSettings(
          durationS: 45,
          style: VideoStyle.night,
          title: 'Mon année 2024',
        ),
        periodLabel: '2024',
        plan: VideoPlanResult(
          error: null,
          fps: 30,
          frames: [
            FrameOutput(
              index: 0,
              timestampUtc: _morning,
              revealedPoints: 12,
              revealedSegments: 1,
            ),
            FrameOutput(
              index: 1349,
              timestampUtc: _morning + 86400000,
              revealedPoints: 4820,
              revealedSegments: 432,
            ),
          ],
        ),
      ),
    );

    goldenTest(
      'avertissement de lenteur en web',
      name: 'video_web_warning',
      () => const VideoView(
        settings: VideoSettings(),
        plan: null,
        periodLabel: '2024',
        isWeb: true,
      ),
    );

    goldenTest(
      'rien à animer — souvent parce que les zones privées ont tout écarté',
      name: 'video_nothing_to_render',
      () => VideoView(
        settings: const VideoSettings(),
        periodLabel: '2024',
        plan: VideoPlanResult(
          error: VideoPlanErrorKind.nothingToRender,
          fps: 0,
          frames: const [],
        ),
      ),
    );
  });

  group('Import (§3.3)', () {
    goldenTest(
      'au repos, sans sélecteur de fichier',
      name: 'import_idle',
      () => const ImportView(state: ImportIdle(), pickerAvailable: false),
    );

    goldenTest(
      'lecture en cours',
      name: 'import_running',
      () => const ImportView(
        state: ImportRunning(
          step: ImportStepKind.readingRecords,
          percent: 42,
          records: 128400,
        ),
      ),
    );

    goldenTest(
      'terminé, avec rejets et export plus court',
      name: 'import_done_warning',
      () => ImportView(
        // §4 : l'avertissement de période plus courte, et §3.10 : les rejets
        // sont montrés, jamais tus.
        state: ImportDone(
          shorterThanPrevious: true,
          summary: ImportSummaryOutput(
            format: 'google_direct_array',
            periodStartUtc: PlatformInt64Util.from(1710486720000),
            periodEndUtc: PlatformInt64Util.from(1710493440000),
            pointCount: 482013,
            segmentCount: 4321,
            visitCount: 2480,
            skippedCount: 17,
            bytesRead: PlatformInt64Util.from(268435456),
          ),
        ),
      ),
    );

    goldenTest(
      'échec — un cas, un message',
      name: 'import_failed',
      () => const ImportView(state: ImportFailed(ImportErrorKind.corruptJson)),
    );
  });

  group('Réglages (§2, §3.7)', () {
    goldenTest(
      'capacités et intégrations',
      name: 'settings_full',
      () => SettingsView(
        capabilities: [
          const Capability(
            label: 'Local database',
            status: CapabilityStatus.available,
          ),
          const Capability(
            label: 'Compute core',
            status: CapabilityStatus.available,
          ),
          const Capability(
            label: 'Video export',
            status: CapabilityStatus.notWired,
          ),
        ],
        onIntegrationsChanged: (_) {},
        onExport: () {},
        onDelete: () {},
      ),
    );
  });
}
