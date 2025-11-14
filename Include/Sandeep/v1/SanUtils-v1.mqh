//+------------------------------------------------------------------+
//|                                                     SanUtils.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

#include <Sandeep/v1/SanTypes-v1.mqh>

//#include <Sandeep/v1/SanStats-v1.mqh>


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SanUtils {
 private:

 public:
   SanUtils();
   ~SanUtils();


   //   void              initTrade();

   ulong             placeOrder(ulong mnumber, double vol, ENUM_ORDER_TYPE orderType, int slippage = 3, double stopLoss = 0, double takeProfit = 0);
   bool              closeOrders();
   void              sayMesg();
   double            getPipValue(string symbol);
   bool              isNewBar();
   bool              isNewBarTime();
   bool              execTimer();
   bool              isNewBarBlip();

   string            printStr(string data, bool newLine = true);
   string            getUninitReasonText(int reasonCode);
   string            getSigString(double sig);
   string            getSymbolString(string symbol);
   bool              hasOpenPosition(int magic);
   bool              closeOrderPos(int pos);
   bool              closeOrderTicket(ulong ticket);
   bool              closeOrdersOnRevSignal(SAN_SIGNAL signal, int orderPos = 0);
   bool              oppSignal(SAN_SIGNAL sig1, SAN_SIGNAL sig2);
   bool              equivalentSigTrend(SAN_SIGNAL sig, SANTREND trnd);
   uint              pipsPerTick(const bool newCandle, const double close);
   bool              oppSigTrend(SAN_SIGNAL sig, SANTREND trnd);
   SAN_SIGNAL        convTrendToSig(SANTREND trnd);
   SAN_SIGNAL        flipSig(SAN_SIGNAL sig);
   SAN_SIGNAL        getCurrTradePosition();
   double            getSigVariabilityBool(const SIGMAVARIABILITY &varSIG, string sigType = "IMA30");
   double            getSigVarBool(const SIGMAVARIABILITY &varSIG);
   bool              farmProfits(double captureProfit);
   void              printSignalStruct(const SANSIGNALS &ss);
   string            printArray(const double& arrVal[], string mainLabel, string loopLabel, int BEGIN = 0, int END = 8);
   string            arrayToCSVString(const string &values[]);
   bool              isMidnight(int bufferSecs = 60);
   bool              renameFile(string oldFileName, string newFileName);
   bool              fileSizeCheck(string fileName, uint fileMiBSize = 20);
   void              writeData(string name, string data);
   bool              writeArrData(string name, const double &values[], string order);
   bool              writeHeaderData(string filename, const string &headerArr[]);
   bool              writeStructData(string filename, const INDDATA &indData, SAN_SIGNAL order, int shift = 1);
   bool              writeJsonData(string filename, const INDDATA &indData, SAN_SIGNAL order, int shift = 1);
   double            SafeDiv(const double val1, const double val2, const int normalizeDigits = 4, const double zeroDivValue = DBL_MAX);
   bool              intExistsInArray(const int &arr[], int value);
   double            getPriceInPips(const double price);
   void              copyArraySlice(const double &source[], double &target[], int startIndex, int endIndex);
   void              transformAndCopyArraySlice(const double &source[], double &target[], int startIndex, int endIndex, double pipValue);

};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanUtils::SanUtils(void) {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SanUtils::~SanUtils() {};


//+------------------------------------------------------------------+
//| get text description                                             |
//+------------------------------------------------------------------+
string SanUtils::getUninitReasonText(int reasonCode) {
   string text = "";
//---
   switch(reasonCode) {
   case REASON_ACCOUNT:
      text = "Account was changed";
      break;
   case REASON_CHARTCHANGE:
      text = "Symbol or timeframe was changed";
      break;
   case REASON_CHARTCLOSE:
      text = "Chart was closed";
      break;
   case REASON_PARAMETERS:
      text = "Input-parameter was changed";
      break;
   case REASON_RECOMPILE:
      text = "Program " + __FILE__ + " was recompiled";
      break;
   case REASON_REMOVE:
      text = "Program " + __FILE__ + " was removed from chart";
      break;
   case REASON_TEMPLATE:
      text = "New template was applied to chart";
      break;
   default:
      text = "Another reason";
   }
//---
   return text;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SanUtils::sayMesg() {
   double ticksize     = MarketInfo(_Symbol, MODE_TICKSIZE);
   double tickvalue    = MarketInfo(_Symbol, MODE_TICKVALUE);
   double ask = MarketInfo(_Symbol, MODE_ASK);
   double bid = MarketInfo(_Symbol, MODE_BID);
   const double tPoint = Point();
   Print(" Point value: ", tPoint, " Tick Size: ", ticksize, " Tick Value: ", tickvalue, " Ask: ", ask, " Bid: ", bid);
}


// Function to check if a value exists in an array
bool SanUtils::intExistsInArray(const int &arr[], int value) {
   for (int i = 0; i < ArraySize(arr); i++) {
      if (arr[i] == value) {
         return true;
      }
   }
   return false;
}


//+------------------------------------------------------------------+
//| Triggers true once at the start of each interval based on _Period |
//| Returns true if it's time to "ping", false otherwise.             |
//+------------------------------------------------------------------+
bool SanUtils::execTimer() {
   int currMinute = TimeMinute(TimeCurrent());
   int currHour = TimeHour(TimeCurrent());
   int currDay = TimeDay(TimeCurrent());
   static int lastRecordTime = -1;
   int recordFreq = 0;      // Declare variable
   int currentRecordTime = 0;  // Declare variable
   if (_Period < 60) {
      recordFreq = _Period;
      currentRecordTime = currMinute;
   } else if ((_Period >= 60) && (_Period < 1440)) {
      recordFreq = (int)(_Period / 60);
      currentRecordTime = currHour;
   } else if ((_Period >= 1440) && (_Period < 43200)) {
      recordFreq = (int)(_Period / 1440);
      currentRecordTime = currDay;
   } else {
      recordFreq = -1;  // No trigger for MN1 or higher
   }
   // Safeguard against modulo by zero
   if (recordFreq <= 0) {
      return false;
   }
   if ((currentRecordTime % recordFreq == 0) && (currentRecordTime != lastRecordTime)) {
      lastRecordTime = currentRecordTime;
      return true;  // Fixed: Was 'return bool;'
   }
   return false;
}

//+------------------------------------------------------------------+
//| Triggers true exactly once at the start of each new bar           |
//+------------------------------------------------------------------+
bool SanUtils::isNewBarBlip() {
   static datetime lastBarTime = 0;
   datetime currentBarTime = Time[0];  // Open time of current bar
   if (currentBarTime > lastBarTime) {
      lastBarTime = currentBarTime;
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getPipValue(string symbol) {
   double point = MarketInfo(symbol, MODE_POINT); // e.g., 0.001 for USDJPY, 0.00001 for EURUSD
   int digits = MarketInfo(symbol, MODE_DIGITS);  // e.g., 3 for USDJPY, 5 for EURUSD
   bool isJPY = StringFind(symbol, "JPY") >= 0;   // True if JPY pair
// JPY pairs: 1 Pip = 0.01 (2nd decimal)
   if(isJPY) {
      if(digits == 3) {
         return point * 10;   // 3-digit JPY: 1 pip = 10 points (e.g., 0.01)
      }
      if(digits == 2) {
         return point;   // 2-digit JPY: 1 pip = 1 point (e.g., 0.01)
      }
   }
// Non-JPY pairs: 1 Pip = 0.0001 (4th decimal)
   else {
      if(digits == 5) {
         return point * 10;   // 5-digit non-JPY: 1 pip = 10 points (e.g., 0.0001)
      }
      if(digits == 4) {
         return point;   // 4-digit non-JPY: 1 pip = 1 point (e.g., 0.0001)
      }
   }
// Default for non-standard digits (e.g., 5-digit JPY or 6-digit non-JPY)
// Assume 1 pip = 10 points for high precision, 1 point for low precision
   return (digits > 4 || (isJPY && digits > 2)) ? point * 10 : point;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isMidnight(int bufferSecs = 60) {
   datetime currentTime = TimeCurrent();
   datetime midnight = TimeCurrent() - (TimeCurrent() % 86400);
   return (currentTime >= midnight && currentTime < midnight + bufferSecs); // 60-second window
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::renameFile(string oldFileName, string newFileName) {
   string src_path = "./" + oldFileName;
   string dst_path = "./" + newFileName;
   if(!FileMove(src_path, 0, dst_path, FILE_COMMON | FILE_REWRITE)) {
      Print("Error moving file: ", GetLastError());
      return false;
   }
   Print("File successfully renamed from ", oldFileName, " to ", newFileName);
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrders() {
   int total = OrdersTotal();
   Print("Closing all buy and sell orders");
   for(int pos = 0; pos < total; pos++) {
      if(OrderSelect(pos, SELECT_BY_POS)) {
         if(OrderType() == OP_BUY) {
            return OrderClose(OrderTicket(), OrderLots(), Bid, 5, clrNONE);
         }
         if(OrderType() == OP_SELL) {
            return OrderClose(OrderTicket(), OrderLots(), Ask, 5, clrNONE);
         }
         // FileWrite(handle,OrderTicket(),OrderOpenPrice(),OrderOpenTime(),OrderSymbol(),OrderLots());
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrdersOnRevSignal(SAN_SIGNAL signal, int orderPos = 0) {
   int totalOrders = OrdersTotal();
   if((totalOrders > 0) && (OrderSelect(orderPos, SELECT_BY_POS) == true)) {
      if((OrderType() == OP_BUY) && (signal == SAN_SIGNAL::SELL)) {
         Print(" Closing Buy Order on reverse signal: ");
         return OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
      }
      if((OrderType() == OP_SELL) && (signal == SAN_SIGNAL::BUY)) {
         Print(" Closing Sell Order on reverse signal: ");
         return OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::oppSignal(SAN_SIGNAL sig1, SAN_SIGNAL sig2) {
   if((sig1 == SAN_SIGNAL::BUY) && (sig2 == SAN_SIGNAL::SELL)) {
      return true;
   }
   if((sig1 == SAN_SIGNAL::SELL) && (sig2 == SAN_SIGNAL::BUY)) {
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::hasOpenPosition(int magic) {
   for(int i = 0; i < OrdersTotal(); i++) {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != magic) continue;
      if(OrderSymbol() != _Symbol) continue;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrderPos(int pos = 0) {
   if(OrderSelect(pos, SELECT_BY_POS)) {
      if(OrderType() == OP_BUY) {
         Print("Closeout buy order on profit of: ");
         return OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
      }
      if(OrderType() == OP_SELL) {
         Print("Closeout sell order on profit of: ");
         return OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::closeOrderTicket(ulong ticket) {
   if(OrderSelect(ticket, SELECT_BY_TICKET)) {
      if(OrderType() == OP_BUY) {
         return OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
      }
      if(OrderType() == OP_SELL) {
         return OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong SanUtils::placeOrder(ulong mnumber, double vol, ENUM_ORDER_TYPE orderType, int slippage = 3, double stopLoss = 0, double takeProfit = 0) {
   if(((ENUM_ORDER_TYPE)orderType) == ENUM_ORDER_TYPE::ORDER_TYPE_BUY && (OrdersTotal() == 0)) {
      Print("Inside BUY ORDER: " + mnumber + " Ask: " + Ask + " Modified ask: " + (Ask + (Point * 40)));
      return OrderSend(_Symbol, OP_BUY, vol, Ask, slippage, stopLoss, takeProfit, "My buy order", mnumber, 0, clrNONE);
   }
   if(((ENUM_ORDER_TYPE)orderType) == ENUM_ORDER_TYPE::ORDER_TYPE_SELL && (OrdersTotal() == 0)) {
      Print("Inside SELL ORDER: " + mnumber + " Bid: " + Bid + " Modified bid: " + (Bid - (Point * 40)));
      return OrderSend(_Symbol, OP_SELL, vol, Bid, slippage, stopLoss, takeProfit, "My sell order", mnumber, 0, clrNONE);
   }
   return -1;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isNewBar() {
   static ulong barCount = Bars(_Symbol, PERIOD_CURRENT);
   if(barCount == Bars(_Symbol, PERIOD_CURRENT)) {
      return false;
   }
   barCount = Bars(_Symbol, PERIOD_CURRENT);
   return true;
};

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//bool SanUtils::isNewBarTime() {
//   static datetime lastbar;
//   datetime curbar = (datetime)SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
//   if(lastbar != curbar) {
//      lastbar = curbar;
//      return true;
//   }
//   return false;
//};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::isNewBarTime() {
   static datetime lastbar = 0;
   static string lastSymbol = "";
   static ENUM_TIMEFRAMES lastPeriod = PERIOD_CURRENT;
   if (_Symbol != lastSymbol || _Period != lastPeriod) {
      lastbar = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
      lastSymbol = _Symbol;
      lastPeriod = _Period;
      return false;
   }
   long curbarLong = SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if (curbarLong == 0) {
      Print("Error: Unable to get last bar date for ", _Symbol);
      return false;
   }
   datetime curbar = (datetime)curbarLong;
   if (lastbar != curbar) {
      lastbar = curbar;
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::farmProfits(double captureProfit) {
   int orderCount = OrdersTotal();
   for(int i = 0; i < orderCount; i++) {
      if(OrderSelect(i, SELECT_BY_POS) && (OrderProfit() > captureProfit)) {
         return closeOrderPos(i);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::printStr(string data, bool newLine = true) {
   if(!newLine) {
      return data;
   }
   return data + "\r\n";
};
//SANTREND
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::getSigString(double sig) {
   if(sig == EMPTY) {
      return "EMPTY";
   }
   if(sig == SAN_SIGNAL::BUY) {
      return "BUY";
   }
   if(sig == SAN_SIGNAL::SELL) {
      return "SELL";
   }
   if(sig == SAN_SIGNAL::HOLD) {
      return "HOLD";
   }
   if(sig == SAN_SIGNAL::OPEN) {
      return "OPEN";
   }
   if(sig == SAN_SIGNAL::CLOSE) {
      return "CLOSE";
   }
   if(sig == SAN_SIGNAL::CLOSEBUY) {
      return "CLOSEBUY";
   }
   if(sig == SAN_SIGNAL::CLOSESELL) {
      return "CLOSESELL";
   }
   if(sig == SAN_SIGNAL::TRADEBUY) {
      return "TRADEBUY";
   }
   if(sig == SAN_SIGNAL::TRADESELL) {
      return "TRADESELL";
   }
   if(sig == SAN_SIGNAL::TRADE) {
      return "TRADE";
   }
   if(sig == SAN_SIGNAL::NOTRADE) {
      return "NOTRADE";
   }
   if(sig == SAN_SIGNAL::REVERSETRADE) {
      return "REVERSETRADE";
   }
   if(sig == SAN_SIGNAL::SIDEWAYS) {
      return "SIDEWAYS";
   }
   if(sig == SAN_SIGNAL::NOSIG) {
      return "NOSIG";
   }
   if(sig == SANTREND::UP) {
      return "UP";
   }
   if(sig == SANTREND::DOWN) {
      return "DOWN";
   }
   if(sig == SANTREND::CONVUP) {
      return "CONVUP";
   }
   if(sig == SANTREND::CONVDOWN) {
      return "CONVDOWN";
   }
   if(sig == SANTREND::CONVFLAT) {
      return "CONVFLAT";
   }
   if(sig == SANTREND::DIVUP) {
      return "DIVUP";
   }
   if(sig == SANTREND::DIVDOWN) {
      return "DIVDOWN";
   }
   if(sig == SANTREND::DIVFLAT) {
      return "DIVFLAT";
   }
   if(sig == SANTREND::FLATUP) {
      return "FLATUP";
   }
   if(sig == SANTREND::FLATDOWN) {
      return "FLATDOWN";
   }
   if(sig == SANTREND::FLATFLAT) {
      return "FLATFLAT";
   }
   if(sig == SANTREND::FLAT) {
      return "FLAT";
   }
   if(sig == SANTREND::TREND) {
      return "TREND";
   }
   if(sig == SANTREND::NOTREND) {
      return "NOTREND";
   }
   if(sig == SANTRENDSTRENGTH::WEAK) {
      return "WEAK";
   }
   if(sig == SANTRENDSTRENGTH::NORMAL) {
      return "NORMAL";
   }
   if(sig == SANTRENDSTRENGTH::HIGH) {
      return "HIGH";
   }
   if(sig == SANTRENDSTRENGTH::SUPERHIGH) {
      return "SUPERHIGH";
   }
   if(sig == SANTRENDSTRENGTH::POOR) {
      return "POOR";
   }
   if(sig == STRATEGYTYPE::STDMFIADX) {
      return "STD:MFI:ADX";
   }
   if(sig == STRATEGYTYPE::PA) {
      return "PA";
   }
   if(sig == STRATEGYTYPE::IMACLOSE) {
      return "IMACLOSE";
   }
   if(sig == STRATEGYTYPE::FARMPROFITS) {
      return "strategy::farm profits";
   }
   if(sig == STRATEGYTYPE::CLOSEPOSITIONS) {
      return "strategy::close positions";
   }
   if(sig == STRATEGYTYPE::NOSTRATEGY) {
      return "strategy::no strategy";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_NULL) {
      return "SIGMA_NULL";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_REST) {
      return "SIGMAPOS_REST";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_REST) {
      return "SIGMANEG_REST";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_REST) {
      return "SIGMA_REST";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_4) {
      return "SIGMAPOS_4";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_4) {
      return "SIGMANEG_4";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_4) {
      return "SIGMA_4";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_3) {
      return "SIGMAPOS_3";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_3) {
      return "SIGMANEG_3";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_3) {
      return "SIGMA_3";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_2) {
      return "SIGMAPOS_2";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_2) {
      return "SIGMANEG_2";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_2) {
      return "SIGMA_2";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_16) {
      return "SIGMAPOS_16";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_16) {
      return "SIGMANEG_16";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_16) {
      return "SIGMA_16";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_1) {
      return "SIGMAPOS_1";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_1) {
      return "SIGMANEG_1";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_1) {
      return "SIGMA_1";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_HALF) {
      return "SIGMAPOS_HALF";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_HALF) {
      return "SIGMANEG_HALF";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_HALF) {
      return "SIGMA_HALF";
   }
   if(sig == SIGMAVARIABILITY::SIGMAPOS_MEAN) {
      return "SIGMAPOS_MEAN";
   }
   if(sig == SIGMAVARIABILITY::SIGMANEG_MEAN) {
      return "SIGMANEG_MEAN";
   }
   if(sig == SIGMAVARIABILITY::SIGMA_MEAN) {
      return "SIGMA_MEAN";
   }
   if(sig == MKTTYP::MKTFLAT) {
      return "Flat Mkt";
   }
   if(sig == MKTTYP::MKTTR) {
      return "Trending Mkt";
   }
   if(sig == MKTTYP::MKTUP) {
      return "Trending Up Mkt";
   }
   if(sig == MKTTYP::MKTDOWN) {
      return "Trending Down Mkt";
   }
   if(sig == MKTTYP::MKTCLOSE) {
      return "Close Mkt(Close Trade)";
   }
   if(sig == MKTTYP::NOMKT) {
      return "No Mkt";
   }
   if(sig == TRADE_STRATEGIES::SIMPLESIG) {
      return "simpleSIG strategy";
   }
   if(sig == TRADE_STRATEGIES::FASTSIG) {
      return "fastSIG strategy";
   }
   if(sig == TRADE_STRATEGIES::SLOPESIG) {
      return "Slope Sig Strategy";
   }
   if(sig == TRADE_STRATEGIES::SLOPERATIOSIG) {
      return "Slope  ratio Sig Strategy";
   }
   if(sig == TRADE_STRATEGIES::NOTRDSTGY) {
      return "No trade Strategy";
   }
   return "NOSIG";
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::getSymbolString(string symbol) {
   if(StrToInteger(symbol) == PERIOD_M1) {
      return "1 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_M5) {
      return "5 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_M15) {
      return "15 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_M30) {
      return "30 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_H1) {
      return "60 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_H4) {
      return "240 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_D1) {
      return "1440 Minutes";
   }
   if(StrToInteger(symbol) == PERIOD_W1) {
      return "10080 Minutes";
   }
   if(symbol == Symbol()) {
      int pos = StringFind(symbol, ".");
      if(pos > 0) {
         return StringSubstr(symbol, 0, pos);
      }
      return symbol;
   }
   if((symbol == "") || (StrToInteger(symbol) == EMPTY)) {
      return "NOSYMBOL";
   }
   return "NOSYMBOL";
}
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//string SanUtils::getSymbolString(double symbol=0, string currency="") {
//
//   if(currency==Symbol()) {
//      int pos = StringFind(currency,".");
//      if(pos>0) {
//         return StringSubstr(currency,0,pos);
//      }
//      return currency;
//   }
//
//   if(symbol==PERIOD_M1) {
//      return "1 Minutes";
//   }
//   if(symbol==PERIOD_M5) {
//      return "5 Minutes";
//   }
//   if(symbol==PERIOD_M15) {
//      return "15 Minutes";
//   }
//   if(symbol==PERIOD_M30) {
//      return "30 Minutes";
//   }
//   if(symbol==PERIOD_H1) {
//      return "60 Minutes";
//   }
//   if(symbol==PERIOD_H4) {
//      return "240 Minutes";
//   }
//   if(symbol==PERIOD_D1) {
//      return "1440 Minutes";
//   }
//   if(symbol==PERIOD_W1) {
//      return "10080 Minutes";
//   }
//
//
//   if((symbol==0)&&(currency=="")) {
//      return "NOSYMBOL";
//   }
//
//   return "NOSYMBOL";
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::equivalentSigTrend(SAN_SIGNAL sig, SANTREND trnd) {
   if((sig == SAN_SIGNAL::BUY) && (trnd == SANTREND::UP)) {
      return true;
   }
   if((sig == SAN_SIGNAL::SELL) && (trnd == SANTREND::DOWN)) {
      return true;
   }
   if((sig == SAN_SIGNAL::NOSIG) && (trnd == SANTREND::NOTREND)) {
      return true;
   }
   if((sig == SAN_SIGNAL::TRADE) && ((trnd == SANTREND::UP) || (trnd == SANTREND::DOWN))) {
      return true;
   }
   if((sig == SAN_SIGNAL::NOTRADE) && ((trnd == SANTREND::FLAT) || (trnd == SANTREND::NOTREND))) {
      return true;
   }
   if((sig == SAN_SIGNAL::OPEN) && ((trnd == SANTREND::UP) || (trnd == SANTREND::DOWN))) {
      return true;
   }
   if((sig == SAN_SIGNAL::CLOSE) && ((trnd == SANTREND::FLAT) || (trnd == SANTREND::NOTREND))) {
      return true;
   }
   return false;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL SanUtils::convTrendToSig(SANTREND trnd) {
   if(trnd == SANTREND::UP) {
      return SAN_SIGNAL::BUY;
   }
   if(trnd == SANTREND::DOWN) {
      return SAN_SIGNAL::SELL;
   }
   if(trnd == SANTREND::FLAT) {
      return SAN_SIGNAL::SIDEWAYS;
   }
   if(trnd == SANTREND::NOTREND) {
      return SAN_SIGNAL::NOSIG;
   }
   return SAN_SIGNAL::NOSIG;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        SanUtils::flipSig(SAN_SIGNAL sig) {
   return ((sig == SAN_SIGNAL::BUY) ? SAN_SIGNAL::SELL : ((sig == SAN_SIGNAL::SELL) ? SAN_SIGNAL::BUY : sig));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SAN_SIGNAL        SanUtils::getCurrTradePosition() {
   SAN_SIGNAL tradePosition = SAN_SIGNAL::NOSIG;
   int totalOrders = OrdersTotal();
   if(totalOrders > 0) {
      for(int i = 0; i < totalOrders; i++) {
         if(OrderSelect(i, SELECT_BY_POS)) {
            if(OrderType() == OP_BUY)
               tradePosition = SAN_SIGNAL::BUY;
            if(OrderType() == OP_SELL)
               tradePosition = SAN_SIGNAL::SELL;
            if((OrderType() != OP_SELL) && (OrderType() != OP_BUY) && (OrderType() != OP_SELLLIMIT) && (OrderType() != OP_BUYLIMIT) && (OrderType() != OP_SELLSTOP) && (OrderType() != OP_BUYSTOP))
               tradePosition = SAN_SIGNAL::NOSIG;
         }
      }
   }
   return tradePosition;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::oppSigTrend(SAN_SIGNAL sig, SANTREND trnd) {
   if((sig == SAN_SIGNAL::BUY) && (trnd == SANTREND::DOWN)) {
      return true;
   }
   if((sig == SAN_SIGNAL::SELL) && (trnd == SANTREND::UP)) {
      return true;
   }
   if(((sig == SAN_SIGNAL::NOSIG) && (trnd == SANTREND::TREND)) || ((sig != SAN_SIGNAL::NOSIG) && (trnd == SANTREND::NOTREND))) {
      return true;
   }
   if((sig == SAN_SIGNAL::TRADE) && ((trnd == SANTREND::FLAT) || (trnd == SANTREND::FLATUP) || (trnd == SANTREND::FLATDOWN) || (trnd == SANTREND::NOTREND))) {
      return true;
   }
   if((sig == SAN_SIGNAL::NOTRADE) && ((trnd == SANTREND::UP) || (trnd == SANTREND::DOWN))) {
      return true;
   }
   if((sig == SAN_SIGNAL::OPEN) && ((trnd == SANTREND::FLAT) || (trnd == SANTREND::FLATUP) || (trnd == SANTREND::FLATDOWN) || (trnd == SANTREND::NOTREND))) {
      return true;
   }
   if((sig == SAN_SIGNAL::CLOSE) && ((trnd == SANTREND::UP) || (trnd == SANTREND::DOWN))) {
      return true;
   }
   if((sig != SAN_SIGNAL::NOSIG) && ((trnd == SANTREND::FLAT) || (trnd == SANTREND::FLATUP) || (trnd == SANTREND::FLATDOWN) || (trnd == SANTREND::NOTREND))) {
      return true;
   }
   return false;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint  SanUtils::pipsPerTick(const bool newCandle, const double close) {
   static uint tickStart = 0;
   if(newCandle) {
      tickStart = GetTickCount();
   }
   tickStart = (GetTickCount() - tickStart);
   Print("Current ticks since start: " + tickStart);
   return EMPTY;
};



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getSigVarBool(const SIGMAVARIABILITY &varSIG) {
   bool meanRange = ((varSIG == SIGMAVARIABILITY::SIGMA_MEAN) || (varSIG == SIGMAVARIABILITY::SIGMANEG_MEAN) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool halfRange = ((varSIG == SIGMAVARIABILITY::SIGMANEG_HALF) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool range1 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_1) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_1));
   bool range16 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_16) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_16));
   bool range2 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_2) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_2));
   bool range3 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_3) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_3));
   bool range35 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_35) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_35));
   bool range4 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_4) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_4));
   bool rangeRest = ((varSIG == SIGMAVARIABILITY::SIGMANEG_REST) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_REST));
   bool notMean = ((varSIG != SIGMAVARIABILITY::SIGMA_MEAN) && (varSIG != SIGMAVARIABILITY::SIGMANEG_MEAN) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool notHalf = ((varSIG != SIGMAVARIABILITY::SIGMANEG_HALF) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool not1 = ((varSIG != SIGMAVARIABILITY::SIGMANEG_1) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_1));
   bool not16 = ((varSIG != SIGMAVARIABILITY::SIGMANEG_16) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_16));
   bool inRangeBool = false;
   bool inPosRangeBool = false;
   bool inNegRangeBool = false;
   bool ltThan16 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_2) || (varSIG == SIGMAVARIABILITY::SIGMANEG_3) || (varSIG == SIGMAVARIABILITY::SIGMANEG_35) || (varSIG == SIGMAVARIABILITY::SIGMANEG_4) || (varSIG == SIGMAVARIABILITY::SIGMANEG_REST));
   bool gtThan16 = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_2) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_3) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_35) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_4) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_REST));
   bool ltThan1 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_16) || ltThan16);
   bool gtThan1 = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_16) || gtThan16);
   bool ltThanHalf = ((varSIG == SIGMAVARIABILITY::SIGMANEG_1) || ltThan1);
   bool gtThanHalf = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_1) || gtThan1);
   if(meanRange || halfRange) {
      return 0;
   }
   inRangeBool = (notMean && notHalf);
   inNegRangeBool = (inRangeBool && ltThanHalf);
   inPosRangeBool = (inRangeBool && gtThanHalf);
   if(inNegRangeBool) {
      return -1.314;
   }
   if(inPosRangeBool) {
      return 1.314;
   }
   return 0.0;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SanUtils::getSigVariabilityBool(const SIGMAVARIABILITY &varSIG, string sigType = "IMA30") {
   int resultIma5 = StringCompare("IMA5", sigType, false);
   int resultIma14 = StringCompare("IMA14", sigType, false);
   int resultIma30 = StringCompare("IMA30", sigType, false);
   int resultIma120 = StringCompare("IMA120", sigType, false);
   int resultIma240 = StringCompare("IMA240", sigType, false);
   int resultMEDIUM = StringCompare("MEDIUM", sigType, false);
   int resultSLOW = StringCompare("SLOW", sigType, false);
   int resultFAST = StringCompare("FAST", sigType, false);
   bool meanRange = ((varSIG == SIGMAVARIABILITY::SIGMA_MEAN) || (varSIG == SIGMAVARIABILITY::SIGMANEG_MEAN) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool halfRange = ((varSIG == SIGMAVARIABILITY::SIGMANEG_HALF) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool range1 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_1) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_1));
   bool range16 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_16) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_16));
   bool range2 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_2) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_2));
   bool range3 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_3) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_3));
   bool range35 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_35) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_35));
   bool range4 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_4) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_4));
   bool rangeRest = ((varSIG == SIGMAVARIABILITY::SIGMANEG_REST) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_REST));
   bool notMean = ((varSIG != SIGMAVARIABILITY::SIGMA_MEAN) && (varSIG != SIGMAVARIABILITY::SIGMANEG_MEAN) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_MEAN));
   bool notHalf = ((varSIG != SIGMAVARIABILITY::SIGMANEG_HALF) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_HALF));
   bool not1 = ((varSIG != SIGMAVARIABILITY::SIGMANEG_1) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_1));
   bool not16 = ((varSIG != SIGMAVARIABILITY::SIGMANEG_16) && (varSIG != SIGMAVARIABILITY::SIGMAPOS_16));
   bool inRangeBool = false;
   bool inPosRangeBool = false;
   bool inNegRangeBool = false;
   bool ltThan16 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_2) || (varSIG == SIGMAVARIABILITY::SIGMANEG_3) || (varSIG == SIGMAVARIABILITY::SIGMANEG_35) || (varSIG == SIGMAVARIABILITY::SIGMANEG_4) || (varSIG == SIGMAVARIABILITY::SIGMANEG_REST));
   bool gtThan16 = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_2) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_3) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_35) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_4) || (varSIG == SIGMAVARIABILITY::SIGMAPOS_REST));
   bool ltThan1 = ((varSIG == SIGMAVARIABILITY::SIGMANEG_16) || ltThan16);
   bool gtThan1 = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_16) || gtThan16);
   bool ltThanHalf = ((varSIG == SIGMAVARIABILITY::SIGMANEG_1) || ltThan1);
   bool gtThanHalf = ((varSIG == SIGMAVARIABILITY::SIGMAPOS_1) || gtThan1);
//   if(meanRange||halfRange) {
   if(meanRange) {
      return 0;
   }
//   if((resultIma5==0)||(resultIma14==0)||(resultFAST==0)) {
//      //Print(" Variablity FAST or 14 or 5");
//      inRangeBool = (notMean && notHalf && not1 && not16);
//      inNegRangeBool = (inRangeBool && ltThan16);
//      inPosRangeBool = (inRangeBool && gtThan16);
//   } else if((resultIma30==0)||(resultMEDIUM==0)) {
//      // Print(" Variablity MEDIUM or 30");
//      inRangeBool = (notMean && notHalf && not1);
//      inNegRangeBool = (inRangeBool && ltThan1);
//      inPosRangeBool = (inRangeBool && gtThan1);
//
//   } else if((resultIma120==0)||(resultIma240==0)||(resultSLOW==0)) {
//      // Print(" Variablity SLOW or 120");
//      inRangeBool = (notMean && notHalf);
//      inNegRangeBool = (inRangeBool && ltThanHalf);
//      inPosRangeBool = (inRangeBool && gtThanHalf);
//   }
   if((resultIma14 == 0) || (resultIma30 == 0) || (resultFAST == 0)) {
      //Print(" Variablity FAST or 14 or 5");
      inRangeBool = (notMean && notHalf && not1);
      inNegRangeBool = (inRangeBool && ltThan1);
      inPosRangeBool = (inRangeBool && gtThan1);
   } else if((resultIma120 == 0) || (resultMEDIUM == 0)) {
      // Print(" Variablity MEDIUM or 30");
      inRangeBool = (notMean && notHalf);
      inNegRangeBool = (inRangeBool && ltThanHalf);
      inPosRangeBool = (inRangeBool && gtThanHalf);
   } else if((resultIma240 == 0) || (resultSLOW == 0)) {
      // Print(" Variablity SLOW or 120");
      inRangeBool = (notMean);
      inNegRangeBool = (inRangeBool);
      inPosRangeBool = (inRangeBool);
   }
//Print("Variability signalll: "+getSigString(varSIG)+" mean: "+mean+" half: "+half+" notMean: "+notMean+" notHalf: "+notHalf+" ltThanHalf: "+ltThanHalf+" gtThanHalf: "+gtThanHalf+" inNegRangeBool: "+inNegRangeBool+" inPosRangeBool: "+inPosRangeBool);
   if(inNegRangeBool) {
      return -1.314;
   }
   if(inPosRangeBool) {
      return 1.314;
   }
   return 0.0;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::fileSizeCheck(string fileName, uint fileMiBSize = 20) {
//1Mb = 1,048,576 bytes
//20 Mb =  20971520 bytes
   const uint FILEBYTES = 1048576;
   int fileHandle = FileOpen(fileName, FILE_READ);
   if(fileHandle != INVALID_HANDLE) {
      int file_size = FileSize(fileHandle);
      if(file_size >= (FILEBYTES * fileMiBSize)) {
         return true;
      }
   } else {
      Print("Error opening file: ", GetLastError());
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::arrayToCSVString(const string &values[]) {
   string result = "";
   int size = ArraySize(values);
   for(int i = 0; i < size; i++) {
      result += values[i];
      if(i < size - 1) {
         result += ",";
      }
   }
   return result;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void     SanUtils::writeData(string name, string data) {
   int fileHandle = FileOpen(name, FILE_READ | FILE_WRITE | FILE_CSV);
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      // FileWrite(fileHandle, TimeToString(TimeCurrent()), 1.2345, 100);
      //FileWrite(fileHandle, data);
      FileWriteString(fileHandle, data + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //    Print("Data successfully appended to the file.");
   } else {
      Print("Failed to open file for appending.");
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeArrData(string filename, const double &values[], string order) {
   int fileHandle = FileOpen(filename, FILE_CSV | FILE_WRITE | FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      // FileWrite(fileHandle, TimeToString(TimeCurrent()), 1.2345, 100);
      //FileWrite(fileHandle, data);
      // Create comma-separated string
      string row = "";
      for(int i = 0; i < ArraySize(values); i++) {
         row += DoubleToString(values[i]);
         if(i < ArraySize(values) - 1) {
            row += ",";
         }
      }
      FileWrite(fileHandle, row + "," + order);
      //  FileWriteString(fileHandle, ","+order + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //   Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeHeaderData(string filename, const string &headerArr[]) {
   int fileHandle = FileOpen(filename, FILE_CSV | FILE_WRITE | FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      string row = "";
      for(int i = 0; i < ArraySize(headerArr); i++) {
         row += headerArr[i];
         if(i < ArraySize(headerArr) - 1) {
            row += ",";
         }
      }
      FileWrite(fileHandle, row);
      //  FileWriteString(fileHandle, ","+order + "\n");
      // Close the file to save changes
      FileClose(fileHandle);
      //   Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool    SanUtils::writeStructData(string filename, const INDDATA &indData, SAN_SIGNAL order, int shift = 1) {
   int fileHandle = FileOpen(filename, FILE_CSV | FILE_WRITE | FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
// const string headers[] = {"date-time","CurrencyPair","Time Frame","spread", "high", "open","close","low","volume","cp-stddev","rsi","MovingAvg5","MovingAvg14","MovingAvg30","MovingAvg60","MovingAvg120","MovingAvg240","MovingAvg500","ORDER"};
   const string headers[] = {"DateTime", "CurrencyPair", "TimeFrame", "Spread", "High", "Open", "Close", "Low", "Volume", "CpStdDev", "ATR", "RSI", "MovingAvg5", "MovingAvg14", "MovingAvg30", "MovingAvg60", "MovingAvg120", "MovingAvg240", "MovingAvg500", "ORDER" };
   string headerStr = arrayToCSVString(headers);
   if(fileHandle != INVALID_HANDLE) {
      //string firstLine = FileReadString(fileHandle);
      //// Extract first 9 bytes (characters)
      //string result = StringSubstr(firstLine, 0, 9);
      //Print(" First nine bytes: "+ result);
      if(FileIsEnding(fileHandle)) {
         FileWrite(fileHandle, headerStr);
      }
      FileSeek(fileHandle, 0, SEEK_END);
      // Create comma-separated string
      string row = "";
      //Print("Current period: "+getSymbolString(PERIOD_M1)+" Current Symbol "+ getSymbolString(0,Symbol()));
      row += TimeToString(indData.time[shift], TIME_DATE | TIME_MINUTES) + ",";
      row += getSymbolString(Symbol()) + "," + getSymbolString(PERIOD_M1) + ",";
      row += DoubleToString(indData.currSpread) + ",";
      row += DoubleToString(indData.high[shift]) + ",";
      row += DoubleToString(indData.open[shift]) + ",";
      row += DoubleToString(indData.close[shift]) + ",";
      row += DoubleToString(indData.low[shift]) + ",";
      row += DoubleToString(indData.tick_volume[shift]) + ",";
      row += DoubleToString(indData.std[shift]) + ",";
      row += DoubleToString(indData.atr[shift]) + ",";
      row += DoubleToString(indData.rsi[shift]) + ",";
      row += DoubleToString(indData.ima5[shift]) + ",";
      row += DoubleToString(indData.ima14[shift]) + ",";
      row += DoubleToString(indData.ima30[shift]) + ",";
      row += DoubleToString(indData.ima60[shift]) + ",";
      row += DoubleToString(indData.ima120[shift]) + ",";
      row += DoubleToString(indData.ima240[shift]) + ",";
      row += DoubleToString(indData.ima500[shift]);
      FileWrite(fileHandle, row + "," + getSigString(order));
      // Close the file to save changes
      FileClose(fileHandle);
      // Print("Data successfully appended to the file.");
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SanUtils::writeJsonData(string filename, const INDDATA &indData, SAN_SIGNAL order, int shift = 1) {
   int fileHandle = FileOpen(filename, FILE_CSV | FILE_WRITE | FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   const string headers[] = {"DateTime", "CurrencyPair", "TimeFrame", "Spread", "High", "Open", "Close", "Low", "Volume", "CpStdDev", "ATR", "RSI", "MovingAvg5", "MovingAvg14", "MovingAvg30", "MovingAvg60", "MovingAvg120", "MovingAvg240", "MovingAvg500", "ORDER"};
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      string row = "{";
      row += "\"" + headers[0] + "\":\"" + TimeToString(indData.time[shift], TIME_DATE | TIME_MINUTES) + "\",";
      row += "\"" + headers[1] + "\":\"" + getSymbolString(Symbol()) + "\",";
      row += "\"" + headers[2] + "\":\"" + getSymbolString(PERIOD_M1) + "\",";
      row += "\"" + headers[3] + "\":" + DoubleToString(indData.currSpread, 8) + ","; // No quotes for numeric
      row += "\"" + headers[4] + "\":" + DoubleToString(indData.high[shift], 8) + ",";
      row += "\"" + headers[5] + "\":" + DoubleToString(indData.open[shift], 8) + ",";
      row += "\"" + headers[6] + "\":" + DoubleToString(indData.close[shift], 8) + ",";
      row += "\"" + headers[7] + "\":" + DoubleToString(indData.low[shift], 8) + ",";
      row += "\"" + headers[8] + "\":" + DoubleToString(indData.tick_volume[shift], 8) + ",";
      row += "\"" + headers[9] + "\":" + DoubleToString(indData.std[shift], 8) + ",";
      row += "\"" + headers[10] + "\":" + DoubleToString(indData.atr[shift], 8) + ",";
      row += "\"" + headers[11] + "\":" + DoubleToString(indData.rsi[shift], 8) + ",";
      row += "\"" + headers[12] + "\":" + DoubleToString(indData.ima5[shift], 8) + ",";
      row += "\"" + headers[13] + "\":" + DoubleToString(indData.ima14[shift], 8) + ",";
      row += "\"" + headers[14] + "\":" + DoubleToString(indData.ima30[shift], 8) + ",";
      row += "\"" + headers[15] + "\":" + DoubleToString(indData.ima60[shift], 8) + ",";
      row += "\"" + headers[16] + "\":" + DoubleToString(indData.ima120[shift], 8) + ",";
      row += "\"" + headers[17] + "\":" + DoubleToString(indData.ima240[shift], 8) + ",";
      row += "\"" + headers[18] + "\":" + DoubleToString(indData.ima500[shift], 8) + ",";
      row += "\"" + headers[19] + "\":\"" + getSigString(order) + "\"}";
      FileWrite(fileHandle, row);
      FileClose(fileHandle);
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}


//+------------------------------------------------------------------+
//| Safe division with customizable handling of edge cases            |
//| Parameters:                                                      |
//|   val1: Numerator (e.g., slope of EMA30)                         |
//|   val2: Denominator (e.g., slope of EMA120)                      |
//|   normalizeDigits: Digits for normalization (default 4)           |
//|   zeroDivValue: Value to return when val2 is 0 (default DBL_MAX)  |
//| Returns:                                                         |
//|   Normalized division result, or specific value for edge cases    |
//+------------------------------------------------------------------+
double   SanUtils::SafeDiv(const double val1, const double val2, const int normalizeDigits = 4, const double zeroDivValue = DBL_MAX) {
   if (!MathIsValidNumber(val1) || !MathIsValidNumber(val2)) {
      Print("Invalid input: NaN detected");
      return EMPTY_VALUE;
   }
   if((val1 != 0) && (val2 != 0)) {
      return NormalizeDouble((val1 / val2), normalizeDigits);
   } else if(val1 == 0) {
      return 0.0;
   } else if(val2 == 0) {
      double result = val1 > 0 ? zeroDivValue : -zeroDivValue;
      Print("Division by zero: val1=", val1, ", returning ", result);
      return result;
   }
   return EMPTY_VALUE;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  SanUtils::getPriceInPips(const double price) {
   double pipVal = getPipValue(_Symbol);
   double spreadPips = MarketInfo(_Symbol, MODE_SPREAD) * 0.1; // Convert points to pips
//  double priceInPips = NormalizeDouble((price - spreadPips * pipVal) / pipVal, 2);
   double priceInPips = NormalizeDouble((price / pipVal), 2);
   Print("pipVal: ", pipVal, ", Symbol: ", _Symbol, ", Price in Pips: ", priceInPips);
   return priceInPips;
}


//+------------------------------------------------------------------+
//| Copy and Convert to Pips                                         |
//+------------------------------------------------------------------+
void SanUtils::transformAndCopyArraySlice(const double &source[], double &target[], int startIndex, int endIndex, double pipValue) {
   if(startIndex < 0 || endIndex >= ArraySize(source) || startIndex > endIndex) {
      Print("Invalid indices: startIndex=", startIndex, ", endIndex=", endIndex, ", ArraySize=", ArraySize(source));
      return;
   }
   int sliceSize = endIndex - startIndex + 1;
   ArrayResize(target, sliceSize);
   for(int i = 0; i < sliceSize; i++) {
      target[i] = source[startIndex + i] / pipValue; // Convert to pips
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SanUtils::copyArraySlice(const double &source[], double &target[], int startIndex, int endIndex) {
   int sliceSize = endIndex - startIndex + 1;
   ArrayCopy(target, source, 0, startIndex, sliceSize);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SanUtils::printArray(const double& arrVal[], string mainLabel, string loopLabel, int BEGIN = 0, int END = 8) {
   string printStr = "[ " + mainLabel + ": ] ";
   int SIZE = ArraySize(arrVal);
   if(SIZE < END)END = SIZE;
   for(int i = BEGIN; i < END; i++) {
      printStr += " " + loopLabel + "[" + i + "]: " + arrVal[i] + "";
   }
   return printStr;
}


SanUtils util;

//Stats stats(&util);
//Stats stats;


//+------------------------------------------------------------------+
