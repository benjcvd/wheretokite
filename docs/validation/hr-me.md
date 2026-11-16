# Validation: Croatia and Montenegro (zone `hr-me`, WHE-186)

Date: 2026-11-16. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru instead of Windy).
Zone = `HR.csv` (6 rows) + `ME.csv` (2 rows) = 8 rows. Counts: 8 → 8 rows (free 5 → 5, Pro 2 → 2, archived 1 → 1). No spot added, none archived, none revived.
Past work: one Oct pass (`b47e9f8`, Bol added as Pro; Pakoštane archived, no source). Not redone; re-checked here with fresh sources.

Limits (said plainly): 8 web searches, no page reads beyond search summaries; Chrome used for Windguru only. Pins are unchanged OSM elements or place searches, **not re-checked on satellite**. No official kite text found anywhere, so **no `banned` encoded**. Notes updated; sector column left empty as before.

| Spot | Verdict | Sources | Rules and notes |
|---|---|---|---|
| Viganj (Pelješac) | ok (notes) | [Unplug](https://www.unplug-kitesurf.com/spots/peninsula-peljesac-viganj-croatia) (maestral 15–25 kn, very little launch room); [Surf magazine guide](https://www.surf-magazin.de/en/spots-and-areas/international/croatia/spot-guide-croatia-thermal-spots-in-peljesac-top-area-for-spring/); [Kite Jungle](https://kitejungle.com/kite-places/croatia) (Water Donkey, Maestral club); Windguru: 2 flagged school points (FootLoose, Water Donkey) | Launch space limited, added to notes |
| Neretva delta | ok | [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/neretva-croatia-croatia.html); [Time Out Croatia](https://timeout.com/croatia/news/neretva-delta-attracts-kitesurfers-from-all-over-europe-090523) (learners, maestral to late Sept); [Amico Tours](https://www.manawa.com/en-GB/activity/croatia/dubrovnik/kitesurfing/kitesurfing-excursion-neretva-delta-from-dubrovnik/26371) school since 2006 | Windguru: only a plain "Neretva" forecast point, no kite flag. Not a mismatch: ours is the river-mouth beach |
| Nin – Kraljičina plaža | fixed (notes) | [Unplug Queen beach](https://www.unplug-kitesurf.com/spots/queen-beach-croatia); [IKO Nin](https://www.ikointl.com/it/destinazioni/kitesurfing-croatia/spots/nin) (500 m sand spit used as kite beach); [Surfmania](https://www.kroati.de/kroatien-infos/surfcenter-surfmania-nin.html) (kite centre at Ždrijac beach) | Kite school sits at Ždrijac, the spit, not on Kraljičina itself; our pin is Kraljičina, same water. Windguru: no Nin point found |
| Premantura (Kamenjak) | fixed (notes) | [Unplug Kamenjak/Stupice](https://www.unplug-kitesurf.com/spots/kamenjak-peninsula-stupice-croatia) (NE–SE, shallow, 3 schools); [Surf magazine Istria guide](https://www.surf-magazin.de/en/spots-and-areas/international/croatia/spot-guide-istria-the-best-windsurfing-spots-in-the-north-of-croatia/) (bora, scirocco); [kite guide](https://web.kite-and-windsurfing-guide.com/en/europe/croatia.html) (Stupice launch; Jul/Aug kite ban on the main beach) | Old note said "maestral": sources say jugo and bora. Summer ban is from one guide, no official text: in notes. Windguru: plain "Istria – Premantura" forecast point |
| Bol (Brač) (Pro) | ok (notes) | [Bol tourist board](https://bol.hr/en/do-you-know-what-kitesurfing-is-and-why-you-should-try-it-in-bol/) (no launch on Golden Horn in peak season); [Bol news](https://www.bol.hr/en/news-single/kite-camp-on-a-worlds-famous-beach-zlatni-rat-attracted-hundreds-of-adrenaline-rush-sport-lovers); Unplug, Kite Jungle (schools Yellow Cat, Active Bol) | Kept Pro. Tourist board gives no dates or decree: no `banned`. Windguru: only a windsurf centre flag (Zoo Station), not kite |
| Pakoštane (archived) | stays archived | Searches (IKO, Unplug, Kite Jungle, Surf-store Zadar guide) list Nin and Privlaka, nothing for Pakoštane | No source again, no Windguru point |
| Ada Bojana | ok | [Kiteloop](https://beta.ikointl.com/school/montenegro/ulcinj/kiteloop) (IKO school on Ada Bojana, Jun–Sep); [Live the World](https://livetheworld.com/post/velika-plaza-the-leading-balkan-and-adriatic-kitesurf-destination-y6x2); [A Small World](https://www.asmallworld.com/editorials/articles/kitesurfing-in-ada-bojana) | Windguru: "Ka'banya" flagged kite school, near the river mouth: matched |
| Velika Plaža (Pro) | ok | Live the World ("leading Balkan and Adriatic kite destination"); Kiteloop; Ka'banya | Windguru: "Velika Plaza – KiteRiders" flagged: matched. Pro tier looks too low for a destination spot, but it was set deliberately as the same beach as Ada Bojana |

## Windguru, both ways (browsed as a visitor, 16 Nov, search box by name)

Flagged (school or club) kite markers in the zone: **5**. Matched to ours: **5** (Viganj ×2 → Viganj; Ka'banya → Ada Bojana; KiteRiders → Velika Plaža). Added: 0. Left out: 0 kite markers.
Not kite: Bol "Zoo Station windsurfing centre" (windsurf only). Plain forecast points with no flag, so not counted as kite markers: Neretva, Premantura, Zadar, Peljesac, Brac, Ulcinj, Ulcinj Velika plaža.
Searched: Viganj, Nin, Premantura, Bol, Zadar, Privlaka, Pula, Ploče, Neretva, Montenegro, "Croatia". Not a full map sweep (the map labels are not readable as text; Rab, Krk, Pag and Istria's north were not searched).
Our spots with no Windguru kite marker: Neretva delta, Nin, Premantura, Bol, Pakoštane.

| Windguru marker we don't have | Result |
|---|---|
| none found | Zone not larger than ours on Windguru; gap line: no gap |

Open points (for a second pass, not for Ben): Nin pin (Kraljičina vs the Ždrijac spit where the school is), Premantura Jul/Aug main-beach ban (no official text), Bol peak-season launch rule (no dates).

Build: `spot-check` on `HR.csv` and `ME.csv`, no PROBLEMS. Apple Maps agrees 6 of 7 checked; Neretva delta is `uncertain` (S 185°, 59% water on the claimed side): river-mouth beach on a delta, hint SW kept, same as before. Nin and Premantura were moved to the right shore by the hint, as intended.
