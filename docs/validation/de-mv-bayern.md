# Validation: Rügen, Mecklenburg Baltic and Bavarian lakes (zone `de-mv-bayern`, WHE-178)

Date: 2026-11-14. Method: [Windguru variant](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov).
Past work: `DE.csv` had a famous-spots cut (2c1557a), Prerow added in WHE-91; `TO_CONFIRM.md` (NL/BE/DE) lists open pin questions.

Limits (said plainly): 16 spots, 11 web searches, so this is a **notes pass, not a full row-by-row recheck**. Pins stay on the OSM elements already in the CSV; not eyeballed on satellite. No official kite-zone text (Rostock, Zingst, Landratsamt Rosenheim, Zweckverband Brombachsee) was found for any spot, so no `banned` rule was added. Spot guides used: [visit-mv.com kite list](https://www.visit-mv.com/surf/kite/1) (regional tourism board, lists schools and spots), unplug, kite-and-windsurfing-guide, kiteforum.

## Our 16 spots

| Spot | Verdict | Sources and notes |
|---|---|---|
| Salzhaff – Pepelow | fixed (notes) | School on the campsite ([visit-mv](https://www.visit-mv.com/destinations/a-kitesurfing-school-pepelow), [VDWS](https://www.vdws.de/en/watersport-center/kitesurfschule-pepelow)); [unplug](https://www.unplug-kitesurf.com/spots/pepelow-germany): flat, SW–N, free access. |
| Warnemünde | fixed (notes) | [kiteforum](https://se.kiteforum.com/kitesurf/spot/warnemuende), [unplug](https://www.unplug-kitesurf.com/spots/warnemuende-germany): access 13. [ostsee.de](https://www.ostsee.de/warnemuende/strand.php) lists blocks 12–13 for wind and kite sports (and recommends 12). Summer swim zone with buoys. |
| Wustrow | ok | Baltic side waves, Bodden side flat; Wustrow Surf Center ([visit-mv](https://www.visit-mv.com/surf/kite/3)). Not re-read in detail. |
| Zingst | ok | [kitejungle](https://kitejungle.com/kite-places/germany/zingst): sports beach between piers 6 and 16, choppy; [off-to-mv](https://off-to-mv.com/destinations/a-surfspot-zingst). No official kite-zone text. |
| Rügen – Suhrendorf (Ummanz) | ok | [Surf Magazin](https://www.surf-magazin.de/en/spots-and-areas/baltic-sea/germany-s-largest-standing-area-ummanz-on-ruegen-the-up-and-coming-windsurfing-spot-of-the-month/): Germany's largest standing area, kite zone; one source says experts only because of land obstacles. DeafVentures school listed. |
| Rügen – Dranske | ok | Rügen Piraten school on the spot; W–NE winds (visit-mv, kite guide). Kreptitz (kite school, but kiting prohibited at the spot per one listing) not added. |
| Usedom – Karlshagen | ok | Surf and kite school at Zeltplatzstraße ([visit-mv](https://www.visit-mv.com/destinations/a-surf-and-kitesurf-school-usedom)). |
| Saal (Saaler Bodden) | fixed (notes) | Kitesportschule Simon on site, free access, SW/NW best ([visit-mv](https://www.visit-mv.com/surf/kite/3), [unplug](https://www.unplug-kitesurf.com/spots/saaler-bodden-born-germany)). |
| Rügen – Wiek | ok | Surf and kite camp, parking and rigging area ([kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/wiek-ruegen-ruegen-germany.html)). E winds are gusty. |
| Gahlkow | fixed (notes) | [vorpommern.de](https://www.vorpommern.de/en/destinations/details/stamm/show/surfspot-galkow/), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/gahlkow-usedom-greifswalder-bodden-germany.html): W–E, shallow 800 m, no school (nearest at Loissin). One-ish source for a school, Pro kept. |
| Usedom – Peenemünde | ok | Free access, few bathers, N–SE (visit-mv listing). One source only; Pro. |
| Usedom – Ückeritz | ok | Windsport Usedom school ([listing](https://www.werkenntdenbesten.de/e/53279991/segelschule/ueckeritz-usedom/windsport-usedom-segel-surf-und-kiteschule-bewertungen.html)), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ueckeritz-usedom-usedom-greifswalder-bodden-germany.html). |
| Prerow | ok | Kiteschule Darss ([visit-mv](https://www.visit-mv.com/destinations/a-kiteschool-darss)). Checked in WHE-91. |
| Chiemsee – Übersee (Feldwies) | ok | [Chiemgau tourism](https://chiemsee-chiemgau.info/en/kiting-amp-surfing) names the Feldwieser Bucht as the kite spot; [kiteforum](https://se.kiteforum.com/kitesurf/spot/chiemsee___feldwies): experts, ships. No official zone text found; "marked zone" wording stays from the earlier pass. |
| Chiemsee – Chieming | question | Nothing new found this time (the tourism page doesn't mention it). Kept Pro as before; KBC kite club source is from the old pass. |
| Brombachsee | ok | [VDWS Surf- und Kiteschule Brombachsee](https://vdws.de/en/watersport-center/brombachsee-surf-und-kiteschule) (May–October); [unplug](https://www.unplug-kitesurf.com/spots/brombachsee-allmannsdorf-germany): W wind, flat and chop. Landkreis boating rules ban surfing in protected zones; no kite-specific text. |

Build check (`spot-check` on `DE.csv`, 14 Nov): no PROBLEMS; all 51 DE spots agree with Apple Maps.

## Windguru, both ways (browsed as a visitor, 14 Nov)

Windguru has no kite tag on its Baltic map: every marker is a town forecast point (Prerow, Zingst, Saal, Usedom-Karlshagen, Rügen-Altefähr, Dranske, Wiek, Rambin...). Search for "Germany kite" returned only Holnis (Schleswig-Holstein, other zone). In Bavaria it has a flagged Chiemsee "Feldwieser Bucht" point and station.

- Kite-tagged Windguru markers in the zone: 1 (Feldwieser Bucht). Matched to ours: 1. Added: 0. Left out: 0.
- Town points that coincide with ours (not counted as kite markers): Prerow, Zingst, Saal, Karlshagen, Dranske, Wiek, Warnemünde area.
- Ours not on Windguru as a kite point: 15 of 16 (only Übersee/Feldwies).
- No gap line needed: Windguru shows fewer kite spots than we have.

| Windguru marker | Result |
|---|---|
| Chiemsee – Feldwieser Bucht | ours (Chiemsee – Übersee) |

Candidates seen in the guides but not added, no Windguru marker, so the unrated rule is not triggered: Born (Kitesurf & Kanu Born, Saaler Bodden, 6 km from Saal), Dierhagen (LOOP IN school, same water as Saal), Loissin (kitesafe school, 1 km from Gahlkow), Kreptitz (kiting prohibited), Boiensdorf (south Salzhaff, 12 km from Pepelow). Born and Boiensdorf are the ones to add if Ben wants more Baltic Pro spots.
