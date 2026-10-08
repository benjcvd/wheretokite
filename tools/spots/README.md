# Spot catalogue sources

One CSV per country (ISO 3166-1 alpha-2 file name, e.g. `FR.csv`). `tools/build_spots.py`
reads every `*.csv` here and writes `Data/spots.json`. Lines starting with `#` are comments.

Only **well-known** spots belong here: places with established kitesurf use (kite schools or
clubs, a kite zone, listed by several independent spot guides). Users add their own low-key
spots in the app.

## Columns

`country,region,name,water,locate,hint,notes,sector,tide`

- `country`: ISO code (also restricts the Nominatim search).
- `region`: human-readable area shown in the app ("Côte d'Opale").
- `name`: spot name as kiters know it. The id is derived from country + name, so renaming
  changes the id.
- `water`: `sea` | `lagoon` | `lake`. sea → orientation from OSM `natural=coastline`;
  lagoon/lake → from the nearest OSM `natural=water` polygon (falls back to the coastline).
- `locate`: coordinates are never typed. Either
  - `osm:<n|w|r><id>`: an OpenStreetMap element, its centre (best: the beach
    `natural=beach` way, or a `sport=kitesurfing` feature), or
  - `q:<text>`: a Nominatim search restricted to `country`; beach / natural features are
    preferred over streets or bus stops of the same name. Quote the field if it has a comma.
- `hint`: rough direction from the beach to the open water (16-point compass: N, NNE, NE…).
  Used to pick the right shore on sandbars / isthmuses, to sanity-check OSM, and as the
  tie-breaker when OSM and Apple Maps disagree. The published direction comes from map data.
  Spots kitable from several shores list one side per direction separated by `|`:
  `DIR:label[:water]`, e.g. `NW:North Sea side|SE:Grevelingen side:lake` (the first side's
  water must be the row's). Each hour is scored on the side where the wind works best.
- `notes`: shown in the app. Tide dependence, seasonal bans / summer zones, level
  (e.g. "waves, experienced riders"), access. Quote the field if it has a comma.
- `sector` (optional, default 180): width in degrees of open water seen from the launch.
  180 = straight beach; < 180 = cove / narrow bay (side winds blow off the land);
  > 180 = point or headland (the shore curves, so more wind directions work);
  360 = small lake or spot kitable from any side.
- `tide` (optional): when the spot works, for spots that genuinely depend on the tide
  (tidal flats, bays that dry out, shallow lagoons, sandbars that cover): `high` (around
  high water), `low` (around low water), `mid`, `not-low` (anything but low water),
  `not-high`. Leave empty when any tide works or there is no tide. The app fetches the
  tide forecast for these spots and scores hours outside the window as 0.

## Checking a file

    python3 tools/build_spots.py --curated tools/spots/FR.csv --out /tmp/fr.json --review /tmp/fr-review.md

prints, for those rows only: where each spot was located, the computed direction, the Apple
Maps cross-check (`agrees` / `corrected` / `uncertain` / `disagrees`), whether a ferry is
needed, and PROBLEMS (exit code 1). Network responses are cached in `tools/.osm_cache/` and the
public services are rate-limited across all running builds, so several checks can run at once.

A country may be split into several files (`FR-atlantic.csv`, `FR-mediterranean.csv`) so
regions can be curated independently; each spot must appear in exactly one file.

## Curation guidelines

What makes a spot "well known" (include it):
- Established kitesurf use confirmed by **at least two independent sources**: kite schools /
  IKO-VDWS centres / clubs operating there, national federation or regional site lists,
  local kite associations, kite spot guides and travel guides (e.g. Windfinder / Windguru
  spot pages, globalkitespots, kiteworldwide, magazine spot guides), local authority pages
  describing a kite zone.
- Kitesurfing allowed at least part of the year. Exclude spots banned all year. Mention
  seasonal bans / summer-only zones / permits in `notes`.
- One row per launch that kiters treat as a separate spot. Launches less than 2 km apart
  are one spot (the build rejects duplicates within 2 km); pick the main launch.
- Skip pure wave-surf beaches, harbours, and places only reachable by boat (downwinder
  destinations).

How to fill a row:
- Prefer `osm:` ids of the actual launch beach (`natural=beach`) or a kite school / club
  feature (`sport=kitesurfing`) — use `python3 tools/osm_lookup.py near <lat> <lon>` and
  `python3 tools/osm_lookup.py search "<name>" <CC>`. Use `q:` only when it resolves to the
  beach itself.
- `hint`: the direction you expect from the beach to the water. For lagoons, flat-water
  bays, lakes, think about where riders actually launch.
- Use multi-side hints only for spots genuinely ridden from several shores (isthmus,
  sandbar with sea + lagoon). Use `sector` for coves (< 180), points (> 180) and small
  lakes ridden from any shore (360).
- `notes`: one or two short sentences a rider needs: flat / chop / waves, tide window,
  level, seasonal restrictions. No marketing.

Then run the check for the file(s) and fix every PROBLEM; review spots whose direction is
`uncertain` / `disagrees` (tidal flats drawn as land and lakes behind a beach are common
harmless causes — say so in the report).
