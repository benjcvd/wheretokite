# Zone fr-thau: Étang de Thau and Sète

Validated 3–4 Nov 2026 (WHE-96), method in [tools/spots/validation/README.md](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Box 43.30–43.48 N, 3.50–3.85 E, region Languedoc, file `tools/spots/FR-mediterranean.csv`.

Past work: rows date from the France Med catalogue (0e694f4), the famous-spots trim (d96ef24) and tiers (4a031c3).
`TO_CONFIRM.md` listed the Marseillan (Maldormir) and Ingril launches and Ingril's weak pin as open; both settled below.

## Spots

| Spot | Tier | Verdict | Pin (OSM) | Faces / Apple | What changed |
|---|---|---|---|---|---|
| Sète – Pont-Levis | basic | ok (notes) | n8431319287, Triderland kite school at the Pont-Levis car park | NW 315° / agrees | Notes: kite zone all year, no jumping at the launch or along the dyke, avoid east wind, heliport zone, second dyke in summer (birds) |
| Marseillan – Étang de Thau | pro | fixed (notes) | w370485330, Plan de Maldormir | WNW 303° / uncertain (Apple 261°, irregular lagoon shore, harmless) | Notes: removed the unsourced "association Camikas"; N–NW onshore, small launch, protected bird area, village shore (Kithau) as alternative |
| Mèze – La Pinède | pro | ok (notes) | n8951413979, Fil d'Air kite school (Plage du Thalassa 166 m) | SSE 158° / agrees | Notes: Le Taurus nautical centre, south winds onshore, tramontane offshore, school named |
| Sète – Les 3 Digues | pro | fixed (pin) | n14082437492, beach node "plage des trois digues" | SE 137° / agrees | `q:` search replaced by the same OSM element (stable). Notes: kite zone at accesses 53–54 |
| Frontignan – Étang d'Ingril | pro → archived | archived | n1305757756 (unchanged) | — | Free kiting suspended, schools only (see below) |

### Sète – Pont-Levis
- Real and famous: four kite schools based at the Pont-Levis car park (ID Kite, Magic Bruce, Paul'eau, Triderland, listed by Hérault Tourisme / Archipel de Thau); UltimateFrance guide; Windy "Sète" ★★★★★ on this spot.
- Rules: no official order found; local rules (one kite at a time on the sandbank, no jumps at the launch, heliport zone) from UltimateFrance and vvanat, kept in notes, not encoded.
- Direction: NW tramontane onshore matches the sources; east wind is the one to avoid. Default sector kept.

### Marseillan – Étang de Thau (Maldormir)
- Sources: wannakitesurf and unplug-kitesurf spot pages "Étang de Thau Maldormir" (NW recommended, small launch, bird area inland); vvanat Marseillan guide (Maldormir suited to north wind). Windy "Maldormir" ★★★ at the pin.
- Pin settled (was open in TO_CONFIRM): Maldormir is the launch the sources name.
- "Camikas" association: no trace in any source, removed.

### Mèze – La Pinède
- Sources: Fil d'Air kite school on site since 1998, Centre nautique Le Taurus (Hérault Tourisme listing); UltimateFrance (northern shore, waist-deep sandbanks, good for learning). One blog (vvanat) calls Mèze less interesting in south wind: contradicts the geometry and the guide, not followed.
- Not on Windy. Kept as Pro (13 km from Pont-Levis, different shore: works in southerlies).
- Open, minor: the name "La Pinède" isn't confirmed by a source (school sits at Le Taurus / Plage du Thalassa). Not renamed (the id would change); left for a later pass.

### Sète – Les 3 Digues
- Sources: Hérault Tourisme beach page ("zone pour pratiquer le kitesurf, accès n°53 et 54"); UltimateFrance (one of the few beaches kited in summer, southerly thermal onshore, north wind offshore and gusty); Archipel de Thau (summer kite zone).
- No Windy marker here (nearest: "La Corniche" ★★★, 4.5 km NE, same sea conditions).
- Pin: beach accesses 53–54 aren't mapped in OSM; the pin is on the named beach element midway between Sète and Marseillan, as Hérault Tourisme describes. No municipal kite order found, so no `banned` rule.

### Frontignan – Étang d'Ingril: archived
- Prefectoral order [n°318/2023](https://www.frontignan.fr/contenus/uploads/2023/09/24dc63e665dde593735dee8943546322-1.pdf) (préfet maritime de la Méditerranée, 21 Sep 2023) created a zone in the south of the lagoon where kites were allowed in daytime hours only, the rest of the lagoon being reserved to the municipal school.
- Since then: [Hérault Tourisme](https://www.herault-tourisme.com/fr/fiche/patrimoine-naturel/l-etang-d-ingril-frontignan-plage_TFOPNALAR034V52OQ9Q/) says kite, wing and windsurf are now only practised with schools, free practice no longer allowed by prefectoral order; [ActuNautique, June 2026](https://www.actunautique.com/2026/06/etang-d-ingril-le-laboratoire-inquietant-d-un-littoral-sous-cloche.html) describes free practice as suspended, schools only, pending a carrying-capacity study.
- The newer order itself wasn't found. Rule of 2 Nov (assume the worst): archived as a schools-only spot. Re-check if free kiting reopens.

## Windy, both ways (visitor, 3 Nov, `windy.com/?43.39,3.66,11,p:kitespots` and zooms)

| Windy marker | Popularity | Our spot |
|---|---|---|
| Sète | ★★★★★ | Sète – Pont-Levis |
| Le Barrou | ★★★ | covered by Pont-Levis (same lagoon, ~2 km) |
| La Corniche | ★★★ | covered by Les 3 Digues (same sea coast, 4.5 km); summer kite zone is at 3 Digues |
| Marseillan | ★★★★★ | covered by Marseillan – Étang de Thau (village shore, 3 km from Maldormir; named in notes) |
| Maldormir | ★★★ | Marseillan – Étang de Thau |
| Frontignan Plage (sea side, off the west end of the beach) | ★★★★★ | **missing**, see below |

| Our spot | Windy |
|---|---|
| Sète – Pont-Levis | Sète |
| Marseillan – Étang de Thau | Maldormir |
| Mèze – La Pinède | not on Windy |
| Sète – Les 3 Digues | not on Windy |
| Frontignan – Étang d'Ingril (archived) | no lagoon marker |

**Frontignan sea side, not added.** Real and kited (Windy ★★★★★; vvanat names an official kite zone by the concrete bunkers at Les Aresquiers, club InKiWi; Archipel de Thau lists kite at Plage des Aresquiers). But the sources disagree on where the zone is (west end of Frontignan-Plage on Windy vs the Aresquiers bunkers 4 km east), tramontane is offshore there, and no town or prefectoral text on kites was found: the Frontignan beach order [n°1197-2025](https://www.frontignan.fr/contenus/uploads/2025/07/2025-1197-Securite-plages.pdf) only sets bathing zones (incl. Aresquiers, posts 58–59) and bans craft in the marked channels. Left out under the worst-case rule; written in `TO_CONFIRM.md` and a follow-up card.

Agde markers (La Tamarissière, Malfato) are west of 3.50 E: zone fr-narbonne.

## Counts
5 spots checked · 6 Windy markers, 4 matched or covered, 1 missing not added (1 marker = 2 of ours) · 0 added · 1 archived.
Before → after: 5 active (1 basic, 4 pro) → 4 active (1 basic, 3 pro), 1 archived.
