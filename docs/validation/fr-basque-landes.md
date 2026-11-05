# Zone fr-basque-landes: Landes and Pays basque

Card WHE-108 · checked 3 Nov 2026 · method: [validation README](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time)
File: `tools/spots/FR-atlantic.csv` (regions `Landes`, `Pays basque`).

**Result:** 9 spots checked → 8 kept (2 basic, 6 pro), 1 archived (Contis), 0 added.
4 pins moved off weak elements, 1 seasonal ban added (Anglet), 7 notes rewritten from sources.
`spot-check`: no PROBLEMS; all 8 built spots `agrees` with Apple Maps.

Past work: `3b0e02a` (rows added), `0d75981` (Navarrosse moved to Lac de Cazaux, Estagnots
note), `d96ef24` / `4a031c3` (tiers), `d7f4125` (Hendaye ban). None of these listed sources, so
every spot was re-checked.

## Spots

| Spot | Tier | Verdict | Pin | Faces | Rules | Sources |
|---|---|---|---|---|---|---|
| Lac de Cazaux – Navarrosse | basic | **fixed**: pin moved from the hamlet node to the beach by Navarrosse harbour (`w267261585`, Google satellite labels it "Spot de Navarrosse"); summer dates corrected to 15 Jun–15 Sep; no `banned` because the Mayotte beach 800 m east stays open | beach | NW 325°, agrees | Kite allowed from Navarrosse, Mayotte and Port de l'Estey; banned from Navarrosse 15/06–15/09 (lake regulation, inter-prefectoral orders 1976/2014) | [Lake regulation, Biscarrosse tourist office](https://www.biscagrandslacs.com/sites/default/files/inline-files/lac-nord-cazaux-sanguinet-reglementation.pdf) · [vvanat Landes guide](https://vvanat.fr/blog/kitesurf-dans-les-landes/) (W–N winds, beginner, hunting hide) · H2O Kite school at Mayotte ([tourismelandes](https://www.tourismelandes.com/en/activity/h2o-kite-ascaqu040fs0013h/)) |
| Lac de Sanguinet – Port de l'Estey | pro | **fixed**: note rewritten (the "buoyed zone" claim had no source) | marina node (`n1771842358`, OSM lists kite among its activities) | NNW 341°, agrees | Kite allowed from the harbour (same regulation) | Lake regulation (above) · [vvanat Lac de Cazaux](https://vvanat.fr/blog/kitesurf-lac-de-cazaux/) (Kite-Particulier school, boat to sandbank, alios) |
| Biscarrosse-Plage | pro | **fixed**: note adds the military range stakes to the south | `n8339012619` Plage Sud (beach resort node on the beach) | W 276°, agrees | No town order found; kite zone outside bathing area in summer | [plages.tv Plage Sud](https://www.plages.tv/detail/plage-sud-biscarrosse-40600) (kite zone, military zone) · [vvanat Landes guide](https://vvanat.fr/blog/kitesurf-dans-les-landes/) (intermediate–expert, stakes) · [vvanat Biscarrosse](https://vvanat.fr/blog/quelle-condition-de-vent-pour-kitesurf-lac-biscarrosse/) |
| Mimizan | basic | **ok** | beach `w222354554` Plage Sud | W 283°, agrees | Supervised in summer; ride in the kite zone | [plages.tv Plage Sud Mimizan](https://www.plages.tv/detail/plage-sud-mimizan-40200) · Tourisme Landes Plage Sud listing (kite zone) · [vvanat beginners Landes](https://vvanat.fr/blog/ou-debuter-kitesurf-landes/) · Windy marker "Plage" |
| Contis | archived | **archived**: one spot guide only; no school, club, kite zone or Windy kite marker. Pin moved to the beach (`w201270695`) for the record | — | — | — | [vvanat Moliets guide](https://vvanat.fr/blog/moliets-et-maa-kitesurf/) only; searches for a school or zone found surf schools only |
| Moliets | pro | **fixed**: note rewritten (wind range, tide) | beach `w234222592` Plage de la Balise | W 283°, agrees | None found | [vvanat Moliets guide](https://vvanat.fr/blog/moliets-et-maa-kitesurf/) (SW–N, high tide near the Huchet) · Windy kite marker "Moliets" (5★) |
| Seignosse – Les Estagnots | pro | **fixed**: kite area is left (south) of the lifeguarded zone, per the town tourist office | beach node `n3053079146` | W 273°, agrees | "Only beach where kitesurfing is allowed" in Seignosse | [Seignosse tourist office](https://www.seignosse-tourisme.com/en/discover-seignosse/the-beaches-of-seignosse/estagnots-beach/) (links Sud Landes Kite school) · [vvanat Landes guide](https://vvanat.fr/blog/kitesurf-dans-les-landes/) (thermal, current) · Windy markers "Estagnots", "Seignosse" |
| Anglet – La Madrague | basic | **fixed**: pin moved from the lifeguard hut to the beach (`w741058698`); ban added `06-13..09-15 10:30-19:00` (worst case, see below); Hendaye mention removed (own row) | beach | WNW 302°, agrees | Town order 2026 (beach police): Madrague lifeguarded 13 Jun–13 Sep, 12–18 h then 10:30–19 h in Jul–Aug; kite "subject to specific rules" (order n°2023/592, text not found online) and banned under red flag | [Anglet beach-police order 2026](https://cdt64.media.tourinsoft.eu/upload/REGLEMENTATION-GENERALE-DU-LITTORAL-ET-POLICE-BAINS-DE-MER-2026---1530--abroge-n-2026-622--8.pdf) (art. 8, 20) · [vvanat Pays basque](https://vvanat.fr/blog/stage-kitesurf-pays-basque/) (experienced only, Fun Kite Sud Ouest club) · Windy marker "Anglet" |
| Hendaye | pro | **fixed**: pin moved from a bus stop to the beach (`w234073850`, Ondarraitz / Grande Plage); July–August ban **kept as worst case** | beach | N 358°, agrees | No town order found; kite lessons sold March–November only | [Sport Découverte flysurf Hendaye](https://www.sport-decouverte.com/initiation-flysurf-hendaye.html) (Mar–Nov) · [vvanat Pays basque](https://vvanat.fr/blog/stage-kitesurf-pays-basque/) · Windy marker "Hendaye" (5★) |

### Calls made under the 2 Nov rule (look it up, else assume the worst)
- **Anglet ban**: the kite order 2023/592 isn't online. The old note said kiting only before and
  after lifeguard hours in season, and the 2026 order confirms a specific kite regime. Encoded as
  no kiting during the widest lifeguard hours, 13 June–15 September (the build rounds to 10–19 h).
- **Hendaye ban**: no official source either way. Kept 1 July–31 August (the only school sells
  lessons March–November, consistent with a summer restriction).
- **Navarrosse**: the official ban only covers launching from Navarrosse; Mayotte (800 m, same
  water, same wind) stays open, so no hours are zeroed. The note tells riders where to go.

## Windy, both ways (3 Nov, Chrome, visitor)

Windy kite markers in the zone → ours:

| Windy marker | Ours | Note |
|---|---|---|
| Hendaye | Hendaye | |
| Saint-Jean-de-Luz | missing | Not added: no kite school or zone found; town bay is a bathing/surf bay; 12 km from Hendaye |
| Erromardie | missing | Not added: surf beach, no kite source |
| Bidart | missing | Not added: surf beach, no kite source; 8 km from Anglet |
| Biarritz | missing | Not added: surf beaches, no kite source; 4 km from Anglet |
| Anglet | Anglet – La Madrague | |
| Plage de la Digue (Tarnos) | missing | Not added: no kite source; 3 km from Anglet |
| Plage du Métro (Tarnos) | missing | Not added: no kite source; within 10 km of Anglet |
| Capbreton | missing | Not added: surf and wing spot (vvanat); 4 km from Estagnots, already left out in TO_CONFIRM |
| Hossegor | missing | Not added: kiting discouraged in summer (vvanat); 2 km from Estagnots |
| Estagnots, Seignosse (Le Penon) | Seignosse – Les Estagnots | Two markers for the same stretch |
| Soustons Lac | missing | Not added: the lake association says kiting is too dangerous (trees); schools teach wing only ([bateaux.com](https://www.bateaux.com/article/39540/le-lac-de-soustons-un-plan-d-eau-reserve-aux-pratiques-nautiques)) |
| Moliets | Moliets | |
| Plage (Mimizan) | Mimizan | |
| Lac de Cazaux et de Sanguinet | Lac de Cazaux – Navarrosse | Generic lake marker |
| Sanguinet | Lac de Sanguinet – Port de l'Estey | |
| Cazaux, La Salie | — | Gironde: zone fr-gironde (WHE-109) |

Ours → Windy: Contis and Biscarrosse-Plage have no Windy kite marker (Contis archived; Biscarrosse
kept as pro on two other sources). Every other spot matches a marker.

Counts: 17 Windy kite markers hovered in the zone (excluding the Gironde ones), 8 matched to our
spots, 9 missing, none added.

## Missing markers redone under the 4 Nov rule (Pro unless a listed good reason)

| Windy marker | Result | Why |
|---|---|---|
| Plage de la Digue + Plage du Métro (Tarnos) | **added (Pro)**: one spot, "Tarnos – Plage du Métro" (`w303968640`) | Council set the Métro aside for kiters ([wannakitesurf](http://en.wannakitesurf.com/spot/Europe/France/Aquitaine/Tarnos/)); Digue listed as kite zone ([plages.tv](https://www.plages.tv/detail/plage-de-la-digue-tarnos-40220)); the two are 1.5 km apart, same water |
| Saint-Jean-de-Luz | **added (Pro)** (`w18893856` Grande Plage), banned 15 Jun–15 Sep (worst case) | Kiting off-season in a reserved zone, never in lifeguard hours ([Figaro Nautisme](https://figaronautisme.meteoconsult.fr/actus-nautisme-escales/2021-09-14/60410-saint-jean-de-luz-les-incontournables-de-la-station-balneaire-basque)); surf schools teach kite ([vvanat](https://vvanat.fr/blog/stage-kitesurf-pays-basque/)) |
| Hossegor | left out: same beach as Estagnots (2 km, same water and winds) | [vvanat](https://vvanat.fr/blog/stage-kitesurf-pays-basque/) |
| Capbreton | left out: surf and wing only (Miramar) | [vvanat](https://vvanat.fr/blog/stage-kitesurf-pays-basque/) |
| Soustons lake | left out: kiting too dangerous (trees), wing only | [bateaux.com](https://www.bateaux.com/article/39540/le-lac-de-soustons-un-plan-d-eau-reserve-aux-pratiques-nautiques) |
| Biarritz, Bidart, Erromardie | left out: surf beaches, no kite source found; Marinella (north Biarritz) "avoid in summer" ([kiteforum](https://se.kiteforum.com/kitesurf/spot/Marinella)) and is 4 km from Anglet's kite beach | Weakest calls: no local source says "no kite", only no source says "kite" |
