# Validation: Asturias, Cantabria and the Basque Country (zone `es-north`, WHE-106)

Date: 2026-11-05. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: no earlier sourced pass on these rows (`git log` on `ES.csv` shows only pipeline commits). Before this pass the zone had
7 spots (2 free, 5 Pro) and no Basque spot.

Limits of this pass, said plainly:
- Overpass was down, so pins come from OSM elements found through Nominatim (name search and id lookup), not `osm_lookup.py`.
  No pin was eyeballed on satellite (Chrome used for Windy only). Build result: see "Build" at the bottom.
- No official kite-zone text was found for any spot: summer rules come from spot guides and the Northwind school. `banned` stays only
  where it already was (Los Peligros, worst case kept); nothing new is encoded.
- About 14 web searches/fetches. School pages for Asturias do not exist online (no kite school found in Gijón or Salinas); sources are the
  Asturkiters club's spot page (via a search result; the site itself was unreachable), spot guides and the Explora Playa guide.

## Our spots

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Salinas – San Juan de Nieva (free) | fixed (notes) | `w516073411`, OSM name "Playa de El Espartal": Nominatim returns it for "Playa de Salinas" and "San Juan de Nieva", i.e. the 3 km Salinas beach. Kept | Summer: separate kiter entrance, follow the lifeguards (no ban found) | [Explora Playa](https://exploraplaya.es/kitesurf-playa-salinas-san-juan-de-nieva/), [Explora Playa Asturias](https://exploraplaya.es/kitesurf-asturias/): the main west-wind spot (SW to NW). Notes now say that. Windy 5 stars |
| Gijón – El Arbeyal | fixed (notes) | `r2324779`, kept | Turismo Asturias: boards and sailing craft prohibited inside the bathing zone; sports on the sand 10–20 h prohibited. Enter near El Musel, upwind outside the buoys | [Explora Playa El Arbeyal](https://exploraplaya.es/kitesurf-playa-del-arbeyal-gijon/), [Turismo Asturias](https://www.turismoasturias.es/en/descubre/costa/playas/playa-de-el-arbeyal): NE and NW, rocky bottom at low tide, gusty offshore. **Fixed**: old note "all levels" removed (guides say not for beginners). No separate Windy marker (see below) |
| Gijón – San Lorenzo | fixed (notes) | `w517332406`, kept; tide `not-high` kept (small beach at high tide) | In bathing season lifeguards allow one small channel around stairs 8–10, ride outside the yellow buoys. No ban encoded | [Explora Playa San Lorenzo](https://exploraplaya.es/kitesurf-playa-san-lorenzo-gijon/), same Asturias page. NE and E. Windy 5 stars |
| Luanco – Santa Marina | fixed (notes, pin) | Locator `q:` replaced by `osm:w1106005817` (the same beach Nominatim returned) | Spot guides: municipal rules ban kitesurf in summer; the Asturkiters page adds that kiters then use a separate zone under a wooden lookout. No ordinance text found, so not encoded; notes say to ask | [Explora Playa](https://exploraplaya.es/kitesurf-asturias/), [Asturkiters spots](http://asturkiters.es/spots.html) (search result). Their "west wind" line looks copied from Salinas: our hint E and the Explora note (N, E, NW) kept. Windy 4 stars |
| Somo | fixed (notes) | `q:Playa de Somo` = `w516058323`, beach centre; schools are at La Poza (west end). Kept as is | No ban found. Buoyed channel to Pedreña forbidden. A 2018 school blog mentions a kite launch zone 15 Jun–15 Sep about 1 km west of the car park (not confirmed officially) | [Northwind spot guide](https://northwindcompany.com/kitesurf-spots-cantabria/): NW and W at any tide, NE/E offshore best low–mid tide, SW gusty. [Northwind courses](https://northwindcompany.com/cursos-somo/kitesurf/) and [Ribamontán al Mar town hall page](https://www.ribamontanalmar.es/northwind-kitesurf/): school since 2004. [Kiteforum](https://se.kiteforum.com/kitesurf/spot/somo_beach). Windy "Santander" 5 stars is the bay |
| Santander – Los Peligros | fixed (notes) | `w28423268`, kept | `banned 06-01..09-30` has no official source (only Northwind). Rule: worst case, ban kept, notes say so | Northwind guide: SW only, gusty, any tide. Kiteforum lists it. Windy: covered by the "Santander" marker |
| Laredo – Salvé | fixed (notes, pin) | Locator `q:` → `osm:w159113808` (same beach) | Summer: ride parallel, upwind of bathers; no ban stated | Northwind guide: E onshore, also NE/W/NW near the Regatón; Kiteforum lists Laredo. Windy 5 stars |

## Windy, both ways (browsed as a visitor, 5 Nov, markers hovered; names only, no positions copied)

Windy kite markers in the zone: 25 (10 Asturias, 6 Cantabria, 9 Basque Country incl. one reservoir; Hendaye, 5 stars, is French and
out of zone). Matched to ours: 5. Added as Pro: 13. Left out: 7. Our spots: 7 (2 free, 5 Pro, 0 archived) → 20 (2 free, 18 Pro, 0 archived).

| Windy marker (stars) | Result |
|---|---|
| Salinas (5), Playa de San Lorenzo (5), Luanco (4) | matched |
| Laredo (5), Santander (5) | matched (Laredo; Santander = Somo / Los Peligros bay) |
| Ría de Rodiles (4) | added (Pro): Ría de Rodiles |
| Playón de Bayas (2) | added (Pro) |
| La Espasa (3) | added (Pro): La Espasa (Caravia) |
| Penarronda (3) | added (Pro): Peñarronda (Castropol), thin source (spot directory) |
| Oyambre (4) | added (Pro) |
| Liencres (4) | added (Pro): Liencres (Valdearenas) |
| Orinon (3) | added (Pro): Oriñón, thin source |
| Ereaga (5) | added (Pro): Ereaga (Getxo) |
| La Arena (3) | added (Pro): La Arena (Muskiz) |
| Gorliz (4) | added (Pro) |
| Mundaka (4) | added (Pro) as Laida (Mundaka), the beach the kite guide describes |
| Zarautz (5) | added (Pro) |
| Zurriola (5, "Donostia" side) | added (Pro) |
| Suances (4) | left out: sources give no beach (La Concha or Los Locos) where people ride, so it cannot be pinned |
| Vega (3) | left out: only surf guides (surf, not kite) |
| Navia (2) | left out: the only kite guide calls it a wave beach, gusty, poor water; surf, not kite |
| La Charca (4) | left out: no source at all and no OSM element found for it; retry later |
| Sopelana (4) | left out: kite guide says it rarely works; no OSM beach pinned with certainty (Overpass down); retry |
| Playa de Laga (3) | left out: no kite source found |
| Ulibarri-Gamboa (3, reservoir) | left out: no OSM element found while Overpass is down; kite guide says access is through the nautical club (members) and Landa beach is free off-season. Retry |
| Hendaye (5) | France, other zone (not counted) |

Not seen on Windy but in a spot directory: Hondarribia (NE wind behind the mole, "minor spot", waves small); Arrigunaga (demanding, poor water);
Bakio (needs swell). Not added, no Windy marker and no local kite source of weight.
Gijón has one Windy marker per beach cluster; El Arbeyal sits under the San Lorenzo marker at this zoom, so it is ours-only.

Gap: Windy shows 25 markers against our 7 before the pass; the Basque Country (0 before) and the Cantabrian wave beaches were the gap.
After the pass we have 20 spots, with 3 weak entries (Peñarronda, Oriñón, Bayas): they have only a spot-directory listing and say so in their notes.

## Basque Country: famous kite spots, looked up
Kite schools in Euskadi are rare: results list Groseko Indarra (Donostia, kite since 2006; [directory](https://www.badgie.es/directorio/groseko-indarra-surf-eskola-taldea))
and Hondarribia nautical centres, otherwise only surf schools. Basque kiting is wave, wind-and-swell dependent: all additions are Pro,
none free. Spot sources: [Kite and Windsurfing Guide Euskadi](https://web.kite-and-windsurfing-guide.com/de/europa/spanien/euskadi-baskenland.html),
[Zarautz](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/zarautz-euskadi-pais-vasco-spain.html),
[Kiteforum north Spain](https://se.kiteforum.com/kitesurf/487/region/Region+North+Spain). Donostia beach rules (2026) cover smoking and noise;
kite is not mentioned, surf zones are flagged in summer ([Noticias de Gipuzkoa](https://www.noticiasdegipuzkoa.eus/donostia/2017/06/14/regular-zurriola-surf-limite-surf-3997266.html)).

## Open
- Pins not checked on satellite; Overpass was down, so pins use Nominatim-found OSM elements. Re-run the build when Overpass is back.
- Suances, Sopelana, Ulibarri-Gamboa, La Charca, Hondarribia: retry once Overpass is back (see table).
- Asturian summer rules (Luanco, San Lorenzo, Arbeyal, Salinas): no ordinance text found; town hall pages (Gozón, Gijón) would settle them.

## Build
`build_spots.py` on the 20 zone rows (curl wrapper, Overpass mostly down): no PROBLEMS; Apple Maps check agrees 19, uncertain 1 (Laida: water faces WNW,
hint changed N → NW; an estuary mouth, experts only). Salinas, Laredo and Gorliz were moved to the shore the build computed (about 100 m).
