//+------------------------------------------------------------------+
//|                CS_Logger_FX28_v1.23.mq5                          |
//|     Multi-Pair M1 OHLCV Logger für 28 Major/Minor FX-Paare       |
//|     Jede Minute: pro Paar eine Zeile in eine einzige CSV-Datei   |
//+------------------------------------------------------------------+
#property copyright "Lobo-Trader & Nova"
#property link      "https://github.com/Lobo-Trader"
#property version   "1.23"
#property strict

#define EA_VERSION "1.23"

input string CSVPrefix     = "FX_";                  // Dateiname-Prefix
input int    BufferSize    = 1440;                   // Größe des Ringpuffers (Standard: 1440 = 1 Tag M1)
input bool   WriteStatus   = true;                   // Status-Heartbeat-File schreiben?

//== Eindeutige Liste aller 28 Major/Minor FX-Paare (mit + Suffix) ====
string FXPairs[] = {
    "AUDCAD+","AUDCHF+","AUDJPY+","AUDNZD+","AUDUSD+",
    "CADCHF+","CADJPY+",
    "CHFJPY+",
    "EURAUD+","EURCAD+","EURCHF+","EURGBP+","EURJPY+","EURNZD+","EURUSD+",
    "GBPAUD+","GBPCAD+","GBPCHF+","GBPJPY+","GBPNZD+","GBPUSD+",
    "NZDCAD+","NZDCHF+","NZDJPY+","NZDUSD+",
    "USDCAD+","USDCHF+","USDJPY+"
};
string CSVFile;
datetime LastWrittenBar = 0;

//== Initialisierung ====================================================
int OnInit()
{
    CSVFile = CSVPrefix + "M1_v" + EA_VERSION + ".csv";
    WriteHeaderIfNeeded();
    EventSetTimer(60); // Timer auf 60 Sekunden stellen
    return INIT_SUCCEEDED;
}

//== Timer-getriebener Logger (einmal pro Minute) =======================
void OnTimer()
{
    // Hole die Zeit der letzten abgeschlossenen M1-Bar für das erste Paar
    MqlRates rates[];
    if(CopyRates(FXPairs[0], PERIOD_M1, 1, 1, rates) < 1)
        return;

    datetime bar_time = rates[0].time;
    if(bar_time <= LastWrittenBar)
        return; // Keine neue Minute

    LogCurrentMinute(bar_time);
    LastWrittenBar = bar_time;

    if(WriteStatus)
        WriteStatusFile();
}

//== Schreibe für jedes FX-Paar eine Zeile für die aktuelle Minute ======
void LogCurrentMinute(datetime bar_time)
{
    string timestr = TimeToString(bar_time, TIME_DATE|TIME_MINUTES);

    int fileHandle = FileOpen(CSVFile, FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_WRITE, ';');
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Kann Datei nicht öffnen: " + CSVFile);
        return;
    }
    FileSeek(fileHandle, 0, SEEK_END); // Am Ende der Datei schreiben

    for(int i=0; i<ArraySize(FXPairs); i++)
    {
        string pair = FXPairs[i];
        MqlRates rates[];
        // Versuche die M1-Bar für das Pair zu bekommen
        if(CopyRates(pair, PERIOD_M1, bar_time, 1, rates) < 1)
        {
            // Wenn kein Bar, leere Felder in der Zeile
            FileWriteString(fileHandle, StringFormat("%s;%s;;;;;;\n", timestr, pair));
            continue;
        }
        // Schreibe eine vollständige Zeile für das Paar
        FileWriteString(fileHandle, StringFormat("%s;%s;%.5f;%.5f;%.5f;%.5f;%d\n",
            timestr,
            pair,
            rates[0].open,
            rates[0].high,
            rates[0].low,
            rates[0].close,
            rates[0].tick_volume
        ));
    }
    FileClose(fileHandle);
}

//== Schreibe Header falls Datei neu ====================================
void WriteHeaderIfNeeded()
{
    int fileHandle = FileOpen(CSVFile, FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_WRITE, ';');
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Kann Datei nicht öffnen: " + CSVFile);
        return;
    }
    if(FileSize(fileHandle)==0)
    {
        FileWriteString(fileHandle, "timestamp;symbol;open;high;low;close;tick_volume\n");
    }
    FileClose(fileHandle);
}

//== Schreibe Status/Heartbeat ==========================================
void WriteStatusFile()
{
    string statusFile = CSVPrefix + "M1_status_v" + EA_VERSION + ".txt";
    int handle = FileOpen(statusFile, FILE_WRITE|FILE_TXT|FILE_SHARE_WRITE);
    if(handle == INVALID_HANDLE) return;
    FileSeek(handle, 0, SEEK_END);
    FileWrite(handle,
        "EA_Version:",EA_VERSION,
        "LastWrite:",TimeToString(TimeLocal(),TIME_SECONDS)
    );
    FileClose(handle);
}

//== Cleanup ============================================================
void OnDeinit(const int reason)
{
    EventKillTimer();
    if(WriteStatus)
        WriteStatusFile();
}