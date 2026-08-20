# `data/` — accès aux données

Base locale **drift/SQLite** (§3.2, y compris web via `sqlite3.wasm` +
IndexedDB) et appels au `core/` Rust via le bridge.

⚠️ Le pipeline §5.4 est le **point de passage unique** : aucune vue n'interroge
la base directement en contournant les zones privées (§6.1).
