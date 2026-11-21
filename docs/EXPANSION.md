# Countries after Europe and Morocco

21 Nov 2026, Lead. Pick-up point for growing past Europe and Morocco. The work itself lives on the board, one card per country.

## How I ranked them

WhereToKite answers "where do I drive today?". So it is worth most where many riders **live** and have several spots within a drive. A holiday spot with one beach and a school (Mui Ne, Kalpitiya, Boracay, Cabarete) needs no ranking. I scored each country on:

1. **Riders who live there.** The US, Brazil and Australia come up again and again as the countries where kiting is most popular. One market report counts about 110,000 active kiters in the US (an estimate, no primary source).
2. **Several famous spots within a drive.** Text from Windy/Windguru-style guides and travel lists: Cumbuco and Jericoacoara, Cape Town and Langebaan, La Ventana, Hurghada and El Gouna, Tarifa, Dakhla, Essaouira.
3. **What it costs us.** Store language, forecast models outside Météo-France's area, the map data pipeline.

## Ranking

| # | Country | Why | Language |
|---|---|---|---|
| 1 | United States | Largest rider base. Many drive-to regions: Outer Banks NC, Florida, Texas Gulf, SF Bay and Sherman Island, Columbia Gorge, Hawaii | English (done) |
| 2 | Brazil | 2nd market. Ceará coast (Cumbuco, Taíba, Jeri) and the south (Santa Catarina, Rio, Lagoa dos Patos) | Portuguese (needs pt-BR) |
| 3 | Australia | 3rd market. Perth, Melbourne/Geelong, Sydney, Queensland, Adelaide | English |
| 4 | South Africa | Cape Town riders plus winter travellers from Europe: Bloubergstrand, Langebaan, Witsand | English |
| 5 | Egypt | Red Sea, Europe's winter trip: El Gouna, Hurghada, Safaga, Soma Bay, Ras Sudr, Dahab | English |
| 6 | Mexico | La Ventana / Baja, plus Yucatán | Spanish (done) |

Later, holiday spots with one beach where a ranking adds little: Dominican Republic, Vietnam, Sri Lanka, Philippines, Cape Verde, Mauritius, Zanzibar, Caribbean islands.

## What must happen first

- **The app and engine stop at Europe and Morocco.** That covers the out-of-coverage message, the continent check, and the bounding box the catalogue pipeline searches (`tools/build_spots.py`, the kite-object query). It's a Product card.
- **Forecast models.** The blend leans on Météo-France (Europe only). Elsewhere, ECMWF + GFS (+ ICON), and the confidence cut-offs need re-testing against stations. It's a Forecast accuracy card.
- **Store.** The app has to be available in each country's App Store, with pt-BR for Brazil.

Sources: [Red Bull, best places to kitesurf](https://www.redbull.com/int-en/best-places-to-kitesurf), [National Geographic](https://www.nationalgeographic.com/adventure/article/kiteboarding-best-spots-world), [windy.app list](https://windy.app/blog/best-spots-for-kitesurfing-in-the-world.html), [Xola kite stats](https://www.xola.com/articles/kite-surfing-statistics-overview-trends/), [GearJunkie](https://gearjunkie.com/boats-water/best-kiteboarding-locations).
