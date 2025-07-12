### Wechselbeziehung zwischen den verschiedenen FX-Pairs und die Messung der Währungsstärke

**Frage:**  
Ich glaube, dass es eine Wechselbeziehung zwischen den verschiedenen FX Pairs geben muss und überlege, wie ich diese beschreiben soll, besser als nur zu sagen: "wenn eines hoch geht, geht das andere runter". Und außerdem sind es ja immer mehrere FX Pairs, die betroffen sind ... wenn ich den USD beschreiben will, dann muss ich die 8 Hauptwährungen betrachten, oder?

---

**Antwort:**

Ganz genau! Deine Überlegungen sind sehr treffend und berühren einen Kernaspekt der Marktmechanik im Devisenhandel. Hier ein strukturierter Überblick zu deinen Punkten:

---

#### 1. Wechselbeziehung zwischen FX-Pairs

Im FX-Markt handelt man immer **Währungspaare** (z.B. EUR/USD). Wenn ein Paar steigt, fällt das Gegenstück entsprechend – aber:  
**Es gibt eine Wechselwirkung zwischen ALLEN Paaren, die eine gemeinsame Währung beinhalten.**

**Beispiel: USD**
- Wenn der USD „stark“ ist, sollte er tendenziell in mehreren USD-Paaren steigen (z.B. USDJPY, USDCAD, USDCHF) und in USD-als-Quote-Paaren fallen (z.B. EURUSD, GBPUSD).
- Die Bewegungen in den einzelnen Paaren beeinflussen sich gegenseitig, denn Arbitrage sorgt dafür, dass Preisunterschiede zwischen den Paaren ausgeglichen werden.

---

#### 2. Betrachtung der Hauptwährungen

Es gibt die sogenannten **„Majors“** (Hauptwährungen):  
- USD, EUR, JPY, GBP, CHF, AUD, CAD, NZD

Wenn du die Stärke einer Währung (z.B. USD) messen willst, solltest du ihre Performance gegen die anderen 7 Hauptwährungen analysieren, also:
- EURUSD, GBPUSD, USDJPY, USDCHF, AUDUSD, NZDUSD, USDCAD

(Du kannst auch „Crosses“ wie EURJPY, GBPJPY betrachten, wenn du JPY analysieren willst.)

---

#### 3. Stärkemaß (Currency Strength/Weakness)

Viele professionelle Indikatoren und Tools berechnen eine **relative Währungsstärke** so:
- **Vergleiche die Preisveränderung** der jeweiligen Währung in ALLEN Paaren, in denen sie enthalten ist, gegen die anderen Hauptwährungen über ein bestimmtes Zeitfenster.
- **Summiere diese Veränderungen** (z.B. in Prozent oder Pips) auf.  
- **Optional:** Normalisiere sie, um Verzerrungen zu vermeiden (z.B. unterschiedliche Volatilität der Paare).

**Ergebnis:**  
- Du bekommst einen Wert für die aktuelle Stärke/Schwäche der analysierten Währung im „Korb“ der Hauptwährungen.

---

#### 4. Mathematischer Ansatz

Eine häufige Formel für einen „Currency Strength Index“ (CSI):

\[
\text{CSI}_{USD} = \sum_{i=1}^{n} \text{relative Veränderung von } USD \text{ gegenüber Währung } i
\]
wobei \( n \) die Zahl der Vergleichswährungen ist.

Man kann das auf verschiedene Arten ausrechnen (z.B. prozentualer Kursgewinn/Verlust, prozentuale Veränderung seit Tagesbeginn, usw.).

---

#### 5. Fazit & Empfehlung

- **Ja, du musst alle Hauptwährungen einbeziehen,** um die „wirkliche“ Bewegung einer Währung wie USD zu beurteilen.
- Ein einzelnes Paar reicht NICHT aus, da Bewegung oft von der Gegenseite (z.B. EUR im EURUSD) getrieben sein kann.
- **Wechselwirkungen und Korrelationen** zwischen den Paaren sind entscheidend.

---
---
# Methoden zur Berechnung von Currency-Strength-Indikatoren

Professionelle Currency-Strength-Indikatoren und -Berechnungen können unterschiedlich aufgebaut sein – je nachdem, was du messen willst und welche Daten dir zur Verfügung stehen:

---

## 1. Nur Kursschwankung (Preisveränderung)

- Die klassische Berechnung des Currency Strength Index (CSI) betrachtet nur die **Kursveränderungen** (z.B. prozentuale Veränderung vom Open zum Close in einem Zeitfenster) über mehrere Paare.
- **Vorteil:** Einfach, überall berechenbar.
- **Nachteil:** Sagt nichts über die „Qualität“ der Bewegung (z.B. ob viel oder wenig Marktteilnehmer beteiligt waren).

---

## 2. Mit Tick-Volumen (Preisveränderung gewichtet mit Aktivität)

- Viele fortgeschrittene und professionelle Tools beziehen auch **Tick-Volumen** (oder, wenn verfügbar, echtes Volumen) mit ein.
- **Warum?**
    - Wenn ein Kursanstieg von viel Tick-Volumen begleitet wird, ist das ein Zeichen für echtes Marktinteresse und somit „echte“ Stärke.
    - Steigt der Kurs nur mit wenigen Ticks, kann das ein „dünner“, wenig liquider Markt sein.
- **Wie?**
    - Man kann z.B. **Preisveränderung × Tick-Volumen** berechnen (quasi „gewichtete Kursveränderung“).
    - Oder **Preisveränderung pro Tick**, wie du vorhin gefragt hast.

---

## 3. Empfehlung in der Praxis

### Nur Kursschwankung:
- Schnell, einfach, überall berechenbar (auch in Excel, TradingView PineScript, MT4/MT5).
- Gibt gute Hinweise auf relative Währungsstärke, aber manchmal „Fehlsignale“ bei dünnem Markt.

### Mit Tick-Volumen:
- Aussagekräftiger, weil du die Aktivität berücksichtigst.
- Besonders nützlich in Seitwärtsphasen oder bei Ausbrüchen.
- In MT4/MT5 immer nur Tick-Volumen verfügbar, im Futures-Bereich echtes Handelsvolumen.

---

## Fazit

- **Optimale Methode:** Preisveränderung UND Tick-Volumen zu berücksichtigen.
- Aber auch nur die Preisveränderung kann für viele Setups ausreichen, wenn du die Limitierungen im Hinterkopf hast.

---
---

 # Wie wird der „Currency Strength“-Gedanke tatsächlich gehandelt?

---

## 1. Handelssignale aus Currency Strength/Weakness

- **Relative Stärken und Schwächen identifizieren:**  
  Du nutzt Currency-Strength-Indikatoren, um zu erkennen, welche Währung aktuell stark ist (z.B. USD) und welche schwach (z.B. JPY).
- **Pairs bilden:**  
  Du kombinierst die stärkste mit der schwächsten Währung (z.B. USD/JPY long, wenn USD stark und JPY schwach).
- **Signal:**  
  Ein Handelssignal entsteht, wenn eine Währung im Vergleich zu vielen anderen gleichzeitig Stärke oder Schwäche zeigt — nicht nur in einem einzelnen Paar.

---

## 2. Einstieg und Ausstieg

- **Einstieg:**  
  Sobald eine klare Divergenz sichtbar wird (z.B. USD baut Stärke gegen mehrere Währungen auf), setzt du auf das entsprechende Paar, bevorzugt das mit der größten Bewegung/Volatilität.
- **Ausstieg:**  
  Entweder nach Ziel-Pip, nach Umkehr der Stärke/Schwäche, oder nach Zeit (Ende Session).

---

## 3. Zeitfenster und Zeiteinheit

Du kannst Currency Strength auf allen Zeiteinheiten einsetzen:
- **Intraday/Scalping:** Minutencharts, Fokus auf schnelle Reaktionen.
- **Swing/Positionstrading:** Stunden-/Tagescharts, größere Trends.

---

## 4. Kombination mit anderen Tools

- Viele Trader kombinieren Currency Strength mit klassischen Charttechniken (z.B. Unterstützungen, Widerstände) und Price Action.
- Auch Momentum-/Volumen-Indikatoren werden oft zusätzlich genutzt.

---

## 5. Beispiel-Workflow

1. **Scannen:** Welches ist die stärkste und welches die schwächste Währung im Moment? (z.B. AUD am stärksten, JPY am schwächsten)
2. **Setup:** AUDJPY long, weil AUD Stärke zeigt und JPY Schwäche.
3. **Bestätigung:** Gibt es einen Ausbruch, ein Pullback, eine Kerzenformation, die das Signal bestätigt?
4. **Trade:** Einstieg, Stopp-Loss unter dem letzten Tief, Take-Profit nach CRV oder nach Currency-Strength-Umkehr.

---

## Wichtig

Currency Strength ist ein „Meta“-Indikator – er zeigt, wo Kapitalströme im FX-Markt langlaufen, und hilft, Paare mit dem größten Trendpotenzial zu finden.  
**Entscheidend ist, das Signal im Kontext des Marktes und mit weiteren Tools zu bestätigen.** 

---
---

# Gibt es fertige Handelssysteme für Currency Strength?

Ja, es gibt bereits zahlreiche fertige Handelssysteme, Indikatoren und Tools zum Thema **Currency Strength/Weakness (Währungsstärke)** – sowohl als Kauf-, Miet- als auch als Freeware-Lösungen. Hier ein Überblick:

---

## 1. Freeware / Open Source

### a) TradingView (PineScript)
- Viele kostenlose „Currency Strength Meter“-Indikatoren in der öffentlichen TradingView-Bibliothek.
- Suche nach:
    - „Currency Strength Meter“
    - „Forex Strength“
- Beispiel:  
    - [https://www.tradingview.com/scripts/currencystrength/](https://www.tradingview.com/scripts/currencystrength/)
- Oft auch mit Quellcode, den du anpassen kannst!

### b) MetaTrader 4/5 (MT4/MT5)
- Im MQL5-Marketplace und in Foren (z.B. mql5.com, ForexFactory) gibt es kostenlose Indikatoren und teilweise Handelssysteme rund um Currency Strength.
- Suche nach:
    - „Currency Strength Meter“
    - „Currency Power Indicator“
    - „Currency Strength EA“ (Expert Advisor = Handelssystem)
- Viele Indikatoren zeigen Stärke/Schwäche, manche können auch automatisch handeln.

### c) GitHub / Open Source
- Es gibt diverse Python- und MQL-Projekte zur Berechnung von Currency Strength auf GitHub (z.B. für Backtesting, Visualisierung, Signalgenerierung).

---

## 2. Kommerzielle Produkte (Kauf/Miete)

### a) MT4/MT5
- Im MQL5-Market gibt es viele kostenpflichtige Currency Strength Indikatoren und EAs (Expert Advisors), z.B.:
    - „Advanced Currency Strength28 Indicator“ (um die $60–120)
    - „Currency Strength Meter Pro“ (ähnliche Preisklasse)
- Sie bieten oft zusätzliche Features wie Alarme, Visualisierung und eigene Handelslogik.

### b) TradingView / Forex-Tools
- Einzelne Anbieter verkaufen Premium-Versionen von Currency Strength Indikatoren mit mehr Features.

### c) Drittanbieter-Plattformen / Software
- Tools wie FXSSI, Quantum Trading, Currency Heatwave, Currency Strength Board, usw. bieten Lösungen als Desktop-App, Web-App, Plugin oder Indikator (meist kostenpflichtig).

---

## 3. Fazit und Empfehlungen

- **Für Einsteiger und Tester:**  
    Die Freeware-Indikatoren auf TradingView und MT4/MT5 sind ein super Startpunkt.  
    → Sie reichen oft aus, um die Idee praktisch zu testen!
- **Für Automatisierung (Auto-Trading):**  
    Du findest auf MT4/MT5 auch fertige EAs, die nach Currency Strength handeln, teilweise auch kostenlos.
- **Für Individualisierung:**  
    Mit ein wenig Programmierkenntnis kannst du Open-Source-Projekte anpassen.
