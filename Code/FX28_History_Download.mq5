//+------------------------------------------------------------------+
//|      FX28_History_Download.mq5                                   |
//|      Lädt rückwirkend M1-Historie für 28 FX-Paare als CSV        |
//+------------------------------------------------------------------+
#property copyright "Lobo-Trader"
#property version   "1.01"
#property strict

input datetime StopDate = D'2024.01.01 00:00'; // Bis zu diesem Datum rückwärts laden
input int      MaxBars  = 200000;              // Maximale Anzahl M1-Balken pro Symbol
input string   CSVPrefix = "FX_History_";      // Prefix für CSV-Dateiname

// Die 28 FX-Paare, inkl. aller Varianten mit +Suffix (z.B. EURUSD+)
string FXPairs[] = {
    "AUDCAD+","AUDCHF+","AUDJPY+","AUDNZD+","AUDUSD+",
    "CADCHF+","CADJPY+",
    "CHFJPY+",
    "EURAUD+","EURCAD+","EURCHF+","EURGBP+","EURJPY+","EURNZD+","EURUSD+",
    "GBPAUD+","GBPCAD+","GBPCHF+","GBPJPY+","GBPNZD+","GBPUSD+",
    "NZDCAD+","NZDCHF+","NZDJPY+","NZDUSD+",
    "USDCAD+","USDCHF+","USDJPY+"
};

int OnInit()
{
    string today = TimeToString(TimeCurrent(), TIME_DATE);
    string csvName = CSVPrefix + StringReplace(today, ".", "") + ".csv";

    int file = FileOpen(csvName, FILE_WRITE|FILE_CSV|FILE_SHARE_WRITE, ';');
    if (file == INVALID_HANDLE)
    {
        Print("Kann CSV nicht öffnen: ", csvName);
        return INIT_FAILED;
    }

    // Header schreiben
    FileWriteString(file, "timestamp;symbol;open;high;low;close;tick_volume\n");

    for (int i = 0; i < ArraySize(FXPairs); i++)
    {
        string sym = FXPairs[i];
        MqlRates rates[];
        int bars = CopyRates(sym, PERIOD_M1, 0, MaxBars, rates);
        if (bars <= 0)
        {
            Print("Keine Daten für ", sym);
            continue;
        }
        ArraySetAsSeries(rates, true);
        for (int j = 0; j < bars; j++)
        {
            if (rates[j].time < StopDate) break; // Stop-Kriterium erreicht
            string line = StringFormat("%s;%s;%.5f;%.5f;%.5f;%.5f;%d\n",
                TimeToString(rates[j].time, TIME_DATE|TIME_MINUTES),
                sym,
                rates[j].open,
                rates[j].high,
                rates[j].low,
                rates[j].close,
                rates[j].tick_volume
            );
            FileWriteString(file, line);
        }
        Print("Historie geladen für: ", sym, " (", bars, " Bars)");
    }
    FileClose(file);
    Print("Download abgeschlossen: ", csvName);
    EventKillTimer();
    ExpertRemove(); // EA automatisch entfernen
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
    // Nichts nötig
}