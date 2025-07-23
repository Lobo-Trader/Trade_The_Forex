# Currency Strength Index (CSI) – Diskussionszusammenfassung: Handelsregeln, Variablen & Optimierung

**Stand:** 2025-07-23  
**Autor:** Nova & Wolfgang  
**Kontext:** Diskussion und Analyse verschiedener Ansätze zur Nutzung des Currency Strength Index (CSI) im Trading, basierend auf Visualisierungen, Regelideen, Volumenintegration sowie quantitativer und qualitativer Interpretation.

---

## 1. Kernprinzipien des CSI-Tradings

- **CSI** quantifiziert die relative Stärke/Schwäche jeder Währung aus allen Forex-Paaren.
- Basissignale entstehen durch: Abstand zur Nulllinie, Kreuzungen, Steigungen, Extrembereiche und Divergenzverhalten.
- Multi-Timeframe-Ansicht erhöht die Robustheit.
- Tickvolumen kann als Qualitäts- und Momentumfilter dienen.

---

## 2. Diskutierte Handelsregeln & Interpretationen

### A) Trend- & Momentum-Strategien

- **Steigung als Momentumfilter:**  
  Je steiler der Verlauf einer CSI-Linie, desto stärker die aktuelle Bewegung (Impuls).
  - _Regel:_ Wenn Steigung(CSI_A) > Schwelle UND Steigung(CSI_B) < -Schwelle → Trendfolge A gegen B.

- **Divergenz (Auseinanderstreben):**  
  Wenn zwei CSI-Linien nahe beieinander sind und dann stark & steil auseinanderstreben (ohne Kreuzung!), ist das meist ein stärkeres Signal als eine flache Kreuzung.
  - _Regel:_ Wenn |CSI_A - CSI_B| am Balken t-1 klein UND am Balken t groß, bei starker Steigung → Entry.
  - **Optional:** Nur, wenn Tickvolumen signifikant erhöht ist.

### B) Kreuzungsstrategien

- **Kreuzung als Trendwechsel:**  
  Wenn CSI_A die CSI_B kreuzt, ist das ein Gleichstand der relativen Stärke – oft genutzt als Trendwechsel-Signal, besonders in Verbindung mit Momentum.
  - _Regel:_ Wenn CSI_A kreuzt CSI_B von unten nach oben UND Steigung(CSI_A) > Schwelle → Long A/B.

- **Position der Kreuzung wichtig:**  
  - _Im Neutralbereich (0/50%):_ Meist Trendbeginn.
  - _In Extremzonen (z.B. >80/<20 oder Fibbo ±162):_ Mögliche Reversal- oder Übertreibungssignale; höhere Fehlsignalgefahr.

### C) Extrembereiche & Range/Trend-Erkennung

- **Abstand zur Nulllinie/Extremzonen:**  
  - CSI > 80 / < 20 (oder z.B. Fibo ±162): Übertreibung/Überkauft/Überverkauft.
  - _Regel:_ Wenn CSI_A > 80 und Steigung dreht nach unten → Short A.
  - _Regel:_ Wenn CSI_A < 20 und Steigung dreht nach oben → Long A.

- **Range vs. Trend:**  
  - Standardabweichung aller CSI-Linien klein → Range (kein Trade).
  - Standardabweichung groß → Trend (Signale erlaubt).

### D) Multi-Timeframe (MTF) Filter

- **Signale nur handeln, wenn auf mehreren Zeiteinheiten gleichgerichtetes Momentum/Konstellation vorliegt.**
  - _Regel:_ Einstieg nur, wenn Signal auf M5 & H1 gleichsinnig.

### E) Tickvolumen als Filter/Feature

- **Hohe Moves nur dann relevant, wenn sie von hohem Volumen begleitet sind.**
  - _Regel:_ Signal nur, wenn Tickvolumen > Durchschnitt.
  - **Optional:** CSI-Berechnung gewichten: WeightedChange = Change * Tickvolumen.

---

## 3. Wichtige Variablen & Parameter zur Quantifizierung

| Variable                 | Bedeutung                                                      | Beispiel/Typ          |
|--------------------------|---------------------------------------------------------------|-----------------------|
| CSI_X                    | CSI-Wert einer Währung X                                      | float                 |
| Steigung(CSI_X)          | Momentane Steigung (ΔCSI/Δt)                                  | float                 |
| Abstand_AB               | |CSI_A - CSI_B|, Abstand zwischen zwei CSIs                   | float                 |
| Kreuzung(CSI_A, CSI_B)   | Zeitpunkt, wenn CSI_A == CSI_B                                | bool (0/1)            |
| Kreuzungsbereich         | Wertbereich der Kreuzung (z.B. neutral, extrem)               | float/category        |
| Tickvolumen              | Tickvolumen im jeweiligen Zeitintervall                       | int/float             |
| Durchschnitt_Tickvol     | Durchschnittliches Tickvolumen (z.B. gleitend)                | float                 |
| Standardabweichung_CSI   | Streuung aller CSI-Werte                                      | float                 |
| MultiTF_Signal           | MTF-Logik: gleichsinnige Signale auf mehreren TFs             | bool (0/1)            |

**Parameter für Schwellenwerte (für Optimierung):**
- Schwelle_Steigung (z.B. 40 Grad oder ΔCSI/t > 0.2)
- Schwelle_Abstand_klein (z.B. 10)
- Schwelle_Abstand_groß (z.B. 30)
- Bereich_Neutral (z.B. ±20 um 0)
- Bereich_Extrem (z.B. >80/<20 oder ±162 Fibo)
- Volumenfaktor (z.B. 1.1 × Durchschnitt)

---

## 4. Beispiele für messbare Regeln (Pseudocode)

```python
# Momentum-Divergenz-Signal
if abs(CSI_A[t-1] - CSI_B[t-1]) < X and \
   abs(CSI_A[t] - CSI_B[t]) > Y and \
   SLOPE(CSI_A) > Z and SLOPE(CSI_B) < -Z and \
   Tickvolumen[t] > Durchschnitt_Tickvol:
    # Starkes Entry-Signal
    entry_long(A), entry_short(B)

# Kreuzungssignal im Neutralbereich
if CSI_A[t-1] < CSI_B[t-1] and CSI_A[t] > CSI_B[t] and \
   abs(CSI_A[t]) < Neutralbereich and \
   SLOPE(CSI_A) > Z:
    # Trendbeginn Signal
    entry_long(A), entry_short(B)

# Extremzonen-Reversal
if CSI_A[t-1] > Extremzone and SLOPE(CSI_A)[t-1] > 0 and SLOPE(CSI_A)[t] < 0:
    # Reversal Short
    entry_short(A)
```

---

## 5. Optimierungsansätze & Feature Engineering

- **Alle Schwellenwerte und Bereiche als Parameter für Backtesting und ML-Optimierung definieren.**
- **Features für ML:**
  - Abstand, Steigung, Kreuzungsstatus, Kreuzungsbereich, Standardabweichung, Tickvolumen, MTF-Status, CSI-Extremstatus etc.
- **Ziel:**  
  - Die Kombination aus Feature-Engineering (z.B. Divergenz + Momentum + Volumen) erlaubt robuste, automatisierbare Signale und spätere Optimierung im Backtest/ML.

---

## 6. ToDo für Umsetzung in MQL5 und Python

- CSI-Berechnung (ggf. mit Volumen)
- Messbare Features/Parameter pro Balken berechnen
- Signal-Logik als Funktionsblock
- Parameter als Inputs für Optimierung bereitstellen
- Multi-TF-Integration
- Visualisierung (z.B. Heatmap für Divergenz + Momentum)

---

**Fragen, Ergänzungen oder Wünsche für Codebeispiele? → Einfach melden!**