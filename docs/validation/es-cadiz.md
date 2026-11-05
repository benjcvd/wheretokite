# Validation: Cádiz coast, Rota to Caños de Meca (zone `es-cadiz`, WHE-100)

Date: 2026-11-05. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: no earlier sourced pass on these rows (`git log` on `ES.csv` shows only pipeline and Catalan commits);
the seven rows came from the first Spain pass with unsourced notes. Pins and facing come from the build (OSM elements,
Apple Maps check).

Limits of this pass, said plainly: about 19 web searches. I read spot-guide and school pages through search results and
fetches; no school site was opened one by one. Pins were not eyeballed on satellite (Chrome was used for Windy only).
**No official text (Barbate, Vejer, Chiclana, Rota, Cádiz, San Fernando, Costas) was found for any summer rule**, so no
`banned` was set; the summer claims are in the notes as "guide says, ask a school".

## Our 7 spots, one by one

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Los Caños de Meca | fixed (notes) | `q:` locator (Nominatim), faces SE (130°), shore 242 m. Build says "uncertain": Apple water reads 172° vs 130°, because the point curves towards the lighthouse. Hint SE (levante side-on) kept | Old note said "officially no kiting in summer": no official source. A school page says part of the beach is reserved in summer, bathing zones to respect. Now in notes only | [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/canos-de-meca-estrecho-de-gibraltar-tarifa-spain.html): levante, 2 forces lighter than Tarifa, reef, kiters launch towards the lighthouse. [Kite Fun Tarifa](https://kitefuntarifa.com/en/kitesurf-spots-tarifa/kitesurf-spot-canos-de-meca.html): intermediate and above, rocks, summer reserved area. Windy 5 stars |
| El Palmar (Vejer) | fixed (notes) | `q:` locator, OSM beach, faces WSW (243°), shore 23 m, Apple agrees | Guide says kiting banned in summer: no official text. Kept in notes, "treat summer as closed" | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/el-palmar-costa-de-la-luz-cadiz-spain.html): poniente is the main wind, levante weak, powerful shorebreak at high tide, strong current. Mostly a surf beach. **Second source thin**: Windy 5 stars only, no kite school found on the beach. Kept as is |
| Chiclana – Sancti Petri | fixed (notes) | `osm:w198773943`, faces SSW (208°), shore 10 m, Apple agrees. This is the south end of La Barrosa beach | Old note "summer only inside water-sports channels": no source, removed. Guide: kite ban June to September; no official text, in notes | [Guide, La Barrosa](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/la-barrosa-costa-de-la-luz-cadiz-spain.html): poniente and SSE levante, island shelters swell. [Kite Surf Chiclana](https://www.yumping.com/en/water-sports/kite-surf-chiclana--e12006) school (since 2006). Windy "La Barrosa" 5 stars = same beach |
| San Fernando – Camposoto | fixed (notes) | `osm:r16174862`, faces WSW (249°), shore 13 m, Apple agrees | "Local kite club" and "summer channel" removed: nothing found (the town's summer sports programme lists surf, kayak, no kite club). Summer rule unknown, notes say ask locally | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/camposoto-costa-de-la-luz-cadiz-spain.html): strong poniente, shorebreak at high tide, ex-military zone. [Camposoto beach listing](https://wildopenwater.com/swimspot/playa-camposoto-c%C3%A1diz-andaluc%C3%ADa-spain) says kiteboarding suitable. Thin, kept as Pro. Windy 3 stars |
| Cádiz – Cortadura | fixed (notes) | `osm:w91048435`, faces WSW (249°), shore 43 m, Apple agrees | Buoyed bathing areas in summer (press). `tide: not-low` came from the first pass; the sources I found don't confirm it, so it is flagged "not re-confirmed" and kept | [Guide, Cortadura](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/cortadura-costa-de-la-luz-cadiz-spain.html) and the Costa de la Luz list: poniente cross-on or levante cross-off, winter and spring best. Windy 2 stars |
| El Puerto – Valdelagrana | fixed (notes) | `osm:w23911521`, faces WSW (247°), shore 142 m, Apple agrees | "Water-sports channel" claim unsourced: removed, "ask the schools" instead | Two schools on the beach: [Cadiz Kite](https://www.yumping.com/en/kitesurfing/cadiz-kite--e19741352) and [Foreño](https://www.yumping.com/en/water-sports/foreno-escuela-de-kitesurf--e19756858); [Kiteforum spot page](https://se.kiteforum.com/kitesurf/spot/valdelagrana). Windy 4 stars |
| Rota – El Rompidillo | fixed (notes) | `osm:w194605149`, faces ESE (106°), shore 58 m, Apple agrees | Guide: kiting banned all over Rota in summer; no official text, in notes | [Guide, Rota Playa Luz](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/rota-playa-luz-costa-de-la-luz-cadiz-spain.html): Rompidillo is the out-of-season levante alternative. **Only one kite source**; kept as Pro. No Windy marker of its own |

Tide: no local source gives a tide window for any of the seven, so none was changed (only Cortadura carries `not-low`).
Sectors are left empty (build default from the facing and hint).

## Windy, both ways (browsed as a visitor, 5 Nov, kite markers hovered; positions not copied)

Windy marker → ours (15 markers from Sanlúcar to Barbate; Bolonia belongs to the Strait zone):

| Windy marker (stars) | Ours |
|---|---|
| Caños de Meca (5) | Los Caños de Meca |
| El Palmar (5) | El Palmar (Vejer) |
| La Barrosa (5) | Chiclana – Sancti Petri (same beach, south end) |
| Camposoto (3) | San Fernando – Camposoto |
| Cortadura (2) | Cádiz – Cortadura |
| Valdelagrana (4) | El Puerto – Valdelagrana |
| Rota (5) | **added (Pro)** Rota – Playa de la Luz (the kite guide's "Rota, Playa Luz"); Rompidillo is a different aspect, kept |
| La Ballena (3) | **added (Pro)** Rota – La Ballena |
| Punta Candor (3) | **added (Pro)** Rota – Punta Candor (one source: the guide) |
| La Victoria (5) | **added (Pro)** Cádiz – La Victoria (about 2 km north of Cortadura but a different beach break) |
| Conil (5) | **added (Pro)** Conil – Los Bateles |
| Buzo (3) | left out: no OSM beach fits, and no source says which beach (Fuentebravía or Santa Catalina area) |
| Cádiz (5) | left out: no kite source for a city beach (the guide lists La Victoria and Cortadura only) |
| Barbate (5) | left out: only surf listings found, no kite source |
| Sanlúcar de Barrameda (4) | left out: Las Piletas and Bajo de Guía are used per school listings, but OSM has only unnamed beaches there, so no pin I can trust |

Ours → Windy: every spot has a marker except Rompidillo (nearest: Rota).
Counts: Windy markers in the zone 15; matched to ours 6 (Caños, Palmar, La Barrosa = Sancti Petri, Camposoto, Cortadura, Valdelagrana); added as Pro 5 (Playa de la Luz for the "Rota" marker, La Ballena, Punta Candor, La Victoria, Conil); left out 4 (Buzo, Cádiz, Barbate, Sanlúcar).
Our spots 7 → 12: 3 free (Caños, Palmar, Sancti Petri), 9 Pro, 0 archived.
Gap: Windy still shows 4 markers we lack; each lacks a pinnable place or any kite source, none is left out for being minor.

## Open
- Summer rules for Barrosa, Palmar, Rota, Caños: no official text found (`TO_CONFIRM.md`, settled rule of 2 Nov).
- Pins not eyeballed on satellite.
- Build check of the five new rows was blocked by OSM server timeouts when this was written: see the card note for the result.
