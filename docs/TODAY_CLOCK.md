# Today's search only offers hours you can still reach (WHE-161)

Safety rule, for your OK before merge.

## The rule

- For **today**, a spot's hours count only from *now + drive time*, rounded up to the next full hour (in your favour: most drives are estimates). Earlier hours score 0, marked "too late".
- The real Apple Maps drive replaces the estimate once known, and the cut follows it.
- If no spot has an hour left in the session, the app says **"This session is over"** and offers tomorrow (the "Next good window" card when one exists, else a "See tomorrow" button).
- Other days are untouched. Each spot uses its own clock (Portugal is an hour behind Spain).

## Before / after: the audit's case

11 Nov, Barcelona, afternoon, 2 h drive (`swift run kite --day 2026-11-11 --slot afternoon --drive 120 [--now HH:MM]`).

| Search time | Before | After |
|---|---|---|
| 17:52 | Malgrat de Mar, **16:00–18:00**, 53 min drive (you'd arrive at 18:45, after the window, after dark) | **"This session is over"**, try tomorrow |
| 13:20 | Malgrat de Mar 16:00–18:00 | same: arrival 14:13, the 16–18 h window is still reachable |

## Choices made (tell me if you want otherwise)

1. Arriving on the hour counts that hour (14:00 arrival keeps 14 h). No extra time added for parking and rigging. (recommended: keep; could add 15 min.)
2. Results left open on screen don't expire when the window passes; they refresh when you come back to the app after an hour (unchanged).
