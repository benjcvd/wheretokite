# Validation: Galicia (zone `es-galicia`, WHE-105)

Date: 2026-11-05. Build: `spot-check` on `ES.csv`, no PROBLEMS, Apple Maps agrees 97 / uncertain 1 (Los Caños de Meca, another zone).
Counts for the zone: 7 → 10 spots (free 4 → 4, Pro 3 → 6, archived 0). Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: no earlier sourced pass on the Galicia rows (`git log` on `ES.csv` shows only the first catalogue builds, the
famous-spots trim and the tier split). Pins and facing come from the build on the full `ES.csv` (OSM elements, Apple Maps
check, no PROBLEMS).

Limits of this pass (said plainly): about 19 web searches/fetches of school listings, spot guides and the Windy visitor view.
I did not find an official kite text (ayuntamiento, Xunta, Capitanía) for any spot: no ban is encoded. Pins were taken from OSM
elements, not checked on satellite in Chrome (Chrome was used for Windy only). Spot-guide pages are summarised, never copied.

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Doniños (Ferrol) | fixed (pin, notes) | Was a `q:` search; now the beach way `w646340327` (moved about 220 m). Faces W (281°), Apple Maps agrees | None found. Localism warning in the guide | [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/doninos-rias-altas-galicia-spain.html): kite area is the left side (Punta Penencia), cross-shore N best, NE cross-off gusty, S–SW rough, localism; a [travel article](https://spainseeker.com/?p=3477) calls it Galicia's best kite spot (weak source). No kite school on the beach (only surf schools; Ferrolvento in Caranza teaches kite). Thin: 1 guide + 1 article, kept as free because Windy's San Xurxo 5-star marker is the same coast |
| Razo (Carballo) | fixed (pin, notes) | Was a `q:` search; now `w39473257` "Praia de Razo" (moved 380 m). Faces N (353°), agrees | Inside the Razo–Baldaio nature reserve; the guide warns of a possible future kite ban in the bird sanctuary and says to leave the lagoon as the tide drops. No decree found | [Guide: Razo-Baldaio](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/razo-baldaio-rias-altas-galicia-spain.html) (NE cross-onshore, big waves, extreme currents, experienced riders, lagoon deep enough at high tide, localism on main peak); [Ares-Seselle guide page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ares-seselle-rias-altas-galicia-spain.html) calls the lagoon a winter flat-water favourite. Windy "Playa de Baldaio" (2 stars) is the same system. No school found: thin, kept |
| A Lanzada | fixed (notes) | `w173598722`, faces WSW (240°), agrees; hint W kept | **A [Kiteforum](https://se.kiteforum.com/kitesurf/spot/A_Lanzada) page says kiting is prohibited in summer.** No official text found (searched Sanxenxo, O Grove). Rule: ban not encoded (needs an official source), stated in notes, ask locally | Kiteforum: best N, S, SSW, SW, WSW, NNW; best Oct–Mar; rocks, more to the south; intermediate/expert. Yumping lists [kite courses at La Lanzada from O Grove schools](https://en.yumping.com/deals/kitesurfing/pontevedra/kitesurfing-initiation-course-2-days-in-o-grove--o31372); a [beach guide](https://masmar.net/index.php/esl/Guías/Playas/Pontevedra-Galicia/Playa-de-A-Lanzada-O-Grove-y-Sanxenxo) says surf, kite and windsurf are practised; dunes protected. Windy 4 stars. Old note "best autumn–winter" kept and made plainer |
| O Grove – A Mexilloeira | ok (notes) | `w51842113`, faces NNW (337°), agrees | None found | Schools on the beach: Centro Kite Galicia ([course listing](https://www.yumping.com/en/deals/kitesurfing/pontevedra/initiation-kitesurf-course-at-mexilloeira-beach--o70627)) and [Escuela Española KiteSurf](https://www.yumping.com/en/kitesurfing/escuela-espanola-kitesurf-pontevedra--e19665059). Kiteforum (via A Lanzada page): works NE–NW. Windy 3 stars |
| A Illa de Arousa – O Bao | fixed (notes, hint) | `r3019704`, faces S (172°), agrees. **Hint now `S|N`**: the old note said "S–SE (winter)" but every source says N–NE is the main wind here | None found | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/isla_de_arousa): main N, NNE, NE, best Apr–Aug, ride either side of the bridge, flat to choppy, tide independent, hazards bridge and road. [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/el-bao-rias-baixas-galicia-spain.html): summer northerlies. Schools: Kiteboarding Galicia (Playa del Bao), Papaventos Kite Club (federated). Windy "Isla de Arousa" 3 stars |
| Redondela – Cesantes | ok (notes) | `w161470986`, faces SW (234°), agrees; the shoreline bends | None found | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/cesantes): best N, NNE, NE, SW, WSW, W; thermal almost daily in summer; ships and bridge as hazards. [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/cesantes-rias-baixas-galicia-spain.html): flat water, SW thermal F3–4 in summer afternoons, gusty NE, boats on the south side, sharp mussels. TMKiteClub and the Kitefest Cesantes ([Metropolitano](https://dev.metropolitano.gal/deportes/cesantes-vuelve-a-llenar-de-cometas-la-ensenada-de-san-simon-con-el-campeonato-gallego-de-kitesurf)). Windy 3 stars |
| Vigo – O Vao | ok (notes), pro | `r5294013`, faces NNW (343°), agrees | None found | One source only: an article on water sports in the ría lists the Vao beach with Patos and Playa América as places to kite. No school found, no Windy marker. Kept as Pro, notes now say how thin it is |

## Added as Pro from the Windy list

| Spot | Pin | Why it goes in |
|---|---|---|
| Patos (Nigrán) | `w37909121`, faces NW (330°), agrees | Windy 4 stars; [Furacán Kite Escola](https://www.yumping.com/en/kitesurfing/furacan-kite-escola--e19620946) lists Patos and Playa América; [guide page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/patos-rias-baixas-galicia-spain.html): strong cross-on N with swell works, S blocked by the headland, summer often too light |
| San Xurxo (Ferrol) | `w646340311`, faces NW (312°), agrees | Windy 5 stars; [Wannakitesurf](http://www.wannakitesurf.com/spot/Europe/Spain/Galicia/San_Jorge/): summer thermal NE, side-offshore, 16–25 kn, gusty, 1–2 kn current. About 3.5 km from Doniños, different bay and wind (guide sends riders there when Doniños is too big) |
| Boiro – Carragueiros | `w108818579`, faces SW (217°), agrees | Windy "Carragueiros" 2 stars (and "Boiro" 4); [guide page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/carragueiros-rias-baixas-galicia-spain.html): SW blows in, chop and shorebreak, big standing area at high tide, only a few locals. Weak but enough for Pro |

## Windy, both ways (browsed as a visitor, 5 Nov, kite markers hovered)

Windy marker → ours. About 30 kite markers between Bares and A Guarda (Portuguese markers and the Asturias border ones, La Charca and Penarronda, are out of the zone).

| Windy marker (stars) | Ours |
|---|---|
| La Lanzada (4) | A Lanzada |
| Mexilloeira (3) | O Grove – A Mexilloeira |
| Isla de Arousa (3) | A Illa de Arousa – O Bao |
| Cesantes (3) | Redondela – Cesantes |
| Playa de Baldaio (2) | Razo (same Razo–Baldaio system, matched) |
| San Xurxo (5) | **added (Pro)** |
| Patos (4) | **added (Pro)** |
| Carragueiros (2) | **added (Pro)** |
| Boiro (4) | same Boiro shore as Carragueiros, pin not identified: follow-up |
| El Bao (3), south side of the Ría de Vigo | probably O Vao / Toralla side (matched on the map name, not on position); not confirmed: follow-up |
| Valdoviño (4), Cedeira (4), Ares (3), Santa Cristina (4), Sabón (3), Playa Grande de Mino (2), Fornos (1), Bares (1) | **not done yet** (follow-up card): no school or kite source read yet in this pass |
| Laxe (3), Nemina (4), Carnota (3) | **not done yet** (follow-up): visitacostadamorte.com names Traba and Soesto (Laxe) as well-known kite beaches; Nemina is a surf spot per local schools |
| Aguieira (3), As Furnas (3), Ancoradoiro (3), Abelleira (2), Playa a Ladeira (2), Agrelo (1), Nerga (2) | **not done yet** (follow-up): the kite guide lists Aguieira, As Furnas, A Ladeira; Kiteforum lists Nerga (S–SW, beginner to expert) but the beach to pin is unclear (several beaches around Nerga); Yumping lists Agrelo as a school spot |

Ours → Windy: Doniños (no marker under that name; San Xurxo and Valdoviño are the neighbours) and O Vao (see El Bao above)
have no certain Windy marker. Windy positions were used only to learn that spots exist, never for pins.

Big gap: Windy shows about 20 kite markers we still lack in Galicia. I did not reach the rule's bar for them in this pass
(one source and a safe OSM pin each); these are not "good reasons" to leave them out, so they go on a follow-up card.
