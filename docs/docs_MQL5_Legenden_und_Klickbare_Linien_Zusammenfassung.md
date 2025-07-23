# MQL5: Klickbare Legenden und Linien im Chart  
**Projekt:** [Lobo-Trader/Trade_The_Forex](https://github.com/Lobo-Trader/Trade_The_Forex)  
**Thema:** Umsetzung klickbarer Legenden und dynamischer Linien im MT5-Chart  
**Status:** Getestetes Demobeispiel, einsatzbereit  
**Letzter Stand:** 2025-07-23

---

## 1. Zielsetzung

- **Interaktive Legende:** Anzeige von Labels (z.B. EUR, USD, JPY) oben links im Chart.
- **Klickbare Auswahl:** Beim Klick auf ein Label wird eine Aktion im Chart ausgeführt (z.B. Hervorhebung einer Linie oder Zeichnen einer Linie).
- **Nur eine Linie gleichzeitig:** Es soll immer nur eine (senkrechte) Linie im Chart erscheinen, die sich farblich dem gewählten Label anpasst.
- **Robuste Event-Steuerung:** Keine doppelten Linien, keine „Absätze“ oder Fehler im Chart/Journaleintrag.

---

## 2. Lessons Learned & Stolpersteine

- **OBJ_LABEL**-Objekte können per Mausklick angesprochen werden, solange sie `OBJPROP_SELECTABLE=true` besitzen.
- Das Event-Handling erfolgt über `OnChartEvent` und das Event `CHARTEVENT_OBJECT_CLICK`.
- In MQL5 gibt es KEIN `CHART_EVENT_OBJECT_CLICK` für `ChartSetInteger`!  
  Das einzige relevante Event-Flag ist `CHART_EVENT_MOUSE_MOVE`, das für die meisten Interaktionen ausreicht.
- **Nur eine Linie:**  
  Vor jedem Zeichnen wird die alte Linie per `ObjectDelete()` entfernt, damit es keine Überlagerungen gibt.
- **Buffers:** Auch bei reinen Chart-Indikatoren mit Objekten muss ein Dummy-Buffer gesetzt werden, sonst gibt es Compilerwarnungen.

---

## 3. Beispiel: Minimaler, robuster Code

```mql5 name=CurrencyStrengthLegend_V2.02.mq5
//+------------------------------------------------------------------+
//| CurrencyStrengthLegend_V2.02.mq5                                 |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_plots 1
#property indicator_label1  "dummy"
#property indicator_type1   DRAW_NONE

input int N_CURRENCIES = 3;
string currencies[] = {"EUR", "USD", "JPY"};
color  currColors[]  = {clrBlue, clrRed, clrGreen};

double dummyBuffer[];
string current_vline_name = "currency_vline";
int selected = -1;

int OnInit()
  {
   SetIndexBuffer(0, dummyBuffer, INDICATOR_DATA);

   for(int i=0;i<N_CURRENCIES;i++)
     {
      string lname="label_"+currencies[i];
      ObjectCreate(0, lname, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, lname, OBJPROP_XDISTANCE, 40+i*50);
      ObjectSetInteger(0, lname, OBJPROP_YDISTANCE, 20);
      ObjectSetString(0, lname, OBJPROP_TEXT, currencies[i]);
      ObjectSetInteger(0, lname, OBJPROP_COLOR, currColors[i]);
      ObjectSetInteger(0, lname, OBJPROP_FONTSIZE, 12);
      ObjectSetInteger(0, lname, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, lname, OBJPROP_SELECTED, false);
      ObjectSetInteger(0, lname, OBJPROP_BACK, false);
     }
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true); // nur dieses Event setzen
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   for(int i=0;i<N_CURRENCIES;i++)
      ObjectDelete(0,"label_"+currencies[i]);
   ObjectDelete(0, current_vline_name);
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      for(int i=0;i<N_CURRENCIES;i++)
         if(sparam=="label_"+currencies[i])
           {
            selected = i;
            Print("Label geklickt: ", currencies[i]);
            DrawVLine();
            break;
           }
     }
  }

void DrawVLine()
  {
   ObjectDelete(0, current_vline_name);

   // Die VLINE an die Mitte des sichtbaren Zeitraums setzen
   long window_first=0,window_visible=0;
   ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR, 0, window_first);
   ChartGetInteger(0, CHART_VISIBLE_BARS, 0, window_visible);
   int bar_index = (int)(window_first - (window_visible/2));
   if(bar_index < 0) bar_index = 0;
   datetime t = iTime(_Symbol, _Period, bar_index);

   ObjectCreate(0, current_vline_name, OBJ_VLINE, 0, t, 0);
   ObjectSetInteger(0, current_vline_name, OBJPROP_COLOR, currColors[selected]);
   ObjectSetInteger(0, current_vline_name, OBJPROP_WIDTH, 4);
   ObjectSetInteger(0, current_vline_name, OBJPROP_BACK, false);
   Print("VLINE gezeichnet für: ", currencies[selected], " an Zeit: ", TimeToString(t));
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }
```

---

## 4. Hinweise für die Praxis

- Die Linie wird nach Klick auf ein Label immer **in der Mitte des sichtbaren Bereichs** gezeichnet.
- **Nur eine Linie ist sichtbar** – keine „Absätze“ oder überlappende Objekte.
- Die Farbe der Linie passt sich dem gewählten Label an (EUR=blau, USD=rot, JPY=grün).
- Bei Bedarf kann die Liniendicke, Farbe, Position und das Event-Handling leicht angepasst werden.
- Journal-Ausgaben (`Print()`) sind nur zu Debug-Zwecken nötig und können entfernt werden.

---

## 5. Weiterführende Ideen

- **Cursor-Position als Liniensetzer:** Statt feste Mitte kann die Linie auch dorthin gesetzt werden, wo der Nutzer klickt.
- **Mehrfachauswahl:** Es können mehrere Linien/Objekte/Plots per Klick steuerbar gemacht werden.
- **Echte Daten:** Die Labels können mit echten Currency-Strength-Buffern und dynamischen Daten verknüpft werden.
- **GUI-Elemente:** MQL5 erlaubt noch mehr Interaktivität, wie Buttons, Eingabefelder, usw.

---

**Autor:** Nova (KI) & Wolfgang  
**Letztes Update:** 2025-07-23

---