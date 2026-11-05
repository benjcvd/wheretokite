# Validation: Camargue and Provence (fr-camargue, WHE-102)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM
through the build, never from Windy. Past work: no earlier validation of this zone; `git log` on
`FR-mediterranean.csv` shows only tier / ban column changes, and `TO_CONFIRM.md` had nothing on these spots.
All 9 pins (8 spots + restored Plage Est) agree with the Apple Maps direction check (build: agrees 9, 0 corrected, 0 uncertain, no PROBLEMS).
Limit of this pass: I did not look at satellite imagery for each pin; pins are the OSM beach / node elements and
the build's shore snap (Jaï, Carteau and Cavaou moved onto the NW / E / S facing shore).

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Beauduc | basic | ok (notes rewritten, one error fixed) | Provence tourism page "Spot de kite surf de Beauduc" (mistral, SE, S, SW, W; kiting limited to marked areas away from swimmers; unpaved access; schools in Salin-de-Giraud), Ultimate France guide, Aero Kite School (works at Beauduc), myprovence top kite spots. Direction WSW (246°), agrees. The old note said Piémanson was 12 km east: it is about 20 km, fixed. A 2014 municipal order covers the marine part of the point, a consultation summary says it is not a kite ban; I did not read the order itself, so no ban encoded. |
| Port-Saint-Louis – Plage Napoléon | basic | ok (notes rewritten, one error fixed) | Windy marker matches (4 stars). Spot guides (vvanat, Ultimate France), beach directory plages.tv ("kitesurf zone"), Provence tourism page, Mistral Kite Passion school on the Mazet peninsula. Direction SE (135°), agrees. The old note put Carteau 6 km north; it is about 3 km north-west on another bay, so both stay. Winds: Windy-listed W–SE per a kite directory, guides say SE gives waves and Rhône current. No official kite-zone text found, none encoded. |
| Port-Saint-Louis – Carteau | pro | ok (notes rewritten) | Closed bay, flat with S / SE, school Mistral Kite Passion, myprovence top kite spots, Ultimate France / unplug directories, hosts the Coupe de France of kitesurf (meteoconsult 2017/2018). Pin: OSM node on the bay shore, direction NE (51°), agrees with the E hint, sector 140. No Windy marker at the pin (see Olga below). |
| Salin-de-Giraud – Piémanson | pro | ok (notes rewritten) | Windy "Salins de Giraud" (3 stars) matches. Guides (vvanat, kite-and-windsurfing-guide), Provence tourism lists schools in Salin-de-Giraud. Préfecture 2016 press release: measures against wild camping and vehicles on the beach, nothing about kiting. Direction SSW (206°), agrees. |
| Fos-sur-Mer – Le Cavaou | pro | ok, ban kept but marked unconfirmed | Windy "Le Cavaou" (4 stars) matches. Unplug directory (SE, E, S, SW work; thermal SW 10–15 kn; mistral offshore), myprovence (S / SE, shallow), Provence tourism page. Unplug says signs forbid kiting with no dates posted. No official text found (town page, préfecture recueil searched). Ban 15 Jun–15 Sep stays as the worst case, notes say it is a guess. Direction SSE (148°), agrees. |
| Marignane – Le Jaï | basic | ok (notes rewritten) | Windy "Le Jai" (5 stars) matches. Schools on site: Jawaï kite school (open March–November), kite13 club, Club Nautique Marignanais; Provence tourism "Spot de kite surf du Jaï"; Ultimate France; myprovence (about 250 wind days a year). Kite only on the Étang de Berre side, Bolmon side is a nature reserve. Pin: OSM relation `osm:r18086573`, shore snapped to the NW-facing side, direction NW (316°), agrees. |
| Carro | basic | ok (notes rewritten) | Provence tourism "Spot de voile de Carro" (experts only, rocky bottom), Ultimate France (best SE, W and E also, mistral dangerous, rocky shelf 400 m, urchins, current), myprovence (very experienced riders), made-in-marseille. One result says kiting is limited to the north side of the beach: in notes, not encoded. Direction SW (227°), agrees. Not on Windy. |
| Marseille – Pointe Rouge | basic | ok, ban kept but marked unconfirmed | Windy "Marseille" (5 stars) is the Pointe Rouge / Prado area. Sources: adrenactive school (courses March–December at Pointe Rouge), vvanat Pointe Rouge guide (NW / W best, S / SE waves, tight launch, 300 m summer rule cited as "arrêté 118/2020"), myprovence (Bonneveine closed to kitesurfers in summer, Marseille Kite Club). I could not find the arrêté or a Marseille beach regulation, so the 15 Jun–15 Sep ban stays as the worst case and notes say it is unconfirmed. Direction NW (323°), agrees. |
| Saintes-Maries-de-la-Mer – Plage Est | archived → **pro** | fixed | Windy shows two markers at Saintes-Maries (below). Provence tourism lists Plage Est as a kitesurf and windsurf spot; kite-and-windsurfing-guide: speed canal (mistral, flat) beside the east beach, waves with E–SE and W west of the harbour; Lonely Planet and plages.tv mention kiters. Pin unchanged (OSM node `osm:n11893130578`). Restored as Pro (the archive reason was "paid access, tolerated"). |

## Windy, both ways (browsed 2026-11-05, zoom 10–13 around 43.4 N, 4.9 E)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Beauduc (5) | Beauduc | matched |
| Salins de Giraud (3) | Piémanson | matched |
| Plage Napoleon (4) | Plage Napoléon | matched |
| Le Cavaou (4) | Le Cavaou | matched |
| Le Jai (5) | Le Jaï | matched |
| Marseille (5) | Pointe Rouge | matched |
| Saintes-Maries Speed (1) | Plage Est | matched (speed canal beside the east beach), restored as Pro |
| Plage Olga (4) | none | **left out** (reason 3 only; the 2 km distance is no longer a reason, rechecked 2026-11-05, WHE-130): plages.tv describes it as the industrial, pebbly, wild/naturist town beach and Carteau as the kite beach; no school, club or guide names a kite zone at Olga. |
| Les Renaires (2) | none | **left out** (reasons 3 and 4): rocky Côte Bleue shore near Ponteau, no school, club or guide mentions kiting there, and OSM has no element by that name to pin. |
| Saintes-Maries Wave (4) | none | **left out** (reason 4): waves west of the harbour per kite-and-windsurfing-guide, but no source names the beach and OSM has several unnamed beaches there; can't pin it honestly. Flagged in `TO_CONFIRM.md`. |

Ours → Windy: Beauduc, Piémanson, Napoléon, Cavaou, Jaï, Pointe Rouge, Plage Est have a marker; Carro and Carteau have none (Olga sits 2 km north of Carteau).

Counts: 10 Windy markers in the zone, 7 matched, 0 new spots added (1 archived spot restored as Pro), 3 left out.
Our spots in the zone: 9 rows (5 free, 3 Pro, 1 archived) → 9 rows (5 free, 4 Pro, 0 archived).
Gap: none worth a line.
