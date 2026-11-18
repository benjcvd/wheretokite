# Flat or wavy water, good weather only (WHE-221)

The chill-to-intense "Session style" is gone from the app. Search options now open on two choices:

- **Water**: Flat / Wavy / Either (default Either)
- **Weather**: Good weather only / Any weather (default Any weather)

The defaults change nothing: same ranking as before. The CLI keeps `--style` for checks, and adds `--water flat|wavy|either` and `--weather fair|any`.

## The rule (your call before it ships)

Each hour of a spot keeps a share of its score, like the tide rule. A factor never goes above 100 %, so it can only reorder spots that already work: storms, darkness, bans and offshore stay at 0.

### Water

| Spot | Flat | Wavy |
|---|---|---|
| Lagoon or lake | 100 % | 60 % |
| Sea, waves up to 0.5 m | 100 % | 65 % (up to 0.3 m), rising to 100 % at 1 m |
| Sea, waves 1 m | 80 % | 100 % |
| Sea, waves 1.5 m and more | 60 % | 100 % |
| Sea, no wave forecast | 90 % | 85 % |

Wave height comes from Open-Meteo Marine (about an 8 km grid): it tells a wavy day from a flat one, not the shorebreak.

### Weather (Good weather only)

| Sky | Share kept |
|---|---|
| Sun, some cloud | 100 % |
| Overcast | 85 % |
| Fog, drizzle | 70 % |
| Rain, showers, snow, or 1 mm/h of rain or more | 50 % |
| Thunderstorm | 0 (safety, whatever the choice) |

The sky is the middle of the three blended models (your call, 18 Nov); storm safety still reads the gloomiest. The rain cut that applies to everyone (from 2 mm/h) stays as it is.

Hours that lose something are flagged on the spot: "waves", "no waves", "grey weather", "rain". The score sheet shows a Water and a Weather line.

## Before / after (`swift run kite --day … --slot afternoon --drive 120 --straight-line`, from Barcelona, advanced 78 kg 9/12 m)

### Flat, 12 Nov (westerly, 1 m+ waves forecast along the coast)

| | Either (before) | Flat |
|---|---|---|
| 1 | 95 Salou | 71 Salou ⚠︎ waves |
| 2 | 94 Castelldefels | 69 Punta del Fangar (Ebro delta) |
| 3 | 86 Calafell | 64 Calafell ⚠︎ waves |
| 4 | 80 Malgrat de Mar | 56 Castelldefels ⚠︎ waves |
| 5 | 69 Punta del Fangar | 48 Malgrat de Mar |

Wavy gives the same list as Either that day: there were waves everywhere.

### Good weather only, 3 Nov (northerly, grey in the south, sun on the Costa Brava)

| | Any weather (before) | Good weather only |
|---|---|---|
| 1 | 84 Riumar (Ebro delta) | 69 Pals |
| 2 | 69 Creixell | 69 L'Estartit – Gola del Ter |
| 3 | 69 Pals | 69 Palamós (La Fosca) |
| 4 | 69 Segur de Calafell | 62 Punta del Fangar |
| 5 | 69 L'Estartit – Gola del Ter | 59 Riumar ⚠︎ grey weather |

## Known limits

- Bays on sea spots (Fangar bay, the sea side vs lagoon side of a sandbar) read the open sea's waves: Fangar was flagged "waves" on 12 Nov although the bay is flatter. A per-side water type in the catalogue would fix it (Spot improvement card).
- "Gloomiest of the models" makes grey weather fairly common: Pals was flagged on 3 Nov. A milder reading (the middle model) is an option.
- The live Worker has no allow-list yet, so wave heights flow today. The pending lockdown deploy must include this change (`wave_height` allowed), or the app falls back to "no wave forecast" (90 % / 85 %); nothing else breaks: waves have their own request, tides are untouched.
- Cost: one more marine request per search (one call per sea spot on Open-Meteo's count), shared through the Worker cache.
