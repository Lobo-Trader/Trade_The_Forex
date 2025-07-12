string AUD[] = {"AUDCAD", "AUDJPY", "AUDUSD", "AUDCHF", "AUDNZD", "EURAUD", "GBPAUD"};
double AUD_PipProgression[7];
double AUD_Total_Progression;

string EUR[] = {"EURCAD", "EURJPY", "EURUSD", "EURCHF", "EURNZD", "EURAUD", "EURGBP"};
double EUR_PipProgression[7];
double EUR_Total_Progression;

string CHF[] = {"CHFJPY", "AUDCHF", "GBPCHF", "CADCHF", "EURCHF", "USDCHF", "NZDCHF"};
double CHF_PipProgression[7];
double CHF_Total_Progression;

string GBP[] = {"GBPUSD", "GBPJPY", "GBPAUD", "GBPCAD", "GBPCHF", "GBPNZD", "EURGBP"};
double GBP_PipProgression[7];
double GBP_Total_Progression;

string USD[] = {"USDCAD", "USDJPY", "USDCHF", "AUDUSD", "EURUSD", "GBPUSD", "NZDUSD"};
double USD_PipProgression[7];
double USD_Total_Progression;

string NZD[] = {"NZDJPY", "NZDCAD", "NZDCHF", "NZDUSD", "AUDNZD", "EURNZD", "GBPNZD"};
double NZD_PipProgression[7];
double NZD_Total_Progression;

string CAD[] = {"CADCHF", "CADJPY", "AUDCAD", "EURCAD", "GBPCAD", "USDCAD", "NZDCAD"};
double CAD_PipProgression[7];
double CAD_Total_Progression;

string JPY[] = {"CADJPY", "AUDJPY", "USDJPY", "CHFJPY", "NZDJPY", "EURJPY", "GBPJPY"};
double JPY_PipProgression[7];
double JPY_Total_Progression;

double currency_strength_array[8];
string currency_name_array[8];
void GetPipProgression(string& currency[], double& point_difference[], int period, ENUM_TIMEFRAMES timeframe){

double difference[] = {0,0,0,0,0,0,0};

for(int i = 0; i < 7; i++){
   for(int j = 1; j < period; j++){
   
      difference[i] += (iClose(currency[i], timeframe, j) - iOpen(currency[i], timeframe, j))/(iHigh(currency[i], timeframe, j) - iLow(currency[i], timeframe, j));
      }
   point_difference[i] = difference[i];
}

}

double GetTotalProgression(double& point_progression[], string& currency[], string name){
   double totalChange = 0;
   
   for(int i = 0; i < 7; i++){
   if(StringCompare(name, StringSubstr(currency[i], 0, 3)) == 0){
      totalChange += point_progression[i];
   } else{
      totalChange -= point_progression[i];
   }
   }
   if(totalChange < -22){
   totalChange = 0;
   } else if(totalChange >= -22 && totalChange < -20){
   totalChange = 1;
   } else if(totalChange >= -20 && totalChange < -18){
      totalChange = 2;
   } else if(totalChange >= -18 && totalChange < -16){
      totalChange = 3;
   } else if(totalChange >= -16 && totalChange < -14){
   totalChange = 4;
   } else if(totalChange >= -14 && totalChange < -12){
      totalChange = 5;
   } else if(totalChange >= -12 && totalChange < -10){
      totalChange = 6;
   } else if(totalChange >= -10 && totalChange < -8){
   totalChange = 7;
   } else if(totalChange >= -8 && totalChange < -6){
      totalChange = 8;
   } else if(totalChange >= -6 && totalChange < -4){
      totalChange = 9;
   } else if(totalChange >= -4 && totalChange < -2){
   totalChange = 10;
   } else if(totalChange >= -2 && totalChange < 0){
      totalChange = 11;
   } else if(totalChange >= 0 && totalChange < 2){
      totalChange = 12;
   } else if(totalChange >= 2 && totalChange < 4){
   totalChange = 13;
   } else if(totalChange >= 4 && totalChange < 6){
      totalChange = 14;
   } else if(totalChange >= 6 && totalChange < 8){
      totalChange = 15;
   } else if(totalChange >= 8 && totalChange < 10){
   totalChange = 16;
   } else if(totalChange >= 10 && totalChange < 12){
      totalChange = 17;
   } else if(totalChange >= 12 && totalChange < 14){
      totalChange = 18;
   } else if(totalChange >= 14 && totalChange < 16){
      totalChange = 19;
   } else if(totalChange >= 16 && totalChange < 18){
      totalChange = 20;
   } else if(totalChange >= 18 && totalChange < 20){
      totalChange = 21;
   } else if(totalChange >= 20 && totalChange < 22){
      totalChange = 22;
   } else if(totalChange >= 22){
      totalChange = 23;
   }
   return totalChange;
}

void OrderCurrencies(double& currency_progression[], string& currency_names[]){
   double valueHolder;
   string nameHolder;
   for(int i = 0; i < 8; i++){
      for(int k = 0; k < 8; k++){
         if(currency_progression[i] > currency_progression[k]){
         
            valueHolder = currency_progression[i];
            nameHolder = currency_names[i];
            
            currency_progression[i] = currency_progression[k];
            currency_names[i] = currency_names[k];
            
            currency_progression[k] = valueHolder;
            currency_names[k] = nameHolder;
         }
      
      }
   }
}

int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//-------------------------------CURRENCY STRENGTH-----------------------------------------
   //AUD
  GetPipProgression(AUD, AUD_PipProgression, 20, PERIOD_H1);
   AUD_Total_Progression = GetTotalProgression(AUD_PipProgression, AUD, "AUD");
   
   //EUR
   GetPipProgression(EUR, EUR_PipProgression, 20, PERIOD_H1);
   EUR_Total_Progression = GetTotalProgression(EUR_PipProgression, EUR, "EUR");
  
   //CHF
   GetPipProgression(CHF, CHF_PipProgression, 20, PERIOD_H1);
   CHF_Total_Progression = GetTotalProgression(CHF_PipProgression, CHF, "CHF");
   
   //GBP
   GetPipProgression(GBP, GBP_PipProgression, 20, PERIOD_H1);
   GBP_Total_Progression = GetTotalProgression(GBP_PipProgression, GBP, "GBP");
   
   //USD
   GetPipProgression(USD, USD_PipProgression, 20, PERIOD_H1);
   USD_Total_Progression = GetTotalProgression(USD_PipProgression, USD, "USD");
   
   //NZD
   GetPipProgression(NZD, NZD_PipProgression, 20, PERIOD_H1);
   NZD_Total_Progression = GetTotalProgression(NZD_PipProgression, NZD, "NZD");
   
   //CAD
   GetPipProgression(CAD, CAD_PipProgression, 20, PERIOD_H1);
   CAD_Total_Progression = GetTotalProgression(CAD_PipProgression, CAD, "CAD");
   
   //JPY
   GetPipProgression(JPY, JPY_PipProgression, 20, PERIOD_H1);
   JPY_Total_Progression = GetTotalProgression(JPY_PipProgression, JPY, "JPY");
                  
   currency_name_array[0] = "AUD";
   currency_name_array[1] = "EUR";
   currency_name_array[2] = "CHF";
   currency_name_array[3] = "GBP";
   currency_name_array[4] = "USD";
   currency_name_array[5] = "NZD";
   currency_name_array[6] = "CAD";
   currency_name_array[7] = "JPY";
   
   currency_strength_array[0] = AUD_Total_Progression;
   currency_strength_array[1] = EUR_Total_Progression;
   currency_strength_array[2] = CHF_Total_Progression;
   currency_strength_array[3] = GBP_Total_Progression;
   currency_strength_array[4] = USD_Total_Progression;         
   currency_strength_array[5] = NZD_Total_Progression;
   currency_strength_array[6] = CAD_Total_Progression;
   currency_strength_array[7] = JPY_Total_Progression;    
   
   OrderCurrencies(currency_strength_array, currency_name_array);
   
   string comment = "";
   for(int i = 0; i < 8; i++){
   comment += currency_name_array[i] + " - " + currency_strength_array[i] + "\n";
   }     
   Comment(comment);
  }
//+------------------------------------------------------------------+
