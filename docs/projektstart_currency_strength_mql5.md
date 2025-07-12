# Projektstart: Currency Strength Handelssystem (MQL5, ECN Broker)

---

## 1. Recherche: Kostenlose/Open-Source Currency-Strength-Lösungen

### A) MQL5 (MetaTrader 5)
- **MQL5 Codebase:**
    - Viele gratis Indikatoren und Utilities zum Thema Currency Strength, z.B.:
        - [Currency Strength Meter (MQL5 Codebase)](https://www.mql5.com/en/code/11085)
        - [Currency Power Meter (MQL5 Codebase)](https://www.mql5.com/en/code/21167)
        - Suche im [MQL5 Market nach "Currency Strength"](https://www.mql5.com/en/market/mt5/indicator/search?query=currency+strength) – einige kostenlos, viele kostenpflichtig.
    - **Foren:**
        - Viele Diskussionen, Code-Schnipsel und Scripts im [MQL5-Forum](https://www.mql5.com/en/forum) und bei [ForexFactory](https://www.forexfactory.com/).

### B) TradingView (Pine Script)
- **Public Library:**
    - Sehr viele frei verfügbare „Currency Strength Meter“-Skripte, Code oft direkt kopierbar.
    - Beispiele: [TradingView Currency Strength Scripts](https://www.tradingview.com/scripts/currencystrength/)
    - Ideal für mathematische Modelle und Inspiration.

### C) GitHub / Python
- **Python Libraries:**
    - Diverse Open-Source-Projekte, z.B.:
        - [Currency-Strength-Index auf GitHub](https://github.com/topics/currency-strength)
        - [forex-python](https://github.com/MicroPyramid/forex-python) (für FX-Daten, kein fertiger Meter)
    - Nützlich zur Datenbeschaffung, Backtest & Research.

### D) Sonstige Quellen
- **FXSSI, Quantum Trading, Currency Heatwave, etc.:**
    - Viele als Demo oder Freeware – meist Visualisierung, selten Quellcode.
- **YouTube Tutorials:**
    - Viele Anleitungen zur eigenen Erstellung von Currency Strength Indikatoren in MQL5/MT4.

**Fazit Recherche:**  
Für MQL5 gibt es einige kostenlose Indikatoren mit Quellcode, die als Basis oder Inspiration dienen können. Besonders hilfreich: MQL5-Codebase und TradingView.

---

## 2. Vorschlag: Projektstruktur (modular & skalierbar)

Wir orientieren uns an Software-Patterns und deinen Subprojekten:

```
FXCurrencyStrength/
│
├── data/
│   ├── fetcher/                # Scripte/Module zur Datenbeschaffung (Echtzeit & Historisch)
│   ├── pairs_list.mqh          # Liste & Mapping aller zu verarbeitenden FX-Paare
│   └── dataset_builder.mqh     # Aufbereitung und Strukturierung der Rohdaten
│
├── core/
│   ├── calculator.mqh          # Mathematische Berechnung der Currency Strength
│   ├── weighting.mqh           # Gewichtung, z.B. Tick-Volumen, Anpassungen
│   └── signal_engine.mqh       # Logik zur Generierung von Handelssignalen
│
├── indicators/
│   ├── currency_strength.mq5   # Haupt-Indikator (Visualisierung im Chart)
│   ├── sub_indicators.mq5      # Zusätzliche Indikatoren (Histogramme, Heatmaps, etc.)
│   └── signal_marker.mq5       # Visualisierung von Entry/Exit-Signalen
│
├── ea/
│   ├── trade_manager.mq5       # EA-Modul zur Automatisierung (später)
│   └── risk_management.mq5     # Money/Risk Management Logik
│
├── utils/
│   ├── logger.mqh              # Logging für Debugging und Backtests
│   ├── config.mqh              # Zentrale Konfigurationsdatei (Währungen, Paare, Parameter)
│   └── helper.mqh              # Hilfsfunktionen
│
├── test/
│   ├── backtest_data/          # Testdatensätze für Backtests
│   └── test_cases.mq5          # Unit- und Integrationstests (soweit in MQL5 möglich)
│
├── docs/
│   ├── README.md               # Projektbeschreibung, Anleitung
│   └── methodik.md             # Detaillierte Methodik und mathematische Herleitung
│
└── main_project.mq5            # Hauptdatei für die MQL5-IDE (zum Kompilieren/Laden)
```

---

### Empfohlene Reihenfolge für die Entwicklung:

1. **Datenbeschaffung & Datenstruktur** (data/)
2. **Berechnung & Gewichtung** (core/)
3. **Visualisierung im Chart** (indicators/)
4. **Signallogik & Backtesting** (core/signal_engine + test/)
5. **EA/Automatisierung** (ea/)
6. **Dokumentation & Tests** (docs/, test/)

---

**Nächster Schritt:**  
- Wähle das Start-Modul: Datenbeschaffung, Calculator, Visualisierung, etc.
- Ich suche gezielt nach frei verfügbarem Beispielcode für das gewählte Modul und bereite ein passendes Template vor.