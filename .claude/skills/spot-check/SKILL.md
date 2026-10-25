---
name: spot-check
description: Validate WhereToKite spot catalogue edits. Use after changing any tools/spots/*.csv row (new spot, locator, hint, sector, tide, banned, tier) and before committing, to run the build on just those files, read the output and fix every PROBLEM.
---

# Checking catalogue edits

Rules for rows live in `tools/spots/README.md`. Read it before editing a CSV.

## 1. Run the check on the files you touched only

```sh
python3 tools/build_spots.py --curated tools/spots/XX.csv --out /tmp/xx.json --review /tmp/xx-review.md
```

- Several files: `--curated tools/spots/FR-atlantic.csv tools/spots/FR-mediterranean.csv`.
- Never write to `Data/spots.json` (the default `--out`) unless asked: CI rebuilds it on merge.
- Network answers are cached in `tools/.osm_cache/`, and public services are rate-limited
  across builds. Two checks can run in parallel. Don't run more than that.
- Exit code 1 means PROBLEMS, or a reference orientation (Castelldefels, Leucate, Wissant,
  Tarifa…) more than 30° off.

## 2. Read each touched spot's line

- **Located by**: it should be an `osm:` beach (`natural=beach`) or a `sport=kitesurfing`
  feature. A street, bus stop or village node means a weak pin. Find a better element with:
  - `python3 tools/osm_lookup.py near <lat> <lon>`
  - `python3 tools/osm_lookup.py search "<name>" <CC>`
- **Direction check**: `agrees` is fine. `corrected` means Apple Maps and the hint overruled
  OSM, which is fine if the hint is right. For `uncertain` / `disagrees`, open the map links in
  the review file. Tidal flats drawn as land and lakes behind a beach are common harmless
  causes. Say so in your report instead of forcing a hint.
- **Ferry**: `access: ferry` only for real islands.
- **Duplicates**: launches less than 2 km apart are rejected. Keep the main launch and
  mention the other one in `notes`.

## 3. Report

For each spot: what changed, the check result, anything left uncertain. Questions that need
local knowledge go to `tools/spots/TO_CONFIRM.md`, under the country's section.

Gotchas:
- The id is `<country>-<slug of name>`. Renaming a spot changes its id, which breaks user
  data and links. Don't rename without a reason.
- Don't delete rows: set `tier` to `archived`, with a `# archived: <reason>` comment above.
- Only encode a `banned` rule from an official source. Otherwise describe it in `notes`.
