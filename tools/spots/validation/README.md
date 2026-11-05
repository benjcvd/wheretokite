# France and Spain spot validation

Before launch, every French and Spanish spot is checked by hand, one zone at a time
(Ben, 3 Nov). The catalogue rules in [`../README.md`](../README.md) and the Spot improvement
role still apply; this file adds the method and the tracker.

| File | What | Who edits it |
|---|---|---|
| `zones.json` | The 30 zones: which CSV regions (and box) each covers | The Lead |
| `status.csv` | One line per zone: status, card, counts, report, date | The workstream on its zone's line only; the Lead sets `validated` |
| `docs/validation/<zone>.md` | The zone report: one row per spot, Windy table, sources | The workstream |
| `docs/validation_map.html` | Map of where we're at, built by `python3 tools/validation_map.py` | Generated |

Status: `todo` → `doing` → `review` (report and commit ready on the branch) → `validated`
(merged into main by the Lead). `waiting` = a question for Ben blocks the zone.

## The method: slowly, one spot at a time

Take your time. A zone is at most about 8 spots, so there is room to check each one
properly. Accuracy beats speed: no shortcuts, no batch guesses, no subagents.

**0. Read what was already done.** `git log --oneline -- tools/spots/<file>.csv` for the
zone, the matching section of `TO_CONFIRM.md`, and the done cards it names. Don't redo a
check that is already sourced; record it in the report as "checked on <date>, <commit>".

**1. Each spot, one by one** (finish one before starting the next). For each, write a row in
the report with a verdict and the sources:
- **Is it real and famous?** Two independent sources: schools or clubs on site, federation,
  town hall or tourist office, spot guides. Pure surf or windsurf spots don't count.
- **Pin**: on the water where people ride, from the OSM element (`tools/osm_lookup.py`), checked
  on satellite in Chrome and against school or town kite-zone maps. Never typed coordinates.
- **Direction**: the beach faces the way the build says (Apple Maps check agrees); the
  `sector` (rideable wind directions) matches what schools say, onshore and side-shore only.
- **Rules**: official bans, summer bathing zones, kite corridors, with the decree or the town
  page as source (préfecture maritime arrêtés for France; ayuntamiento, Costas or capitanía
  for Spain). `banned` only from an official source; otherwise in `notes`.
- **Tide** (Atlantic and Channel): the tide window matches what local schools say.
- **Water type, level, tier, notes**: notes rewritten in plain words from the sources.
- Verdict: `ok`, `fixed` (say what), `archived` (say why) or `question` (for TO_CONFIRM).

**2. Windy, both ways** (Claude in Chrome, as a visitor only: hover the kite markers on
`windy.com/?<lat>,<lon>,9,p:kitespots`; never scrape, never copy positions). Table in the report:
every Windy kite marker in the zone → our spot or "missing"; every spot of ours → Windy marker
or "not on Windy". Ignore pure surf markers.

**Missing markers are added as Pro by default** (Ben, 4 Nov). A Windy kite marker we don't
have goes into the catalogue as `tier` pro (pin from OSM through the pipeline, sector and notes
from a school, club or town page) **unless there is a good reason not to**, written in the
table. Good reasons, and only these:
- Windy shows the spot with no rating, or a rating of 0 (Ben, 5 Nov): note it as
  "unrated on Windy" and skip it. Read the rating as a visitor sees it on the marker or spot
  card; never pull it from Windy's data;
- kiting is banned there all year, or the only access is through a school (official source);
- it's the same beach as one of ours (same water, under about 2 km, same winds): say which;
- it isn't a kite spot (surf, wing or windsurf only; harbour; private) per a local source;
- no OSM element fits the place where people ride, so it can't be pinned.
"Not famous enough", "only one source" or "close to another spot" are **not** reasons. One
source (a school, a club, a forum thread) is enough for Pro. The 10 km rule of
`../README.md` doesn't apply to these Pro additions.

**3. Close the zone.** `spot-check` on the CSV with no PROBLEMS; commit on your branch; update
your zone's line in `status.csv` (`review`, counts, report path, date); card → `review` with
`Why:` / `Status:` / `Check:` / `You:`; stop. Don't start another zone.

**4. Your reply to Ben** (and the card note) always contains the Windy comparison, not just the
report link:
- the counts: Windy markers in the zone, matched to ours, added as Pro, left out; our spots
  before → after (free / Pro / archived);
- a short table of every Windy marker we don't have: name → `added (Pro)` or the reason it
  was left out, in a few words;
- when Windy shows clearly more spots than we have after your pass (say 3 or more), one line
  explaining the gap.

Open questions go to `TO_CONFIRM.md` under the country, settled with the rule of 2 Nov (look it
up, else assume the worst). Ask Ben (card → `waiting`) only when the worst case would remove a
spot people rely on.
