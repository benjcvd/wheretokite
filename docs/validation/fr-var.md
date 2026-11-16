# Validation: Var and Côte d'Azur (fr-var, WHE-103)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM, never
from Windy. Past work: no earlier validation of this zone (`git log` on `FR-mediterranean.csv` shows only the tier / ban
column changes, d7f4125 and 4a031c3); `TO_CONFIRM.md` had no line for it. Pins were already on OSM elements and the build's
Apple Maps check said "agrees" for all five, so I re-checked the sources, the rules and the notes rather than the pins.
Not eyeballed on satellite this run. Overpass was down most of the session; the build (7 rows: the 5 spots and the 2 additions) needed the curl wrapper and ended with no PROBLEMS, no warnings, Apple Maps agrees on all 7. Not run on the full FR-mediterranean.csv.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Hyères – L'Almanarre | basic | ok (notes extended) | Real and famous. Town hall kite code "Règles pour la bonne pratique du kitesurf à Hyères" (hyeres.fr PDF; municipal order n°1420 and préfecture order n°019/2018): two marked kite channels (Mérou and Almanarre) through the 300 m band, buffer zones either side, nothing allowed in the 300 m band outside the channels, beach marshal 15 June to 15 Sept. Kite zone between access gates 16 and 21 (ultimatefrance.com guide, vvanat.fr Hyères guide). Schools on site (Kitextrem, Kite Center 83 via tourism listings). Pin: `q:Plage de l'Almanarre`, direction W (259°), agrees with the hint. I could not read the order text itself, so no ban is encoded: the summer regime is a channel system, not a closure. Notes now carry the channel rule. |
| Hyères – Le Mérou | pro | ok | Same town kite code: the Mérou channel is the second official one. vvanat.fr "Plage du Mérou" guide: east-wind spot, small launch. Windy calls it "Ayguade, Hyères". Pin `osm:w198196306`, SE (142°), agrees. 8 km from Almanarre, different water and wind, so kept as its own spot. Notes unchanged. |
| Fréjus – Saint-Aygulf | basic | ok | School on the beach: Kite Surf Evasion (FFVL school since 2000, at the Argens mouth; Fréjus tourist office listing). Fréjus tourist office also lists a "Spot de Kitesurf de Fréjus" at the Base Nature, 5 min on foot from the old spot, and a Saint-Aygulf beach page with one of four zones marked for kite. Guides (wannakitesurf, kite-and-windsurfing-guide, unplug-kitesurf): S wind, intermediate, no tide effect. Pin `osm:w339192637`, E (97°), agrees; hint SE kept (thermal S and E). The existing notes' summer / off-season zone swap (Argens mouth vs Esclamandes) is the town's two-zone setup but I did not find the dates: wording kept, no ban. |
| Cannes – Palm Beach | pro | ok | Regional tourism listing "Site de kite surf du Palm Beach" (cotedazurfrance.fr / provence-alpes-cotedazur.com), seecannes.com (the only kite spot of Cannes and of the Alpes-Maritimes), school Air X Kite (Cannes / Mandelieu), spot guides (kite-and-windsurfing-guide, unplug-kitesurf): small launch, experienced riders. Pin `osm:n2470907668`, S (136° with a water sector of 220°), agrees. No summer ban found at official level; guides only say most of the Riviera shuts in summer. Notes unchanged. |
| Six-Fours – Le Brusc | basic | ok (ban kept, unsourced) | Plage des Charmettes at Le Brusc. kiteforum spot page: no kite while the lifeguard post is open; waterwind and another guide: intermediate to expert, cleanest wind when the mistral drops; one guide says kiting is officially banned all year and tolerated off season. No town or préfecture text found: the 1 June to 30 Sept ban stays (worst case), written in TO_CONFIRM. Pin `osm:w354842415`, W (293°), agrees. Notes unchanged. No school found on site: Windy shows 5 stars. |

## Windy, both ways (browsed 2026-11-05, zooms 10 and 11 from Les Lecques to Saint-Laurent-du-Var)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| L'Almanarre, Hyères (5) | Almanarre | matched |
| Ayguade, Hyères (4) | Le Mérou | matched |
| Saint Aygulf (5) | Saint-Aygulf | matched |
| Palm Beach (5) | Cannes – Palm Beach | matched |
| Le Brusc (5) | Le Brusc | matched |
| Les Lecques (5) | none | **added (Pro)** `osm:w331213777`: Saint-Cyr tourist office listing "Kitesurfing spot at Les Lecques", open 16 Oct–14 Mar, launch from the south end of the beach. Faces SW (232°), Apple Maps agrees. Ban 15 Mar–15 Oct encoded from that listing (tourist office text, not the order itself). |
| Brégançon (4) | none | **added (Pro) as Cabasson** `osm:w27272205`: the marker sits in Cabasson bay next to the Fort de Brégançon; Bormes tourism listing "Spot de Kitesurf de Cabasson", open 1 Oct–31 May. Faces WSW (239°), Apple Maps agrees, so mistral is side-shore (hint set to SW; guides' E / NE / SE kept in notes). Ban 1 Jun–30 Sep from that listing. |
| La Capte (5), La Madrague (5), Bergerie (5), Les Salins (4), all Hyères | none | **left out** (reason 1): the Hyères kite code allows kiting only through the two marked channels (Almanarre, Mérou); other Hyères beaches have no kite zone. |
| Port Miramar, La Londe (4) | none | **left out**: no kite source found (only a beach in general lists). Worst case. |
| Le Lavandou (5) | none | **left out** (reason 1, unconfirmed): a campsite page says kiting is banned all year at Saint-Clair, Le Lavandou and La Favière. Not an official text. |
| Gigaro (4) | none | **left out**: one guide says kite is banned within 300 m of the beach in summer, boat access by schools; no dates, no school page found. Worst case. |
| Pampelonne (4) | none | **left out**: private beach clubs and boat traffic per a guide, no kite rule or school found. |
| La Tour (4), La Nartelle (3), (Plage des Éléphants not on Windy) | none | **left out**: Sainte-Maxime tourism listings call La Nartelle and Éléphants "windsurf and kitesurf" spots but give no season or rules and the official Nartelle page mentions windsurf only. Worst case. |
| Bandol (5) | none | **left out**: no kite source (tourism pages mention harbour only). |
| Brutal Beach (5), La Coudouliere (5) | none | **left out** (reason 3): vvanat Six-Fours guide lists them as windsurf and wave spots; same stretch as Le Brusc, where kiting is banned in summer. |
| Les Sablettes, La Seyne (5) | none | **left out** (reason 3): listed for windsurf and surf only. |
| Mandelieu La Napoule (5), Cannes (5), La Salis, Antibes (5), Saint-Laurent-du-Var (4) | none | **left out** (reason 1, weak): tourism guides say Palm Beach is the only official kite spot of the Alpes-Maritimes. Mandelieu has a school (Air X Kite) that launches off the beach for experienced riders: worth a second look. |

Ours → Windy: all five have a marker (Mérou under the name Ayguade).

Counts: 25 Windy markers read (La Ciotat is in the Provence zone; one unlabelled marker near Cap Nègre was not read),
5 matched, 2 added as Pro, 18 left out. Our spots in the zone: 5 → 7 (3 free, 4 Pro, 0 archived).
Gap: Windy shows 18 markers we don't have. Most are Hyères side beaches (no kite zone by the town code), Six-Fours and
Alpes-Maritimes beaches where kiting is restricted, or places where I found no local kite source in the budget (Gigaro,
Pampelonne, Sainte-Maxime, Port Miramar, Bandol, Mandelieu). A second pass on those is worth a card.
