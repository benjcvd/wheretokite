# Zone fr-narbonne: Narbonne, Gruissan to Agde, inland lakes

Card WHE-95 · checked 3–4 Nov 2026 · file `tools/spots/FR-mediterranean.csv` (region Languedoc).
Method: [validation README](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).

**Result: 8 spots checked: 4 ok, 2 fixed, 2 archived. Nothing added.** Tiers before: 1 basic,
7 pro. After: 3 basic (La Nautique and La Tamarissière moved to free on Ben's call, 4 Nov), 3 pro, 2 archived.

## Past work (step 0)

- Rows come from `0e694f4` (Med catalogue 18 → 52) and `d96ef24` (famous-only trim, which set
  7 of the 8 to `pro`). No earlier validation of this zone.
- `TO_CONFIRM.md` flagged weak pins for Narbonne – La Nautique and Lac de la Ganguise, and the
  Ganguise launch (Auberge Le Cathare?). Both answered below.
- Saint-Pierre-la-Mer – Pissevaches (archived, school-run paid zone) sits in the zone box; it
  stays archived (Windy shows it with 3 stars as "Saint-Pierre-Sur-Mer").

## Spots, one by one

| Spot | Tier | Pin (OSM) | Direction (build / Apple) | Rules | Verdict | Sources |
|---|---|---|---|---|---|---|
| Gruissan – La Vieille Nouvelle | basic | `w49202040` natural=beach "Plage de la Vieille Nouvelle" | ESE 119°, agrees | No municipal kite rule found; no lifeguards; tramontane offshore | **fixed**: note no longer points to the Grazel lagoon | [vvanat Grazel/Gruissan](https://vvanat.fr/blog/kitesurf-etang-du-grazel/), [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/la-vielle-nouvelle-gruissan-occitanie-pyrenees-mediterranee-france.html), Windy "Plage Mateille, Gruissan" ★5 |
| Gruissan – Les Chalets / Grazel | pro | `w49248872` natural=beach "Plage des Chalets" | ESE 120°, now single-side | Étang du Grazel: kiting reported banned by town decree (vvanat, June 2026; decree text not found) | **fixed**: lagoon side (`NW:Étang du Grazel`) removed, worst case per rule of 2 Nov; sea side kept | [Kite & Windsurfing Guide, Plage des Chalets](https://www.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/plage-des-chalets-gruissan-occitanie-pyrenees-mediterranee-france.html), [vvanat](https://vvanat.fr/blog/kitesurf-etang-du-grazel/), Windy "Gruissan" ★5 |
| Narbonne-Plage – Créneau Naturel | pro | `n1724005026` natural=beach "Plage du Créneau Naturel – Poste 4" | SE 124°, agrees | Town beach-marking decree: zone 5, kite only, unsupervised, between a 25 m buffer and the Pech Rouge outlet dyke | **ok** (notes rewritten from the decree) | [Narbonne arrêté de balisage 2023](https://www.narbonne.fr/sites/default/files/arrete_de_balisage_2023.pdf) (now 404; quoted in search index), [vvanat Narbonne-Plage](https://vvanat.fr/blog/kitesurf-narbonne-plage/); not on Windy |
| Narbonne – La Nautique | pro → basic | `n6815096936` "Port la Nautique" (harbour node, ~1 km from the bay; no beach mapped nearer) | SSW 195°, agrees | No kite rule found; tramontane onshore-ish across the lagoon | **ok**. Windy ★5: candidate for `basic` (Lead/Ben call) | [Narbonne Kite Passion (Occitanie tourism)](https://www.tourisme-occitanie.com/fr/fiche/activite/narbonne-kite-passion-narbonne_TFOASCLAR011FS000GJ/), [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/la-nautique-etang-de-bages-occitanie-pyrenees-mediterranee-france.html), Windy "Étang la Nautique" ★5 |
| Sérignan – La Grande Maïre | pro → archived | `n9022469891` natural=beach | SSE 149°, agrees | No decree found | **archived**: no kite school, club or kite spot guide found (only general beach guides mention a "zone kite"); no Windy marker | [plages.tv](https://www.plages.tv/detail/plage-grande-maire-serignan-34410), [bord-de-mer](https://bord-de-mer.com/?p=22724) — beach guides only |
| Agde – La Tamarissière | pro → basic | `w114843096` natural=beach "Plage de la Tamarissière" | SSW 218°, agrees | Official kite zone at the west end (tourist office); beach supervised 1 Jul–31 Aug | **ok** (notes rewritten). Windy ★5: candidate for `basic` | [Cap d'Agde tourist office kite spot](https://www.capdagde.com/fiche-sit/spot-de-kite-surf-agde-la-tamarissiere-de/), [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/la-tamarissiere-cap-d-agde-occitanie-pyrenees-mediterranee-france.html), Windy ★5 |
| Lac de la Ganguise | pro → archived | `r2079969` (lake relation, snapped near Belflou) | NE 36°, agrees | **Prefectoral decree bans kitesurfing and swimming on the lake** (VNF page) | **archived**: banned all year. Also no Windy marker | [VNF – Lac de la Ganguise](https://www.vnf.fr/vnf/points-d-interetss/baignade-dans-le-lauragais-le-lac-de-la-ganguise/), [Plein Soleil](https://www.pleinsoleilparis.fr/le-lac-de-la-ganguise-dans-laude-que-voir-que-faire-et-explorer-aux-alentours/) |
| Lac du Salagou | pro | `w264348544` campsite "Camping et campotel Lac de Salagou", snapped to the shore | NW 316°, **uncertain** (Apple 259°) | No ban found; kite tolerated (Natura 2000), departmental use rules | **ok**. Uncertain is harmless: reservoir shore is jagged around the campsite; both readings face open water to the west, where tramontane comes from. Not on Windy | [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/lac-du-salagou-occitanie-pyrenees-mediterranee-france.html), [vvanat Salagou rules](https://vvanat.fr/blog/responsable-du-kitesurf-sur-lac-du-salagou/) |

No tide column: Mediterranean, no tide. Water types unchanged.

## Windy, both ways (4 Nov, Chrome as a visitor, kite spots layer)

| Windy kite marker | Stars | Ours |
|---|---|---|
| Gruissan (Plage des Chalets) | 5 | Gruissan – Les Chalets / Grazel |
| Plage Mateille, Gruissan | 5 | Gruissan – La Vieille Nouvelle (same beach run, ~1 km) |
| Étang la Nautique | 5 | Narbonne – La Nautique |
| Saint-Pierre-Sur-Mer | 3 | Saint-Pierre-la-Mer – Pissevaches (archived: paid school zone) |
| Cap d'Agde, La Tamarissière | 5 | Agde – La Tamarissière |
| Richelieu (Cap d'Agde) | 5 | **missing** → not added: 4 km from La Tamarissière (keep one within 10 km); jetty makes launching risky, schools ride from a boat. Mentioned in Tamarissière notes. Sources: [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/richelieu-est-cap-d-agde-occitanie-pyrenees-mediterranee-france.html), [Ultimate France](https://www.ultimatefrance.com/kitesurfing/south-france/cap-dagde) |
| Lac de Jouarres (Homps) | 3 | **missing** → not added: minor lake, only spot listings ([Kiteforum](https://se.kiteforum.com/kitesurf/spot/lac_de_jouarres), [Kite & Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/lac-de-jouarres-occitanie-pyrenees-mediterranee-france.html)), no school, no rules found |
| Marseillan (×2) | 5 | Zone fr-thau, not this card |

| Our spot | On Windy? |
|---|---|
| Narbonne-Plage – Créneau Naturel | not on Windy (official town kite zone, kept) |
| Sérignan – La Grande Maïre | not on Windy (archived) |
| Lac de la Ganguise | not on Windy (archived, banned) |
| Lac du Salagou | not on Windy (kept as pro) |

Counts: 9 Windy markers in the zone (excluding Marseillan), 7 matched or explained, 2 missing, 0 added.

## Left for the Lead / Ben

- La Nautique and La Tamarissière both have 5 stars on Windy and real schools: worth `basic`?
  I left tiers alone (trim decisions are the Lead's).
- The Grazel ban and the Ganguise decree come from a guide and the VNF page; neither decree text
  was found online. Worst case applied.
