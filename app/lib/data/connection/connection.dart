// Ouverture de la base, par plateforme (§3.2).
//
// L'implémentation native et l'implémentation web n'ont aucun code commun :
// `drift/native.dart` s'appuie sur `dart:ffi`, indisponible en web, et
// l'importer sans condition casse la compilation web — pas seulement
// l'exécution.
//
// L'import conditionnel ci-dessous est donc structurel, pas cosmétique.

export 'connection_stub.dart'
    if (dart.library.io) 'connection_native.dart'
    if (dart.library.js_interop) 'connection_web.dart';
