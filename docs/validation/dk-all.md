# Validation: Denmark (zone `dk-all`, WHE-184)

Date: 2026-11-15. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru instead of Windy).
Zone = all rows of `DK.csv` (`dk.csv`).
Counts: 14 → 15 rows. Free 10 → 8, Pro 3 → 6, archived 1 → 1 (Sønderby and Hejlsminde moved to Pro on weak sources; Bjert Strand added as Pro).
Past work: the CSV header says "not web-verified, general knowledge"; no earlier pass and no Denmark lines in `TO_CONFIRM.md`.

Limits of this pass (said plainly): 9 web searches, one Windguru session. Pins are the unchanged OSM elements, **not re-checked on satellite**.
No official kite text found for any spot except the Fanø kite-area guide, so **no `banned` encoded**. The sector column stays empty, as before.

| Spot | Verdict | Sources | Rules and notes |
|---|---|---|---|
| Løkken | fixed (notes) | [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/lokken-northern-jutland-denmark.html); [Kiteforum](https://se.kiteforum.com/kitesurf/spot/l_kken); [Surf magazine](https://www.surf-magazin.de/reisen/daenemark/daenemark-spot-guide-nordjuetland) (SW, gentle beach) | No school found; no ban found |
| Klitmøller | ok | [Thy National Park, surf and sail](https://eng.nationalparkthy.dk/plan-your-trip/active-in-nature/surf-and-sail); [Kite and windsurfing guide, Thy](https://kite-and-windsurfing-guide.com/en/continents/countries/regions/thy--limfjord); Visit Denmark Cold Hawaii pages | Wave spot, experienced riders |
| Krik Vig | fixed (notes) | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/krik_vig); [Unplug](https://www.unplug-kitesurf.com/spots/krik-vig-denmark); [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/krig-vig-northern-jutland-denmark.html) | Bird-habitat B-area off limits, A-area open all year (guides, not an official text) |
| Hvide Sande | ok | [Westwind school](https://westwind.dk/en/pages/lokationer/hvide-sande-syd); [Visit Vesterhavet kitesurfing](https://www.visitvesterhavet.com/northsea/enjoying-nature/kitesurfing/kitesurfing-north-sea); [KiteWorldWide camp](https://kiteworldwide.com/kite-camps/kite-camp-hvide-sande-denmark/) | Two sides kept as before; Kiteforum notes windsurfers on the north side |
| Bork Havn | ok | [Westwind Bork Havn](https://en.westwind.dk/shop/westwind-bork-havn-22227p.html) (lessons on the beach); [Kitejungle Denmark](https://kitejungle.com/kite-places/denmark); Visit Denmark Bork Havn page | Shallow inner bay, best SW to W |
| Fanø – Rindby | fixed (notes) | [Visit Denmark, kitesurf spot Rindby](https://www.visitdenmark.com/denmark/plan-your-trip/kitesurf-spot-on-rindby-beach-fano-gdk1125027); [Vadehavskysten kite spot sheet (PDF)](https://api.www.vadehavskysten.dk/sites/vadehavskysten.com/files/2021-06/kitesurf%20spot%20skema%20Fan%C3%B8.pdf) | Kite area 2 km south of Rindby, marked by poles; east Fanø protected, no kiting. Tide window unchanged (not checked) |
| Rømø – Lakolk | ok (notes) | [Kiteforum, Rømø](https://se.kiteforum.com/kitesurf/spot/r_m____surf_beach); [Kiteschool Pro Rømø (IKO)](https://www.ikointl.com/it/centro/d%25C3%25A4nemark/kiteschool-pro-romo); [Visit Denmark, Lakolk](https://www.visitdenmark.com/denmark/plan-your-trip/lakolk-beach-romo-gdk611011) | Signposted kite zone, stay inside it |
| Sønderby | fixed (Pro) | Only the [Juelsminde guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/juelsminde-eastern-jutland-denmark.html) (nearby, launch south of the marina); no source names Sønderby | One weak source: Pro. Pin is a hamlet node; its position on the water is unchecked |
| Hejlsminde | fixed (Pro) | [Visit Denmark, Hejlsminde harbour](https://www.visitdenmark.com/denmark/plan-your-trip/windsurfing-and-sup-spot-watersports-location-at-hejlsminde-harbor-near-kolding-gdk1110800) (windsurf and SUP, kiters outside the Blue Flag area) | No kite-specific source: Pro |
| Amager Strandpark | fixed (notes) | [Unplug](https://www.unplug-kitesurf.com/spots/amager-strandpark-denmark) (E to SE); [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/amager-strand-park-sjaelland-denmark.html) (southern end) | Sources disagree on wind (Windy.app page says SW); kept to the two kite guides |
| Nørre Vorupør (Pro), Agger Tange (Pro), Rømø – Sønderstrand (Pro) | ok, unchanged | see Klitmøller, Krik Vig, Lakolk | Not re-checked individually |
| Sjællands Odde (archived) | stays archived | [Visit Denmark, Tengslemark beach](https://www.visitdenmark.com/denmark/plan-your-trip/tengslemark-beach-gdk757698) lists kiting as possible; one source | |
| Bjert Strand (Pro, added) | added | [Visit Denmark, kite spot at Bjert Strand/Moshuse](https://www.visitdenmark.com/denmark/plan-your-trip/kite-spot-at-bjert-strandmoshuse-near-kolding-popular-spot-for-kitesurfers-gdk1110836) | SE to S wind, deep water quickly. Pinned on the OSM beach access node |

## Windguru, both ways (browsed as a visitor, 15 Nov)

Windguru's Denmark map shows plain forecast points with no kite tag at the zoom I used: Løkken, Bulbjerg, Nørre Vorupør, Oddesund, Henne Strand, Juelsminde, Bonnerup Strand, Grenaa, Anholt, Læsø, Samsø and others, plus unexpanded clusters (west coast 6 and 4, Thy 5, Zealand). I searched "Klitmøller" (found) and opened the Thy cluster. **Kite-flagged markers counted: 0; I did not sweep the whole coast**, and clusters around Hvide Sande, Rømø and Zealand were not expanded.

| Windguru point | Ours |
|---|---|
| Løkken, Nørre Vorupør, Klitmøller, Juelsminde | ours (as forecast points) |
| Bulbjerg, Oddesund, Henne Strand, Bonnerup Strand, Grenaa, Læsø, Samsø, Anholt | left out: forecast points, no kite tag, and I found no local kite source in this pass |

Gap: none shown by Windguru, but Denmark has many more kite spots than our 14 (Unplug lists 141; kite-jungle and Visit Denmark pages for Blokhus, Oddesund, Bjert, Udsholt, Feddet, Lynæs, Rågeleje, Læsø Stokken). A second pass is worth a card: Blokhus, Oddesund, Rågeleje, Udsholt, Feddet and Læsø have local kite pages and were not added here.
