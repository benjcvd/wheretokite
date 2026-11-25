# Pins and directions, Catalonia and south of France (WHE-244, 21 Nov 2026)

Checked on the current build of `ES.csv` (Catalunya, 18 live spots) and `FR-mediterranean.csv` (53 spots).

## Finding 1: pins sit 100–270 m inland on wide beaches (cosmetic, direction fine)
The pin is the centre of the OSM beach polygon (dunes included). The build only moves a pin onto the
shore when it is more than `SNAP_IF_FARTHER = 300 m` away, so wide beaches stay 100–270 m inland.
Their direction is right (all `agrees` with Apple Maps).

Catalonia: Sant Pere Pescador 270 m, L'Hospitalet de l'Infant 256 m, L'Estartit 151 m.
South of France: Grau-du-Roi Boucanet 257 m, Leucate Coussoules 241 m, Bonifacio Piantarella 216 m,
Lozari 189 m, Beauduc 169 m, Carnon 164 m, Saint-Florent La Roya 148 m, Marseillan Thau 135 m,
Gruissan Vieille-Nouvelle 119 m, Saintes-Maries Plage Est 105 m, Saint-Cyr Les Lecques 103 m.

No narrower OSM element exists to pin on (`osm_lookup near`: the only candidates are the same beach
polygon or the school node on it), and coordinates are never typed. The fix is in the build, not the CSV:
**`SNAP_IF_FARTHER` 300 → 100**. Tested on a scratch copy (not committed): on ES and FR-mediterranean
every pin above lands 30 m from the shore, no direction changes (except Patos 330° → 310°, Mar Menor
Los Narejos 172° → 169°), no new PROBLEMS. It also fixes the same issue on 20 spots elsewhere (Tarifa x3,
Los Caños, El Campello, Dénia, Galicia, Cantabria, Asturias). Card for the Lead (pipeline code is out of
my scope).

## Finding 2: directions flagged by Apple Maps
| Spot | Build | Verdict |
|---|---|---|
| Le Barcarès – Parc des Dosses | W 273°, Apple water N 26° (`disagrees`) | Harmless. The pin is on the east shore of the Étang de Leucate, the open lagoon lies west (tramontane = NW is offshore, as in the notes); Apple reads the nearby harbour channel to the north. Hint and WHE-59 pin check agree. Kept as is. |
| Marseillan – Étang de Thau | WNW 303°, Apple 261° (`uncertain`) | Harmless: irregular lagoon shore, 42° apart, same side (already settled in `fr-thau.md`). Becomes `agrees` with the 100 m snap. |
| Mallorca S'Arenal, Menorca Punta Prima | 239° vs hint S, 145° vs hint E | Outside this zone; not touched. |

## Not re-done
The Catalonia spots keep their earlier sourced rows (Barcelona benchmark, Ebro delta batch). A full
Catalonia validation against the method in `tools/spots/validation/README.md` has not been run: it is a
separate card (see board).
