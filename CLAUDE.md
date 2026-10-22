# wheretokite

<!-- ATLAS:BEGIN (managed by Atlas: edits inside this block are overwritten) -->
## Working conventions (Atlas)

This project is run from Atlas, Ben's cockpit, but these rules apply to every Claude session, inside Atlas or not.

| File | What it is | Who updates it |
|---|---|---|
| `CLAUDE.md` | Project context: goal, stack, commands, conventions | Ben, or you when something durable changes |
| `docs/HANDOFF.md` | Resume point: where things stand, open topics, next steps | You, at the end of every working session |
| `.atlas/board.json` | The task board | You, as you work |
| `.atlas/streams/<id>.md` | Each workstream's notes: done / in progress / blocked / ready to merge | That workstream |
| `.claude/agents/<id>.md` | Role of each agent (Lead and workstreams) | Ben or the Lead |
| `.claude/skills/<name>/SKILL.md` | Reusable know-how (release checklist, data refresh…) | Anyone, when a procedure repeats |

**Board** (`.atlas/board.json`): `{"cards":[{"id","title","status","assignee","priority","blocks","note","updated"}]}`
- status: `todo` backlog · `ready` Atlas auto-starts it with its assignee · `doing` · `review` done, Ben should check (say what in note) · `waiting` needs an action from Ben · `done`.
- priority: `blocker` (set `blocks`) · `high` · `normal` · `low`. Never change a priority whose `priorityBy` is `ben`.
- Update the card you're working on as you go, before you end your turn. Notes speak to Ben in the second person.
- Edit only the cards you touch and keep the JSON valid.

**Wrapping up**: before stopping, update `docs/HANDOFF.md` and the board so a fresh session can resume from them alone.

**Skills**: when you notice you're repeating a procedure, propose a skill for it in `.claude/skills/`.
<!-- ATLAS:END -->
