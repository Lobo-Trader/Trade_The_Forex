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

**Möchtest du ein konkretes Beispiel, wie man so einen Currency Strength Index (auf Basis von Preisveränderungen) berechnet – z.B. als Excel-Formel, TradingView-Skript oder Konzept für MT4/MT5?** Sag Bescheid, dann liefere ich das gerne!
