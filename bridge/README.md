# `bridge/` — flutter_rust_bridge

Crate Rust `odysseia_bridge` : la seule frontière entre `core/` (Rust) et
`app/` (Dart).

## Pourquoi ce crate existe

`timeline_core` ne doit dépendre ni de Flutter, ni de Dart, ni de
`flutter_rust_bridge` (§6.1). Toute la glue vit donc ici : le cœur reste un
crate Rust ordinaire, testable par `cargo test` seul.

Conséquence assumée : les structures échangées (`PointInput`,
`ResolvedVisitOutput`…) sont des copies de celles de `core/`, converties à la
frontière. C'est le prix de garder le cœur pur.

## Ce que l'API expose — et n'expose pas

`bridge/src/api/timeline.rs` n'expose **aucune** fonction renvoyant de la
donnée Timeline non filtrée. Il n'y a pas de `get_raw_points`, et c'est
l'absence de cette fonction qui empêche une vue de contourner les zones
privées (§3.7).

| Fonction | Sortie |
| --- | --- |
| `run_pipeline` | sortie du pipeline §5.4 |
| `compute_stats` | les six statistiques §3.4, calculées sur cette sortie |
| `plan_video` | plan de frames §3.5, calculé sur cette sortie |

## Régénérer

Les fichiers générés (`bridge/src/frb_generated.rs`,
`app/lib/bridge/generated/`) sont commités mais **jamais édités à la main**
(§6.1).

```bash
cd app && flutter_rust_bridge_codegen generate
```

⚠️ **Régénérer ne suffit pas** : la bibliothèque native doit être reconstruite
dans la foulée, sinon Dart et Rust ne parlent plus le même protocole et les
tests échouent sur une assertion de codec obscure.

```bash
cd bridge && cargo build
```

## Chargement de la bibliothèque

| Contexte | Mécanisme |
| --- | --- |
| App réelle | `app/rust_builder` (cargokit) compile et embarque la lib |
| `flutter test` | `app/test/bridge/rust_lib.dart` ouvre `bridge/target/debug/` |
| Web | build WASM distinct, **pas encore branché** (§6.2) |

## Limites connues

- **Windows** : `flutter build` avec des plugins exige le mode développeur
  (symlinks). `flutter test` et `cargo build` fonctionnent sans.
- **Web** : `flutter_rust_bridge_codegen build-web` reste à intégrer.
