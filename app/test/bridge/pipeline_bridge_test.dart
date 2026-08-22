// Le pont fonctionne, et le pipeline §5.4 s'applique **à travers** lui.
//
// Sans ce test, `core/src/pipeline/` serait du code Rust parfaitement testé et
// parfaitement inatteignable : les vues ne pourraient pas s'en servir, et la
// tentation de refaire les calculs en Dart (§6.1) deviendrait irrésistible.
//
// Il exige la bibliothèque native, construite par `cargo build` dans
// `bridge/`. Voir `test/bridge/rust_lib.dart` pour la résolution du chemin.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:odysseia/bridge/generated/api/timeline.dart';

import 'rust_lib.dart';

void main() {
  setUpAll(initRustForTests);

  /// Paris, Lyon, Marseille — trois points de repère réutilisés partout.
  const maison = (48.8584, 2.2945);
  const bureau = (48.8606, 2.3376);
  const secret = (43.2965, 5.3698);

  PointInput pointAt((double, double) at, int ts) => PointInput(
    timestampUtc: ts,
    tzOffsetMinutes: 60,
    lat: at.$1,
    lon: at.$2,
  );

  VisitInput visitAt((double, double) at, int id, int arrival) => VisitInput(
    id: id,
    arrivalTsUtc: arrival,
    arrivalTzOffsetMinutes: 60,
    departureTsUtc: arrival + 3600000,
    departureTzOffsetMinutes: 60,
    lat: at.$1,
    lon: at.$2,
  );

  SegmentInput segmentFrom(
    (double, double) from,
    (double, double) to, {
    required int id,
    required int start,
    TravelMode mode = TravelMode.walking,
  }) => SegmentInput(
    id: id,
    startTsUtc: start,
    startTzOffsetMinutes: 60,
    endTsUtc: start + 1800000,
    endTzOffsetMinutes: 60,
    startLat: from.$1,
    startLon: from.$2,
    endLat: to.$1,
    endLon: to.$2,
    distanceM: 3210.5,
    detectedMode: mode,
  );

  PrivateZoneInput circleAt((double, double) at, {required String label}) =>
      PrivateZoneInput(
        id: 1,
        label: label,
        lat: at.$1,
        lon: at.$2,
        radiusM: 1000,
        polygon: Float64List(0),
      );

  test('le pont est joignable et renvoie la sortie du pipeline', () async {
    final response = await runPipeline(
      request: PipelineRequest(
        points: [pointAt(maison, 1710489600000)],
        visits: [visitAt(maison, 1, 1710489600000)],
        segments: [segmentFrom(maison, bureau, id: 1, start: 1710489900000)],
        userPlaces: const [],
        privateZones: const [],
        overrides: const [],
        filters: const FiltersInput(modes: []),
      ),
    );

    expect(response.points, hasLength(1));
    expect(response.visits, hasLength(1));
    expect(response.segments, hasLength(1));
    expect(response.visits.single.id, 1);
  });

  test('une zone privée filtre à travers le pont (§3.7)', () async {
    // La garantie qui compte : ce n'est pas l'UI qui cache la donnée, c'est le
    // pipeline qui ne la livre pas.
    final response = await runPipeline(
      request: PipelineRequest(
        points: [
          pointAt(maison, 1710489600000),
          pointAt(secret, 1710493200000),
        ],
        visits: [visitAt(secret, 2, 1710493200000)],
        segments: [segmentFrom(maison, secret, id: 1, start: 1710489900000)],
        userPlaces: const [],
        privateZones: [circleAt(secret, label: 'Chez mes parents')],
        overrides: const [],
        filters: const FiltersInput(modes: []),
      ),
    );

    expect(response.points, hasLength(1), reason: 'la position privée est absente');
    expect(response.points.single.lat, closeTo(maison.$1, 1e-9));
    expect(response.visits, isEmpty, reason: 'l\'arrêt privé est absent');
    expect(
      response.segments,
      isEmpty,
      reason: 'le trajet touchant la zone privée est absent',
    );
  });

  test('un lieu nommé traverse le pont (§5.2)', () async {
    final response = await runPipeline(
      request: PipelineRequest(
        points: const [],
        visits: [visitAt(maison, 1, 1710489600000)],
        segments: const [],
        userPlaces: const [
          UserPlaceInput(
            id: 7,
            label: 'Maison',
            lat: 48.8584,
            lon: 2.2945,
            radiusM: 200,
          ),
        ],
        privateZones: const [],
        overrides: const [],
        filters: const FiltersInput(modes: []),
      ),
    );

    expect(response.visits.single.placeLabel, 'Maison');
    expect(response.visits.single.placeOrigin, PlaceOrigin.userPlace);
    expect(response.visits.single.placeId, 7);
  });

  test('une correction de mode traverse le pont (§5.4, étape 3)', () async {
    // 2024-03-15, départ 08:05 UTC (+01:00) : jour 19797, extrémités
    // arrondies à 2 décimales — l'arrondi vient de `core/`, reproduit ici en
    // littéral parce qu'un test ne doit pas réimplémenter la règle.
    final response = await runPipeline(
      request: PipelineRequest(
        points: const [],
        visits: const [],
        segments: [
          segmentFrom(maison, bureau, id: 1, start: 1710489900000),
        ],
        userPlaces: const [],
        privateZones: const [],
        overrides: const [
          OverrideInput(
            id: 1,
            localDate: 19797,
            startLatR: 48.86,
            startLonR: 2.29,
            endLatR: 48.86,
            endLonR: 2.34,
            correctedMode: TravelMode.cycling,
            sourceStartTsUtc: 1710489900000,
          ),
        ],
        filters: const FiltersInput(modes: []),
      ),
    );

    expect(response.segments.single.mode, TravelMode.cycling);
    expect(response.segments.single.corrected, isTrue);
    expect(response.orphanOverrideIds, isEmpty);
  });

  test('les statistiques ne voient pas les zones privées (§3.4 + §3.7)', () async {
    // Une stat calculée sur des données non filtrées serait une fuite aussi
    // grave qu'un point affiché sur la carte : le total trahirait la visite.
    final request = PipelineRequest(
      points: [pointAt(maison, 1710489600000), pointAt(secret, 1710493200000)],
      visits: [
        visitAt(maison, 1, 1710489600000),
        visitAt(secret, 2, 1710493200000),
      ],
      segments: [
        segmentFrom(maison, bureau, id: 1, start: 1710489900000),
        segmentFrom(maison, secret, id: 2, start: 1710500000000),
      ],
      userPlaces: const [],
      privateZones: [circleAt(secret, label: 'Chez mes parents')],
      overrides: const [],
      filters: const FiltersInput(modes: []),
    );

    final stats = await computeStats(request: request, cellSizeDeg: 0.01);

    expect(stats.visitCount, 1);
    expect(stats.segmentCount, 1);
    expect(stats.density, hasLength(1));
    // Un seul trajet compte : 3210,5 m, pas 6421.
    expect(stats.totalDistanceM, closeTo(3210.5, 1e-6));
  });

  test('les filtres de vue sont combinables à travers le pont (§3.4)', () async {
    final response = await runPipeline(
      request: PipelineRequest(
        points: const [],
        visits: const [],
        segments: [
          segmentFrom(
            maison,
            bureau,
            id: 1,
            start: 1710489900000,
            mode: TravelMode.cycling,
          ),
          segmentFrom(
            bureau,
            maison,
            id: 2,
            start: 1710520000000,
            mode: TravelMode.walking,
          ),
        ],
        userPlaces: const [],
        privateZones: const [],
        overrides: const [],
        filters: const FiltersInput(modes: [TravelMode.cycling]),
      ),
    );

    expect(response.segments, hasLength(1));
    expect(response.segments.single.id, 1);
  });
}
