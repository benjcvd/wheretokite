# Release 1.2: upload and submit

Build **1.2 (1)**, archived on 21 Nov from main. It adds the weather-model work (WHE-238, 239, 231, 242, 243) on top of 1.1 build 3.

## 1. Upload (5 min)

1. Xcode → **Window → Organizer** → WhereToKite **1.2 (1)** → **Distribute App** → **App Store Connect** → Upload.
2. Wait for the "processing complete" email from Apple (10–30 min).

## 2. Create the version (5 min)

1. App Store Connect → WhereToKite → **+ Version** → `1.2`. (If 1.1 is still waiting for review, you can instead remove it from review, then submit 1.2: Apple only reviews one version at a time.)
2. Under **Build**, pick 1.2 (1).
3. Paste **What's New** below, once per language (language menu at the top right).
4. Everything else carries over. Screenshots can stay for now.
5. **Add for Review** → **Submit**. Pick automatic release if you want it live as soon as Apple approves it.

## What's New

### English (U.S.)

```
Know when the forecasts disagree.
• The wind check now uses the same weather models as the forecast, so the grade and the chart tell the same story.
• When the models disagree, the spot page says so ("Models disagree: 11–19 kn") and the chart shows their low–high band.
• Hour by hour: a ≠ sign marks the hours where the models disagree on direction. Tap it to see each model's wind, in red when one says offshore.
• The spot map shows one arrow per model when they disagree, each one labelled.
• If one model says offshore, the hour is judged on that: safety first.
• "No go" now says why: storm, ban, darkness, offshore, unsure direction, tide.
• Direction reads plainly: onshore, side-shore, offshore.
```

### French (France)

```
Sache quand les prévisions divergent.
• Le contrôle du vent utilise maintenant les mêmes modèles météo que la prévision : la note et le graphique disent la même chose.
• Quand les modèles divergent, la page du spot le dit (« Les modèles divergent : 11–19 nds ») et le graphique montre leur fourchette.
• Heure par heure : un signe ≠ marque les heures où les modèles divergent sur la direction. Touche-le pour voir le vent de chaque modèle, en rouge quand l'un d'eux annonce de l'offshore.
• La carte du spot montre une flèche par modèle quand ils divergent, chacune avec son nom.
• Si un modèle annonce de l'offshore, l'heure est jugée là-dessus : la sécurité d'abord.
• « No go » dit maintenant pourquoi : orage, interdiction, nuit, offshore, direction incertaine, marée.
• La direction se lit simplement : onshore, side-shore, offshore.
```

### Spanish (Spain)

```
Sabe cuándo las previsiones no coinciden.
• La comprobación del viento usa ahora los mismos modelos meteorológicos que la previsión: la nota y el gráfico cuentan lo mismo.
• Cuando los modelos no coinciden, la página del spot lo dice («Los modelos no coinciden: 11–19 nudos») y el gráfico muestra su horquilla.
• Hora a hora: un signo ≠ marca las horas en que los modelos no coinciden en la dirección. Tócalo para ver el viento de cada modelo, en rojo cuando uno da offshore.
• El mapa del spot muestra una flecha por modelo cuando no coinciden, cada una con su nombre.
• Si un modelo da offshore, la hora se juzga por ese: la seguridad primero.
• «No go» dice ahora por qué: tormenta, prohibición, noche, offshore, dirección incierta, marea.
• La dirección se lee fácil: onshore, side-shore, offshore.
```
