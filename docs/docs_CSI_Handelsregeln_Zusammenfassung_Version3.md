# Currency Strength Index (CSI) – Diskussionszusammenfassung: Handelsregeln, Variablen & Optimierung

**Stand:** 2025-07-23  
**Autor:** Nova & Wolfgang  
**Kontext:** Erweiterung um Supply/Demand-Zonen (SZ/DZ) als dritte Analysekomponente

---

## 1. Kernprinzipien des CSI-Tradings

(siehe bisherige Punkte...)

---

## 2. Neue Komponente: Supply- und Demand-Zonen (SZ/DZ)

### A) Was sind Supply- und Demand-Zonen?

- **Supply Zone (Angebotszone, SZ):**  
  Preisbereiche, in denen in der Vergangenheit eine starke Verkaufswelle begann (“Angebot übersteigt Nachfrage”).
- **Demand Zone (Nachfragezone, DZ):**  
  Preisbereiche, in denen in der Vergangenheit eine starke Kaufwelle begann (“Nachfrage übersteigt Angebot”).

### B) Ziel der Integration

- **SZ/DZ als Pivot-Levels:**  
  Diese Zonen dienen als Entscheidungspunkte. Erst, wenn der Preis in die Nähe dieser Zonen kommt, wird überhaupt ein Setup in Erwägung gezogen.
- **Kombination mit CSI & Volumen:**  
  Sobald der Preis eine SZ oder DZ erreicht, wird per CSI und ggf. Volumenanalyse geprüft, ob das Setup (Einstieg) getriggert wird.

---

## 3. Algo/Logik zur Erkennung & Visualisierung von SZ/DZ

### A) Zeiteinheiten

- Zonen werden auf **H1, H4 und D1** automatisch erkannt und verwaltet.

### B) Erkennung Supply/Demand-Zonen (vereinfachter Algorithmus)

1. **Fraktale und starke Bewegungen erkennen:**
   - Identifiziere Preisbereiche, an denen ein starker, impulsiver Move (z.B. große Candle oder mehrere in Folge) begann.
2. **Zonen definieren:**
   - Die Zone beginnt am Hoch (SZ) bzw. Tief (DZ) vor der Bewegung und reicht bis zum Ausbruchspunkt.
   - Optional: Nur berücksichtigen, wenn das Volumen in der Zone signifikant war.
3. **Nächste Zone zum aktuellen Preis bestimmen:**
   - Suche für jede Timeframe die nächstgelegene SZ (oberhalb) und DZ (unterhalb) zum aktuellen Preis.

### C) Visualisierung & Alarm

- **Zonen im Chart als Rechtecke markieren (je nach TF farblich unterschiedlich).**
- **Alarm, wenn Preis in eine (parametrisierbare) Nähe zur Zone kommt** (z.B. 10 Pips).
- **Info-Panel:** Zeigt immer die Distanz zur nächsten SZ/DZ auf allen überwachten TFs.

---

## 4. Kombinationslogik: Einstiegsszenario

1. **Preis nähert sich SZ oder DZ (Alarm).**
2. **Prüfe CSI:**
   - Ist die gegenläufige Währung stark/schwach genug? Divergiert der CSI passend zur Zone?
   - Optional: Prüfe MarketForce/Volumen.
3. **Entry-Trigger:**
   - Entry nur, wenn CSI/MarketForce das Szenario bestätigen (z.B. im Demand-Bereich: Zielwährung wird auf CSI stark, Gegenspieler schwach).
   - Optional: Bestätigungs-Candle, Engulfing o.ä.

---

## 5. Variablen & Parameter

| Variable               | Bedeutung                                         |
|------------------------|--------------------------------------------------|
| SZ/DZ_Level            | Preisbereich der erkannten Zone                  |
| SZ/DZ_TF               | Timeframe der Zone                               |
| Dist_To_SZ/DZ          | Abstand zum aktuellen Preis (in Pips)            |
| SZ/DZ_Alarm_Threshold  | Schwelle für Alarm-Auslösung (in Pips)           |
| CSI_XYZ                | siehe oben                                       |
| MarketForce_XYZ        | siehe oben                                       |

---

## 6. Beispiel-Workflow (Pseudocode)

```python
for tf in [H1, H4, D1]:
    sz_list, dz_list = detect_supply_demand_zones(tf)
    next_sz = get_next_zone_above_price(sz_list, current_price)
    next_dz = get_next_zone_below_price(dz_list, current_price)
    if dist_to(next_sz, current_price) < SZ_Alarm_Threshold:
        trigger_alarm("Supply Zone", tf)
    if dist_to(next_dz, current_price) < DZ_Alarm_Threshold:
        trigger_alarm("Demand Zone", tf)

# Kombinations-Entry
if price_in_demand_zone and CSI_confirms_long and MarketForce_confirms_long:
    entry_long()
if price_in_supply_zone and CSI_confirms_short and MarketForce_confirms_short:
    entry_short()
```

---

## 7. ToDo für Umsetzung in MQL5 und Python

- Supply/Demand-Zonen-Detection (per Fraktale, Candle-Pattern oder Volumenimpuls)
- Visualisierung als Rechtecke im Chart
- Alarm- und Info-Panel
- Kombinationslogik mit CSI und MarketForce
- Parameter: Alarmabstand, Mindestimpuls, Mindestvolumen, etc.

---

**Ergebnis:**  
Mit dieser dritten Komponente wird das System robuster:  
SZ/DZ als objektive Pivots, CSI/MarketForce für Timing und Trendrichtung.

---

**Fragen oder Wünsche zur praktischen Umsetzung? → Einfach melden!**