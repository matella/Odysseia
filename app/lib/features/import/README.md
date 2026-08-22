# `import/` — import d'un export Timeline

Sélection du fichier, progression (pourcentage + étape, §4), avertissements.

Points d'attention : un seul export à la fois, un nouvel import **remplace**
(§3.1) ; archivage de l'export précédent + avertissement explicite si le
nouveau couvre une période plus courte (§4) ; avertissement au-delà de ~200 Mo
en web (§4). Les données utilisateur (§5.2) ne sont jamais effacées.

## État

Fait : parsing en streaming via le pont, insertion par lots, progression,
avertissements §4, un message par cause d'échec (§3.10), et le fait qu'un
import raté laisse l'import précédent intact.

Manque : le **sélecteur de fichier**. `HomeShell` accepte un `pickPath`
injecté ; il suffira de le brancher sur un paquet de sélection de fichier.
Tenté avec `file_selector`, qui casse `flutter pub get` sous Windows sans le
mode développeur — à reprendre une fois celui-ci activé.
