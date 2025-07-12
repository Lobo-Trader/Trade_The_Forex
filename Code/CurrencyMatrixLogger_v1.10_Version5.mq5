//+------------------------------------------------------------------+
//|                CurrencyMatrixLogger_v1.10.mq5                    |
//|   Multi-Pair M1 OHLCV Logger für Basiswährung                    |
//|   Schreibt CSV pro Basiswährung und EA-Revision im /Files-Verz.  |
//|   Enthält robustes Error- und Status-Logging, Backfill, Append   |
//|   Nur ein EA pro Chart/Basiswährung nötig                        |
//+------------------------------------------------------------------+
#property copyright "Lobo-Trader & Nova"
#property link      "https://github.com/Lobo-Trader"
#property version   "1.10"
#property strict

#define EA_VERSION "1.10"

//== Benutzer-Einstellungen ==============================================
input string BasisWaehrung = "AUD";                   // Chart-Basiswährung (AUD, EUR, CHF, GBP, USD, NZD, CAD, JPY)
input string CSVPrefix     = "Matrix_";               // Dateiname-Prefix
input bool   DoBackfill    = true;                    // Historien-Backfill beim Start?
input int    BackfillDays  = 365;                     // Tage an Historie (max. abhängig von Broker!)
input int    MaxBarsLive   = 10000;                   // Maximal zu loggende Bars im Livebetrieb (0 = unbegrenzt)
input int    LogIntervalMs = 3000;                    // Logger-Intervall in ms (Schreibzyklus)
input bool   UseSpread     = true;                    // Spread loggen?
input bool   UseBidAsk     = true;                    // Bid/Ask loggen?
input bool   WriteStatus   = true;                    // Status-Heartbeat-File schreiben?

//== Paare je Basiswährung ==============================================
string AUDPairs[] = {"AUDCAD","AUDJPY","AUDUSD","AUDCHF","AUDNZD","EURAUD","GBPAUD"};
string EURPairs[] = {"EURCAD","EURJPY","EURUSD","EURCHF","EURNZD","EURAUD","EURGBP"};
string CHFPairs[] = {"CHFJPY","AUDCHF","GBPCHF","CADCHF","EURCHF","USDCHF","NZDCHF"};
string GBPPairs[] = {"GBPUSD","GBPJPY","GBPAUD","GBPCAD","GBPCHF","GBPNZD","EURGBP"};
string USDPairs[] = {"USDCAD","USDJPY","USDCHF","AUDUSD","EURUSD","GBPUSD","NZDUSD"};
string NZDPairs[] = {"NZDJPY","NZDCAD","NZDCHF","NZDUSD","AUDNZD","EURNZD","GBPNZD"};
string CADPairs[] = {"CADCHF","CADJPY","AUDCAD","EURCAD","GBPCAD","USDCAD","NZDCAD"};
string JPYPairs[] = {"CADJPY","AUDJPY","USDJPY","CHFJPY","NZDJPY","EURJPY","GBPJPY"};

string EA_Pairs[];
string CSVFile;
int    BarCount = 0;
datetime LastWrittenBar = 0;

//== Initialisierung ====================================================
int OnInit()
{
    SetPairs();
    CSVFile = CSVPrefix + BasisWaehrung + "_M1_v" + EA_VERSION + ".csv";

    if(DoBackfill)
    {
        Print("Starte Backfill für ", BasisWaehrung);
        int filled = BackfillHistory(BackfillDays);
        Print(filled, " Bars als Historie geschrieben.");
    }
    else
    {
        // Schreibe Header falls Datei neu
        WriteHeaderIfNeeded();
    }
    EventSetTimer(LogIntervalMs / 1000);
    return INIT_SUCCEEDED;
}

//== Timer-getriebener Logger ===========================================
void OnTimer()
{
    LogCurrentBar();
    if(WriteStatus)
        WriteStatusFile();
}

//== Backfill: Schreibe Historie ========================================
int BackfillHistory(int days)
{
    int bars = 1440 * days;
    datetime now = TimeCurrent();
    int written = 0;

    WriteHeaderIfNeeded();

    for(int i=0; i<bars; i++)
    {
        datetime bar_time = now - 60*(bars-i);
        if(WriteBar(bar_time, true))
            written++;
    }
    return written;
}

//== Schreibe aktuellen Bar (M1) ========================================
void LogCurrentBar()
{
    // Hole die Zeit der letzten abgeschlossenen M1-Bar für das erste Paar
    MqlRates rates[];
    if(CopyRates(EA_Pairs[0], PERIOD_M1, 1, 1, rates) < 1)
        return;

    datetime bar_time = rates[0].time;
    if(bar_time <= LastWrittenBar)
        return;

    if(MaxBarsLive > 0 && BarCount >= MaxBarsLive)
        return;

    if(WriteBar(bar_time, false))
    {
        LastWrittenBar = bar_time;
        BarCount++;
    }
}

//== Schreibe eine Bar für alle Paare ===================================
bool WriteBar(datetime bar_time, bool isBackfill)
{
    int fileHandle = FileOpen(CSVFile, FILE_WRITE|FILE_READ|FILE_CSV|FILE_SHARE_WRITE, ';');
    if(fileHandle == INVALID_HANDLE)
    {
        LogError("Datei kann nicht geöffnet werden: " + CSVFile);
        return false;
    }
    FileSeek(fileHandle, 0, SEEK_END);

    string timestr = TimeToString(bar_time, TIME_DATE|TIME_MINUTES);

    // Schreibe Zeile für alle Paare
    for(int i=0; i<ArraySize(EA_Pairs); i++)
    {
        string pair = EA_Pairs[i];
        MqlRates rates[];
        if(CopyRates(pair, PERIOD_M1, bar_time, 1, rates) < 1)
        {
            LogError("Kein Bar für " + pair + "@" + timestr);
            continue;
        }
        long spread = 0;
        double bid = 0, ask = 0;
        if(UseSpread) spread = SymbolInfoInteger(pair, SYMBOL_SPREAD);
        if(UseBidAsk) bid    = SymbolInfoDouble(pair, SYMBOL_BID);
        if(UseBidAsk) ask    = SymbolInfoDouble(pair, SYMBOL_ASK);

        FileWrite(fileHandle,
            timestr, pair, rates[0].open, rates[0].high, rates[0].low, rates[0].close, rates[0].tick_volume,
            spread, bid, ask, BasisWaehrung, isBackfill ? "BACKFILL" : "LIVE", EA_VERSION, AccountInfoInteger(ACCOUNT_LOGIN)
        );
    }
    FileClose(fileHandle);
    return true;
}

//== Schreibe Header falls Datei neu ====================================
void WriteHeaderIfNeeded()
{
    int fileHandle = FileOpen(CSVFile, FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_WRITE, ';');
    if(fileHandle == INVALID_HANDLE)
    {
        LogError("Header: Datei kann nicht geöffnet werden: " + CSVFile);
        return;
    }
    if(FileSize(fileHandle)==0)
    {
        FileWrite(fileHandle,
            "timestamp","symbol","open","high","low","close","tick_volume",
            "spread","bid","ask","basis_currency","log_type","ea_version","account"
        );
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
        "LastWrite:",TimeToString(TimeLocal(),TIME_SECONDS),
        "BarCount:",BarCount,
        "EA_Version:",EA_VERSION
    );
    FileClose(handle);
}

//== Fehler-Logging =====================================================
void LogError(string msg)
{
    string errFile = CSVPrefix + BasisWaehrung + "_error_v" + EA_VERSION + ".log";
    int handle = FileOpen(errFile, FILE_WRITE|FILE_TXT|FILE_SHARE_WRITE);
    if(handle == INVALID_HANDLE) return;
    FileSeek(handle, 0, SEEK_END);
    FileWrite(handle, TimeToString(TimeLocal(),TIME_SECONDS), msg);
    FileClose(handle);
}

//== Setze relevante Paare für die Basiswährung =========================
void SetPairs()
{
    if(BasisWaehrung=="AUD")   { ArrayResize(EA_Pairs, ArraySize(AUDPairs));   ArrayCopy(EA_Pairs, AUDPairs); }
    else if(BasisWaehrung=="EUR") { ArrayResize(EA_Pairs, ArraySize(EURPairs)); ArrayCopy(EA_Pairs, EURPairs); }
    else if(BasisWaehrung=="CHF") { ArrayResize(EA_Pairs, ArraySize(CHFPairs)); ArrayCopy(EA_Pairs, CHFPairs); }
    else if(BasisWaehrung=="GBP") { ArrayResize(EA_Pairs, ArraySize(GBPPairs)); ArrayCopy(EA_Pairs, GBPPairs); }
    else if(BasisWaehrung=="USD") { ArrayResize(EA_Pairs, ArraySize(USDPairs
