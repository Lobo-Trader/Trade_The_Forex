# CSI-Matrix: Strategie, Aufbau und Erweiterungen

## Überblick

Für die Entwicklung eines robusten CSI-Frameworks (Currency Strength Index) ist eine flexible, erweiterbare Matrix-Struktur das Herzstück. Diese Matrix bildet für jeden Zeitstempel alle relevanten Werte, Zwischenergebnisse und Meta-Informationen ab. Sie wächst mit jedem Berechnungsschritt und kann für Strategie, Visualisierung und Entscheidungsfindung genutzt werden.

---

## 1. Grundstruktur der CSI-Matrix

- **Zeilen:** Zeitstempel (`timestamp`) – typischerweise im Minutenraster.
- **Spalten:** Für jedes der 28 FX-Paare mehrere berechnete Felder (siehe unten).

### Beispiel (Ausschnitt):

| timestamp           | AUDCAD_close | AUDCAD_TV | AUDCAD_change | AUDCAD_change_pct | AUDCAD_change_weighted | ... | EURUSD_close | EURUSD_TV | ... |
|---------------------|--------------|-----------|---------------|-------------------|------------------------|-----|--------------|-----------|-----|
| 2025-07-14 10:00    | 0.89827      | 91        |       –       |        –          |        –               | ... |   ...        | ...       | ... |
| 2025-07-14 10:01    | 0.89828      | 61        |   0.00001     |      0.0011%      |   0.00061              | ... |   ...        | ...       | ... |
| ...                 | ...          | ...       |   ...         |    ...            |    ...                 | ... |   ...        | ...       | ... |

---

## 2. Spalten je FX-Paar

Für **jedes FX-Paar** (z.B. AUDCAD):

- `<Pair>_close`             → Schlusskurs der Minute
- `<Pair>_TV`                → Tick-Volumen (TV) der Minute
- `<Pair>_change`            → Absolute Preisveränderung (`close[t] - close[t-1]`)
- `<Pair>_change_pct`        → Relative Preisveränderung (`(close[t] - close[t-1]) / close[t-1]`)
- `<Pair>_change_weighted`   → Gewichtete Veränderung (`change * TV`)
- `<Pair>_lowTVflag`         → Bool-Flag: TV unter Schwelle? (True/False)
- `<Pair>_warning`           → Optionaler Text für Spezialfälle (z.B. "No Trade", "Lücke", "Ausreißer")

---

## 3. CSI-Spalten & Meta-Informationen

- **CSI-Spalten:**  
  - `CSI_AUD`, `CSI_CAD`, ..., `CSI_USD` (je eine pro Währung)
  - Diese werden aus den gewichteten Veränderungen der passenden Paare berechnet.

- **Ranking/Sortierung:**  
  - `CSI_rank1` ... `CSI_rank8` (z.B. stärkste → schwächste Währung im aktuellen Zeitfenster)
  - Optional: `CSI_AUD_rank` (Platz von AUD im aktuellen Ranking)

- **FX-spezifische Parameter:**  
  - Pro Währung oder Paar können individuelle Schwellenwerte in Nebenstrukturen gepflegt werden (z.B. Mindest-TV, Mindest-Spread, etc.).

---

## 4. Flags & Steuermechanismen

**Warum Flags?**
- Warnen vor "Fake"-Signalen bei illiquiden Paaren.
- Erlauben flexible Filter für unterschiedliche Handelsstrategien.
- Ermöglichen dynamische Ausschlüsse (z.B. bestimmte Paare/Währungen im Tagesverlauf oder bei Events).

**Beispiel-FLAG:**
```python
df['AUDCAD_lowTVflag'] = df['AUDCAD_TV'] < 40  # Schwelle als Beispiel
df['AUDCAD_warning'] = df['AUDCAD_lowTVflag'].apply(lambda x: "No Trade (low TV)" if x else "")
```

---

## 5. Erweiterbarkeit & Empfehlung

- Die Matrix bleibt immer **zweidimensional** (Zeit × Spalten).
- Neue Spalten können jederzeit ergänzt werden.
- Am Ende stehen alle nötigen Informationen für Analyse, Strategie, Visualisierung und automatische Trade-Entscheidungen in einer einzigen DataFrame/CSV.
- Rankings, Sortierungen und Flags erhöhen die Transparenz und Qualität der Entscheidungsfindung erheblich.

---

## 6. Visualisierung der Matrix-Struktur (Schema)

```
timestamp | FX1_close | FX1_TV | FX1_change | FX1_change_pct | FX1_change_weighted | FX1_lowTVflag | ... | FX28_close | FX28_TV | ... | CSI_AUD | ... | CSI_rank1 | ... | Warnungen/Flags | ...
```

---

## 7. Weiterführende Gedanken

- **FX-spezifische Parameter** ermöglichen es, für jede Währung/Paar individuelle Regeln zu definieren (ähnlich wie beim ACS28).
- Die CSI-Matrix kann als "Single Source of Truth" für alle weiteren Analysen, Filter und Strategien genutzt werden.
- Flags und Zusatzspalten machen das System robust gegen fehlerhafte oder unvollständige Daten.

---

**Stand: 2025-07-24**
