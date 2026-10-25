---
name: merge-workstream
description: Review and merge an Atlas workstream branch (atlas/<id>) into main for WhereToKite, then push and follow CI once Ben says so. Use when Ben says "merge", when a workstream card says "tell the Lead to merge", or before pushing main.
---

# Merging a workstream

Workstreams live in `.atlas/streams.json` (id, branch, worktree). Their notes are in
`.atlas/streams/<id>.md`, under "Ready to merge".

## 1. Review

```sh
git log --oneline main..atlas/<id>
git diff --stat main...atlas/<id>
git diff main...atlas/<id> -- <files>
```

- **Scope**: every changed file must belong to the workstream (`.claude/agents/<id>.md`,
  section Scope). Anything else (e.g. `tools/build_spots.py` changed by Spot improvement):
  read it line by line and look for side effects in the app. Example: routing Moroccan spots
  from Moroccan cities made them "mainland", so the engine needed a Europe / Africa split.
- **Spots**: rebuild only the touched countries with `spot-check`. No PROBLEMS, and the spot
  count must not drop by more than 10% (CI refuses that build).
- **Code**: run `preflight`.
- Never merge `Data/spots.json` edited by hand.

## 2. Merge (local)

```sh
git merge --no-ff atlas/<id> -m "Merge <workstream>: <what, in plain words>"
```

Then fix any side effect in a separate commit, with a test. Re-run `preflight`.

## 3. Push: only after Ben says "push"

```sh
git push origin main
gh run list --workflow catalog-build.yml --limit 3   # if tools/spots/** changed
gh run watch <run-id>
```

- The catalogue build commits `Data/spots.json` back to `main`: `git pull` afterwards.
- It fails on a cold OSM cache or Overpass / Valhalla errors: read the log, rerun once, and
  if it still fails, write a card for Ben.
- After a big catalogue change, propose the `osm-cache` refresh to Ben (it's public):
  `tar -czf osm-cache.tar.gz -C tools .osm_cache && gh release upload osm-cache osm-cache.tar.gz --clobber`

## 4. After

- Bring the workstream up to date: `git -C <worktree> merge --ff-only main`.
- Board: the workstream's `review` cards → `done`, and remove the merge card. In the stream
  notes, empty "Ready to merge" with one line (merged in `<sha>`, pushed or not).
- `docs/HANDOFF.md`: one or two lines of narrative if a decision was taken.
