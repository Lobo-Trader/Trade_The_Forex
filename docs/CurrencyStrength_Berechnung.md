# Berechnung der Currency Strength aus Forex-Paaren

## 1. Grundprinzip: Was ist „Currency Strength“?

- **Ziel:**  
  Jede einzelne Währung erhält einen Indexwert, der ihre relative Stärke oder Schwäche im Vergleich zu den anderen Majors (AUD, CAD, CHF, EUR, GBP, JPY, NZD, USD) anzeigt.  
  Dieser Wert wird typischerweise auf Basis der Kursentwicklung aller Paare, in denen die jeweilige Währung vorkommt, berechnet – beispielsweise jede Minute neu.

- **Herausforderung:**  
  Wechselkurse existieren immer als Paare (z.B. EURUSD, AUDNZD) – daher gibt es keine „absolute“ Währungsstärke.  
  Die Stärke einer Währung wird stattdessen aus der Entwicklung ALLER Paare, in denen sie enthalten ist, abgeleitet.

---

## 2. Schritt-für-Schritt-Berechnung

### a) Prozentuale Kursveränderungen berechnen

Für jedes Währungspaar (z.B. EURUSD) wird pro Periode die prozentuale Preisänderung berechnet:

```
Change_EURUSD = (Close_jetzt - Close_vorher) / Close_vorher * 100
```

Das erfolgt für alle 28 relevanten Paare.

---

### b) Mapping auf Einzelwährungen

Jedes Paar besteht aus zwei Währungen: **Basis** und **Quote** (z.B. EUR/USD: Basis = EUR, Quote = USD).

- Die Kursveränderung eines Paares ist **positiv für die Basiswährung** und **negativ für die Quotewährung**.

**Beispiele:**

- Steigt EURUSD um +0,1 % → EUR wird stärker, USD schwächer.
- Fällt EURUSD um −0,2 % → EUR wird schwächer, USD stärker.

---

### c) Aggregation pro Währung (Summierung)

Für jede Währung werden die Kursveränderungen aller Paare, in denen sie enthalten ist, aufsummiert:

```
CSI_X = (1/N) * Summe über alle Paare mit X:
    +Change_Pair   (wenn X Basiswährung)
    -Change_Pair   (wenn X Quotewährung)
```

- **N** = Anzahl der Paare, in denen die Währung X vorkommt (meist 7).

**Beispiel für EUR:**

- EURUSD: EUR ist Basis → +Change
- EURJPY: EUR ist Basis → +Change
- EURGBP: EUR ist Basis → +Change
- EURNZD: EUR ist Basis → +Change
- EURAUD: EUR ist Basis → +Change
- EURCHF: EUR ist Basis → +Change
- EURCAD: EUR ist Basis → +Change

**Beispiel für USD:**

- USDJPY: USD ist Basis → +Change
- USDCHF: USD ist Basis → +Change
- USDCAD: USD ist Basis → +Change
- AUDUSD: USD ist Quote → -Change
- EURUSD: USD ist Quote → -Change
- GBPUSD: USD ist Quote → -Change
- NZDUSD: USD ist Quote → -Change

---

### d) (Optional) Volumen- oder Gewichtung

Die Kursveränderungen können zusätzlich mit dem Tick-Volumen der jeweiligen Periode gewichtet werden, um „wichtigere“ Moves stärker zu berücksichtigen:

```
WeightedChange = Change * Volumen
```

---

### e) Normalisierung

Um die CSI-Werte vergleichbar zu halten, werden sie häufig auf einen neutralen Wert (z.B. 0) normiert oder durch statistische Methoden skaliert (z.B. Z-Score über ein Zeitfenster).

---

## 3. Beispiel-Pseudocode (Python-Style)

```python
CSI = {w: 0 for w in ["AUD", "CAD", "CHF", "EUR", "GBP", "JPY", "NZD", "USD"]}
counts = {w: 0 for w in CSI}

for pair in all_pairs:  # z.B. "EURUSD"
    change = (close_now - close_prev) / close_prev * 100
    base, quote = pair[:3], pair[3:]
    CSI[base] += change
    CSI[quote] -= change
    counts[base] += 1
    counts[quote] += 1

for w in CSI:
    CSI[w] /= counts[w]  # Durchschnitt pro Währung
```

---

## Zusammenfassung

- Für jede Zeiteinheit (z.B. Minute) werden die prozentualen Kursveränderungen aller 28 Paare berechnet.
- Für jede Währung werden die Veränderungen, je nach Rolle als Basis/Quote, aufsummiert.
- Daraus ergibt sich ein objektiver Currency Strength Index je Währung, der beliebig weiterverarbeitet werden kann (Trading, Visualisierung, etc.).
