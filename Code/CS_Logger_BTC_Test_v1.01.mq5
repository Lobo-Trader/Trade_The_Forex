//+------------------------------------------------------------------+
//|                CS_Logger_BTC_Test_v1.01.mq5                      |
//|   Multi-Pair M1 OHLCV Logger - BTC Testversion                   |
//|   Loggt jede Minute für jedes BTC-Pair EINE ZEILE                |
//|   Version: 1.01                                                  |
//+------------------------------------------------------------------+
#property copyright "Lobo-Trader & Nova"
#property link      "https://github.com/Lobo-Trader"
#property version   "1.01"
#property strict

#define EA_VERSION "1.01"

input string CSVFile = "BTC_Matrix_Test_M1_v1.01.csv"; // Dateiname der Test-CSV
input bool   WriteStatus = true;                       // Status-Heartbeat-File schreiben?

//== BTC-Paare für Test laut Screenshot =================================
string EA_Pairs[] = {"BTCBCH","BTCETH","BTCEUR","BTCUSD"};

datetime LastWrittenBar = 0;

//== Initialisierung ====================================================
int OnInit()
{
    // Schreibe Header falls Datei neu
    WriteHeaderIfNeeded();

    // Timer auf 60 Sekunden stellen (1x pro Minute)
    EventSetTimer(60);
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
        FileWriteString(fileHandle, StringFormat("%s;%s;%.2f;%.2f;%.2f;%.2f;%d\n",
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
    string statusFile = "BTC_Matrix_Test_status_v1.01.txt";
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