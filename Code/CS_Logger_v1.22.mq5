//+------------------------------------------------------------------+
//|                CS_Logger_v1.22.mq5                               |
//|   Multi-Pair M1 OHLCV Logger für FX- und Crypto-Paare            |
//|   Jede Minute: jede Zeile = 1 Pair, 1 Bar                        |
//|   CSV wächst minütlich, Header wird nur bei neuer Datei geschrieben|
//+------------------------------------------------------------------+
#property copyright "Lobo-Trader & Nova"
#property link      "https://github.com/Lobo-Trader"
#property version   "1.22"
#property strict

#define EA_VERSION "1.22"

input string BasisWaehrung = "AUD";                   // (AUD,CAD,CHF,EUR,GBP,JPY,NZD,USD)
input string CSVPrefix     = "Matrix_";               // Dateiname-Prefix
input int    BufferSize    = 1440;                    // Größe des Ringpuffers (Standard: 1440 = 1 Tag M1)
input bool   WriteStatus   = true;                    // Status-Heartbeat-File schreiben?

//== Paare je Basiswährung ==============================================
string AUDPairs[] = {"AUDCAD+","AUDCHF+","AUDJPY+","AUDNZD+","AUDUSD+","EURAUD+","GBPAUD+"};
string CADPairs[] = {"AUDCAD+","CADCHF+","CADJPY+","EURCAD+","GBPCAD+","NZDCAD+","USDCAD+"};
string CHFPairs[] = {"AUDCHF+","CADCHF+","CHFJPY+","EURCHF+","GBPCHF+","NZDCHF+","USDCHF+"};
string EURPairs[] = {"EURAUD+","EURCAD+","EURCHF+","EURGBP+","EURJPY+","EURNZD+","EURUSD+"};
string GBPPairs[] = {"GBPAUD+","GBPCAD+","GBPCHF+","GBPJPY+","GBPNZD+","GBPUSD+","EURGBP+"};
string JPYPairs[] = {"AUDJPY+","CADJPY+","CHFJPY+","EURJPY+","GBPJPY+","NZDJPY+","USDJPY+"};
string NZDPairs[] = {"AUDNZD+","EURNZD+","GBPNZD+","NZDCAD+","NZDCHF+","NZDJPY+","NZDUSD+"};
string USDPairs[] = {"AUDUSD+","EURUSD+","GBPUSD+","NZDUSD+","USDCAD+","USDCHF+","USDJPY+"};

string EA_Pairs[];
string CSVFile;
datetime LastWrittenBar = 0;

//== Initialisierung ====================================================
int OnInit()
{
    SetPairs();
    CSVFile = CSVPrefix + BasisWaehrung + "_M1_v" + EA_VERSION + ".csv";
    WriteHeaderIfNeeded();
    EventSetTimer(60); // Timer auf 60 Sekunden stellen
    return INIT_SUCCEEDED;
}

//== Timer-getriebener Logger (einmal pro Minute) =======================
void OnTimer()
{
    // Hole die Zeit der letzten abgeschlossenen M1-Bar für das erste Paar
    MqlRates rates[];
    if(CopyRates(EA_Pairs[0], PERIOD_M1, 1, 1, rates) < 1)
        return;

    datetime bar_time = rates[0].time;
    if(bar_time <= LastWrittenBar)
        return; // Keine neue Minute

    LogCurrentMinute(bar_time);
    LastWrittenBar = bar_time;

    if(WriteStatus)
        WriteStatusFile();
}

//== Schreibe für jedes Pair eine Zeile für die aktuelle Minute =========
void LogCurrentMinute(datetime bar_time)
{
    string timestr = TimeToString(bar_time, TIME_DATE|TIME_MINUTES);

    int fileHandle = FileOpen(CSVFile, FILE_WRITE|FILE_READ|FILE_CSV|FILE_SHARE_WRITE, ';');
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Kann Datei nicht öffnen: " + CSVFile);
        return;
    }
    FileSeek(fileHandle, 0, SEEK_END); // Am Ende der Datei schreiben

    for(int i=0; i<ArraySize(EA_Pairs); i++)
    {
        string pair = EA_Pairs[i];
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
    string statusFile = CSVPrefix + BasisWaehrung + "_status_v" + EA_VERSION + ".txt";
    int handle = FileOpen(statusFile, FILE_WRITE|FILE_TXT|FILE_SHARE_WRITE);
    if(handle == INVALID_HANDLE) return;
    FileSeek(handle, 0, SEEK_END);
    FileWrite(handle,
        "EA_Version:",EA_VERSION,
        "LastWrite:",TimeToString(TimeLocal(),TIME_SECONDS)
    );
    FileClose(handle);
}

//== Setze relevante Paare für die Basiswährung =========================
void SetPairs()
{
    if(BasisWaehrung=="AUD")      { ArrayResize(EA_Pairs, ArraySize(AUDPairs));   ArrayCopy(EA_Pairs, AUDPairs); }
    else if(BasisWaehrung=="CAD") { ArrayResize(EA_Pairs, ArraySize(CADPairs));   ArrayCopy(EA_Pairs, CADPairs); }
    else if(BasisWaehrung=="CHF") { ArrayResize(EA_Pairs, ArraySize(CHFPairs));   ArrayCopy(EA_Pairs, CHFPairs); }
    else if(BasisWaehrung=="EUR") { ArrayResize(EA_Pairs, ArraySize(EURPairs));   ArrayCopy(EA_Pairs, EURPairs); }
    else if(BasisWaehrung=="GBP") { ArrayResize(EA_Pairs, ArraySize(GBPPairs));   ArrayCopy(EA_Pairs, GBPPairs); }
    else if(BasisWaehrung=="JPY") { ArrayResize(EA_Pairs, ArraySize(JPYPairs));   ArrayCopy(EA_Pairs, JPYPairs); }
    else if(BasisWaehrung=="NZD") { ArrayResize(EA_Pairs, ArraySize(NZDPairs));   ArrayCopy(EA_Pairs, NZDPairs); }
    else if(BasisWaehrung=="USD") { ArrayResize(EA_Pairs, ArraySize(USDPairs));   ArrayCopy(EA_Pairs, USDPairs); }
    else
    {
        Print("Unbekannte Basiswährung: ", BasisWaehrung);
        ExpertRemove();
    }
}

//== Cleanup ============================================================
void OnDeinit(const int reason)
{
    EventKillTimer();
    if(WriteStatus)
        WriteStatusFile();
}