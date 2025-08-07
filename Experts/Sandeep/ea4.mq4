//+------------------------------------------------------------------+
//|                                                          ea4.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input ulong magicNumber = 1004; // MagicNumber
const int noOfCandles=21;
double stdDevVal[31];
string prntStr="";
string prntStrOpen=" {";
string prntStrClose=" }";
string JSONFILE = "NEWDATA.json";
//string JSONFILE = "NEWDATA_"+TimeToString(TimeCurrent(), TIME_DATE)+".json";
datetime lastMinute = 0;
uint spreadLimit=0;

struct DataTransport {
   double            matrixD[20];
   double            matrixD1[20];
   double            matrixD2[20];
   int               matrixI[20];
   int               matrixI1[20];
   int               matrixI2[20];
   bool              matrixBool[20];
   DataTransport() {
      ArrayInitialize(matrixD,EMPTY_VALUE);
      ArrayInitialize(matrixD1,EMPTY_VALUE);
      ArrayInitialize(matrixD2,EMPTY_VALUE);
      ArrayInitialize(matrixI,EMPTY);
      ArrayInitialize(matrixI1,EMPTY);
      ArrayInitialize(matrixI2,EMPTY);
      ArrayInitialize(matrixBool,EMPTY);
   }
   void freeData() {
      ArrayFree(matrixD);
      ArrayFree(matrixI);
      ArrayFree(matrixD1);
      ArrayFree(matrixI1);
      ArrayFree(matrixD2);
      ArrayFree(matrixI2);
      ArrayFree(matrixBool);
   }
   ~DataTransport() {
      freeData();
   }
};

struct INDDATA {
   double            open[500];
   double            high[70];
   double            low[70];
   double            close[500];
   datetime          time[70];
   double            tick_volume[500];
   double            volume[70];
   double            std[70];
   double            mfi[70];
   double            rsi[70];
   double            atr[70];
   double            adx[70];
   double            adxPlus[70];
   double            adxMinus[70];
   double            ima5[70];
   double            ima14[70];
   double            ima30[70];
   double            ima60[70];
   double            ima120[500];
   double            ima240[500];
   double            ima500[500];
   ulong             magicnumber;
   double            closeProfit; // Profit at which a trade is condsidered for closing. Also the same as take profit
   double            stopLoss; // Stop Loss
   double            currProfit; // The profit of the currently held trade
   double            maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
   int               tradePosition;
   int               currSpread;
   int               shift;


   void              freeData() {
      ArrayFree(open);
      ArrayFree(high);
      ArrayFree(low);
      ArrayFree(close);
      ArrayFree(time);
      ArrayFree(tick_volume);
      ArrayFree(volume);
      ArrayFree(std);
      ArrayFree(mfi);
      ArrayFree(atr);
      ArrayFree(adx);
      ArrayFree(adxPlus);
      ArrayFree(adxMinus);
      ArrayFree(ima5);
      ArrayFree(ima14);
      ArrayFree(ima30);
      ArrayFree(ima60);
      ArrayFree(ima120);
      ArrayFree(ima240);
      ArrayFree(ima500);
      magicnumber=NULL;
      closeProfit=NULL;
      stopLoss=NULL;
      currProfit=NULL;
      maxProfit=NULL;
      shift=NULL;
      currSpread = EMPTY;
      tradePosition=EMPTY;
   }
   INDDATA() {}
   ~INDDATA() {
      freeData();
   }
};

INDDATA indData;

enum SAN_SIGNAL {
   BUY=1000,
   SELL=2000,
   HOLD=3000,
   OPEN=4000,
   CLOSE=5000,
   CLOSEBUY=5001,
   CLOSESELL=5002,
   TRADE=6000,
   TRADEBUY=6001,
   TRADESELL=6002,
   NOTRADE=7000,
   REVERSETRADE=8000,
   SIDEWAYS=9000,
   NOSIG=-1000314,
//NOSIG=EMPTY,
};

SAN_SIGNAL TRADESIG = SAN_SIGNAL::NOSIG;

SAN_SIGNAL     getCurrTradePosition() {

   SAN_SIGNAL tradePosition = SAN_SIGNAL::NOSIG;

   int totalOrders=OrdersTotal();
   if(totalOrders>0) {
      for(int i=0; i<totalOrders; i++) {
         if(OrderSelect(i,SELECT_BY_POS)) {
            if(OrderType()==OP_BUY)
               tradePosition=SAN_SIGNAL::BUY;
            if(OrderType()==OP_SELL)
               tradePosition=SAN_SIGNAL::SELL;
            if((OrderType()!=OP_SELL)&&(OrderType()!=OP_BUY)&&(OrderType()!=OP_SELLLIMIT)&&(OrderType()!=OP_BUYLIMIT)&&(OrderType()!=OP_SELLSTOP)&&(OrderType()!=OP_BUYSTOP))
               tradePosition=SAN_SIGNAL::NOSIG;
         }
      }
   }
   return tradePosition;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool oppSignal(SAN_SIGNAL sig1, SAN_SIGNAL sig2) {
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
string getSigString(double sig) {
   if(sig==EMPTY) {
      return "EMPTY";
   }
   if(sig==SAN_SIGNAL::BUY) {
      return "BUY";
   }
   if(sig==SAN_SIGNAL::SELL) {
      return "SELL";
   }
   if(sig==SAN_SIGNAL::HOLD) {
      return "HOLD";
   }
   if(sig==SAN_SIGNAL::OPEN) {
      return "OPEN";
   }
   if(sig==SAN_SIGNAL::CLOSE) {
      return "CLOSE";
   }
   if(sig==SAN_SIGNAL::CLOSEBUY) {
      return "CLOSEBUY";
   }
   if(sig==SAN_SIGNAL::CLOSESELL) {
      return "CLOSESELL";
   }
   if(sig==SAN_SIGNAL::TRADE) {
      return "TRADE";
   }
   if(sig==SAN_SIGNAL::NOTRADE) {
      return "NOTRADE";
   }
   if(sig==SAN_SIGNAL::REVERSETRADE) {
      return "REVERSETRADE";
   }
   if(sig==SAN_SIGNAL::SIDEWAYS) {
      return "SIDEWAYS";
   }
   if(sig==SAN_SIGNAL::NOSIG) {
      return "NOSIG";
   }

   return "NOSIG";
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string getSymbolString(string symbol) {


   if(StrToInteger(symbol)==PERIOD_M1) {
      return "1 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_M5) {
      return "5 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_M15) {
      return "15 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_M30) {
      return "30 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_H1) {
      return "60 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_H4) {
      return "240 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_D1) {
      return "1440 Minutes";
   }
   if(StrToInteger(symbol)==PERIOD_W1) {
      return "10080 Minutes";
   }

   if(symbol==Symbol()) {
      int pos = StringFind(symbol,".");
      if(pos>0) {
         return StringSubstr(symbol,0,pos);
      }
      return symbol;
   }

   if((symbol=="")||(StrToInteger(symbol)==EMPTY)) {
      return "NOSYMBOL";
   }

   return "NOSYMBOL";
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool writeOHLCVJsonData(string filename, string data) {
   int fileHandle = FileOpen(filename, FILE_CSV|FILE_WRITE|FILE_READ);
   if(fileHandle == INVALID_HANDLE) {
      Print("Error opening file: ", GetLastError());
      return false;
   }
   if(fileHandle != INVALID_HANDLE) {
      FileSeek(fileHandle, 0, SEEK_END);
      FileWrite(fileHandle, data);
      FileClose(fileHandle);
      return true;
   } else {
      Print("Failed to open file for appending.");
      return false;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   slopeVal(
   const double &sig[],
   const int SLOPEDENOM=3,
   const int SLOPEDENOM_WIDE=5,
   const int shift=1
) {

   DataTransport dt;
   double tPoint = Point;
   dt.matrixD[0] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
   dt.matrixD[1] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM_WIDE])/(SLOPEDENOM_WIDE*tPoint)),3);
   return dt;
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   slopeFastMediumSlow(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int SLOPEDENOM=3,
   const int SLOPEDENOM_WIDE=5,
   const int shift=1
) {

   DataTransport dt;
   double tPoint = Point;
   dt.matrixD[0] = NormalizeDouble(((fast[shift]-fast[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
   dt.matrixD[1] = NormalizeDouble(((medium[shift]-medium[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
   dt.matrixD[2] = NormalizeDouble(((slow[shift]-slow[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
   dt.matrixD[3] = NormalizeDouble(((slow[shift]-slow[SLOPEDENOM_WIDE])/(SLOPEDENOM_WIDE*tPoint)),3);
   return dt;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport     getSlopeRatioData(
   const DataTransport &fast,
   const DataTransport &medium,
   const DataTransport &slow
) {

   double fastSlope=0;
   double mediumSlope=0;
   double slowSlope=0;
   double slowSlopeWide=0;

   double fMR=0;
   double mSR=0;
   double mSWR=0;
   double fSR=0;
   double fSWR=0;
   double fMSR = 0;
   double fMSWR = 0;

   //DataTransport slopesData = slopeFastMediumSlow(fast,medium,slow,SLOPEDENOM,SLOPEDENOM_WIDE,shift);

   DataTransport dt;
   fastSlope = fast.matrixD[0];
   mediumSlope = medium.matrixD[0];
   slowSlope = slow.matrixD[0];
   slowSlopeWide = slow.matrixD[1];

   fMR = ((fastSlope!=0)&&(mediumSlope!=0))?NormalizeDouble((fastSlope/mediumSlope),4):EMPTY_VALUE;
   mSR = ((mediumSlope!=0)&&(slowSlope!=0))?NormalizeDouble((mediumSlope/slowSlope),4):EMPTY_VALUE;
   mSWR = ((mediumSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((mediumSlope/slowSlopeWide),4):EMPTY_VALUE;
   fSR = ((fastSlope!=0)&&(slowSlope!=0))?NormalizeDouble((fastSlope/slowSlope),4):EMPTY_VALUE;
   fSWR = ((fastSlope!=0)&&(slowSlopeWide!=0))?NormalizeDouble((fastSlope/slowSlopeWide),4):EMPTY_VALUE;
   fMSR = ((fMR!=0)&&(mSR!=0)&&(fMR!=EMPTY_VALUE)&&(mSR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSR),4):EMPTY_VALUE;
   fMSWR = ((fMR!=0)&&(mSWR!=0)&&(fMR!=EMPTY_VALUE)&&(mSWR!=EMPTY_VALUE))?NormalizeDouble((fMR/mSWR),4):EMPTY_VALUE;

//   Print("[SLOPESRATIO] fMR: "+fMR+" mSR: "+mSR+" mSWR: "+mSWR+" fSR: "+fSR+" fSWR: "+fSWR+" fMSR: "+fMSR+" fMSWR: "+fMSWR);
   dt.matrixD[0]=fMSR;
   dt.matrixD[1]=fMSWR;
   dt.matrixD[2]=fMR;
   dt.matrixD[3]=mSR;
   dt.matrixD[4]=mSWR;

   return dt;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport clusterSIG(const double fast,const double medium,const double slow=0) {
   DataTransport dt;
   int fastInt = fast;
   int mediumInt = medium;
   int slowInt = slow;
   double rFM = (fast/medium);
   double rMS = (medium/slow);
   double rFS = (fast/slow);
   double rDFM = fabs(fast-medium)/fabs((fast+medium)/2);
   double rDMS = fabs(medium-slow)/fabs((medium+slow)/2);
   double rDFS = fabs(fast-slow)/fabs((fast+slow)/2);


   if(fastInt==mediumInt) {
      rFM = ((fast-fastInt)/(medium-mediumInt));
   } else if(fastInt>mediumInt) {
      rFM = ((fast-mediumInt)/(medium-mediumInt));
   } else if(fastInt<mediumInt) {
      //rFM = ((fast-fastInt)/(medium-fastInt));
      rFM = -1*((medium-fastInt)/(fast-fastInt));
   }


   if(mediumInt==slowInt) {
      rMS = ((medium-mediumInt)/(slow-slowInt));
   } else if(mediumInt>slowInt) {
      rMS = ((medium-slowInt)/(slow-slowInt));
   } else if(mediumInt<slowInt) {
      // rMS = ((medium-mediumInt)/(slow-mediumInt));
      rMS = -1*((slow-mediumInt)/(medium-mediumInt));
   }

   if(fastInt==slowInt) {
      rFS = ((fast-fastInt)/(slow-slowInt));
   } else if(fastInt>slowInt) {
      rFS = ((fast-slowInt)/(slow-slowInt));
   } else if(fastInt<slowInt) {
      rFS = -1*((slow-fastInt)/(fast-fastInt));
   }
//   double gt=EMPTY_VALUE;
//   gt = (rFM>rMS)?rFM:rMS;
//   gt = (gt>rFS)?gt:rFS;

   double v1 = NormalizeDouble(((fastInt==mediumInt)?(fast-fastInt):((fastInt>mediumInt)?(fast-mediumInt):((fastInt<mediumInt)?(-1*(fast-fastInt)):EMPTY_VALUE))),4);
   double v2 = NormalizeDouble(((mediumInt==slowInt)?(medium-mediumInt):((mediumInt>slowInt)?(medium-slowInt):((mediumInt<slowInt)?(-1*(medium-mediumInt)):EMPTY_VALUE))),4);
   double v3 = NormalizeDouble(((fastInt==slowInt)?(slow-slowInt):((fastInt>slowInt)?(slow-slowInt):((fastInt<slowInt)?(-1*(slow-fastInt)):EMPTY_VALUE))),4);

//Print("[CLUSTER] ratios: rFM: "+NormalizeDouble(rFM,4)+" rMS: "+NormalizeDouble(rMS,4)+" rFS: "+NormalizeDouble(rFS,4));
//      +" fastInt: "+ fastInt+" mediumInt: "+ mediumInt+" slowInt: "+slowInt
//      +" fast: "+ v1
//      +" medium: "+ v2
//      +" slow: "+v3);

   dt.matrixD[0] =  NormalizeDouble(rFM,6);
   dt.matrixD[1] =  NormalizeDouble(rMS,6);
   dt.matrixD[2] =  NormalizeDouble(rFS,6);
//return NormalizeDouble(rFM,6);
   return dt;

}
//+------------------------------------------------------------------+
//| When the fast signal moves over slow signal
// it is a buy and when a fast signal dives below a slow signal then it is a sell
// signal                                                      |
//+------------------------------------------------------------------+
SAN_SIGNAL fastSlowSIG(
   const double fastSig,
   const double slowSig,
   const int factor=10
) {
   const double upperFACTOR = 1+(factor/100);
   const double lowerFACTOR = 1-(factor/100);

   if((fastSig >= (lowerFACTOR*slowSig))&&(fastSig <= (upperFACTOR*slowSig)))
      return SAN_SIGNAL::SIDEWAYS;
   if(fastSig > (upperFACTOR*slowSig))
      return SAN_SIGNAL::BUY;
   if(fastSig < (lowerFACTOR*slowSig))
      return SAN_SIGNAL::SELL;
   return SAN_SIGNAL::NOSIG;
}

SAN_SIGNAL  getSlopeSIG(const DataTransport& signalDt, const int signalType=0) {

   if(signalType==0) {
      if((signalDt.matrixD[0]>=-0.3)&&(signalDt.matrixD[0]<=0.3)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.4)&&(signalDt.matrixD[0]<=0.4)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.4)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.4)return SAN_SIGNAL::SELL;
   } else if(signalType==1) {
      if((signalDt.matrixD[0]>=-0.2)&&(signalDt.matrixD[0]<=0.2)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.3)&&(signalDt.matrixD[0]<=0.3)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.3)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.3)return SAN_SIGNAL::SELL;
   } else if(signalType==2) {
      if((signalDt.matrixD[0]>=-0.1)&&(signalDt.matrixD[0]<=0.1)) return SAN_SIGNAL::CLOSE;
      if((signalDt.matrixD[0]>=-0.2)&&(signalDt.matrixD[0]<=0.2)) return SAN_SIGNAL::SIDEWAYS;
      if(signalDt.matrixD[0]>0.2)return SAN_SIGNAL::BUY;
      if(signalDt.matrixD[0]<-0.2)return SAN_SIGNAL::SELL;
   }
   return SAN_SIGNAL::NOSIG;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool getMktCloseOnVariableSlope(const DataTransport& imaSlopesData,const INDDATA& indData,const int SHIFT=1) {
   // slopes of 30,120,240 ma curves
   SAN_SIGNAL tradePosition = getCurrTradePosition();

   // Ver-1: [5->5.0, 14->4.0,30->1.8,120->1.2,240=0.6]
   // Ver-2: [5->2.0, 14->1.0,30->0.5,120->0.2,240=0.08]
   // Ver-3: [5->4.0, 14->3.0,30->1.8,120->1.6,240=1.0]
   // Ver-4: [5->3.0, 14->2.5,30->1.0,120->0.8,240=0.4]
   // Ver-5: [5->3.0, 14->2.2,30->1.8,120->1.2,240=0.6]
   // Ver-6: [5->2.5, 14->1.5,30->0.8,120->0.6,240=0.2]
   // Ver-7: [5->2.5, 14->1.5,30->0.8,120->0.2,240=0.08]
   // Ver-8: [5->4.0, 14->1.5,30->0.8,120->0.2,240=0.08]
   // Ver-9: [fsig5->4.0, fsig14->2.0,fsig30->0.8,fsig120->0.2,fsig240=0.08]


   // Slopes for signals fsig5 and fsig14 are effectively outliers and not being captured.
   // The main signal is based only on fsig30, fsig120 and fsig240. ideally the close on fsig5 and fsgi14 should not be activated.
   // However they may be activated for very high slopes effectively disabling in that sense.
   // Caution: a low slope values for fsig5 and fsig14 creates runaway trades leading to signnificant losses within a very short amount of time
   // on account of false trade open and close signals.
   const double SLOPEGRADS[5] = {4.0,2.0,0.8,0.2,0.08}; // eventually an external param from function

   const double SLOPE_5=SLOPEGRADS[0];  //4.0;
   const double SLOPE_14= SLOPEGRADS[1]; //2.0;
   const double SLOPE_30=SLOPEGRADS[2]; //0.8;
   const double SLOPE_120=SLOPEGRADS[3]; //0.2;
   const double SLOPE_240=SLOPEGRADS[4]; //0.08;

   bool closeBool = false;
   static SAN_SIGNAL CLOSESIGNAL = SAN_SIGNAL::NOSIG;

   if(fabs(imaSlopesData.matrixD[0])> SLOPE_5) {
      CLOSESIGNAL=fastSlowSIG(indData.close[SHIFT], indData.ima5[SHIFT],21);
      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig5,tradePosition))");
   } else if(fabs(imaSlopesData.matrixD[0])>=SLOPE_14) {
      CLOSESIGNAL=fastSlowSIG(indData.close[SHIFT], indData.ima14[SHIFT],21);;
      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig14,tradePosition))");
   } else if(fabs(imaSlopesData.matrixD[0])>=SLOPE_30) {
      CLOSESIGNAL=fastSlowSIG(indData.close[SHIFT], indData.ima30[SHIFT],21);
      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig30,tradePosition))");
   } else if(fabs(imaSlopesData.matrixD[0])>=SLOPE_120) {
      CLOSESIGNAL=fastSlowSIG(indData.close[SHIFT], indData.ima120[SHIFT],21);
      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig120,tradePosition))");
   } else if(fabs(imaSlopesData.matrixD[0])>=SLOPE_240) {
      CLOSESIGNAL=fastSlowSIG(indData.close[SHIFT], indData.ima240[SHIFT],21);
      Print("[SIGCLOSE]: Close on (util.oppSignal(ss.fsig240,tradePosition))");
   }

   closeBool= (CLOSESIGNAL!=SAN_SIGNAL::NOSIG)?(oppSignal(CLOSESIGNAL,tradePosition)):false;
   if(closeBool)CLOSESIGNAL=SAN_SIGNAL::NOSIG;
   return closeBool;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setSpreadLimit(uint& spreadLimit) {
   if(_Period <PERIOD_M15) {
      spreadLimit = 20;
   } else if(_Period <=PERIOD_M30) {
      spreadLimit = 40;
   } else if(_Period <=PERIOD_H1) {
      spreadLimit = 60;
   } else if(_Period <=PERIOD_D1) {
      spreadLimit = 80;
   }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//---
   EventSetTimer(60);
   setSpreadLimit(spreadLimit);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
   EventKillTimer();
   indData.freeData();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//void OnTick()
void OnTimer() {


   prntStr="";
   setSpreadLimit(spreadLimit);

   for(int i=0; i<noOfCandles; i++) {

      indData.std[i]= iStdDev(_Symbol,PERIOD_CURRENT,noOfCandles,0,MODE_EMA,PRICE_CLOSE,i);
      indData.mfi[i]= iMFI(_Symbol,PERIOD_CURRENT, noOfCandles,i);
      indData.rsi[i]= iRSI(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_WEIGHTED,i);
      indData.atr[i] = iATR(_Symbol,PERIOD_CURRENT,noOfCandles,i);
      indData.adx[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MAIN,i);
      indData.adxPlus[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_PLUSDI,i);
      indData.adxMinus[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MINUSDI,i);
      indData.ima5[i]= iMA(_Symbol,PERIOD_CURRENT,5,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima14[i]= iMA(_Symbol,PERIOD_CURRENT,14,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima30[i]= iMA(_Symbol,PERIOD_CURRENT,30,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima60[i]= iMA(_Symbol,PERIOD_CURRENT,60,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima120[i]= iMA(_Symbol,PERIOD_CURRENT,120,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima240[i]= iMA(_Symbol,PERIOD_CURRENT,240,0,MODE_SMMA, PRICE_CLOSE,i);
      indData.ima500[i]= iMA(_Symbol,PERIOD_CURRENT,500,0,MODE_SMMA, PRICE_CLOSE,i);
   }

   DataTransport dt14 = slopeVal(indData.ima14,5,21,1);
   DataTransport dt30 = slopeVal(indData.ima30,5,21,1);
   DataTransport dt120 = slopeVal(indData.ima120,5,21,1);
   DataTransport dt240 = slopeVal(indData.ima240,5,21,1);
   DataTransport dt500 = slopeVal(indData.ima500,5,21,1);
   DataTransport stdCPSlope = slopeVal(indData.std,5,21,1);
   DataTransport clusterData = clusterSIG(indData.ima30[1],indData.ima120[1],indData.ima240[1]);
   DataTransport slopeRatioData = getSlopeRatioData(dt30,dt120,dt240);
      
   TRADESIG = ((int)MarketInfo(_Symbol,MODE_SPREAD)<spreadLimit)?
              getSlopeSIG(dt30,0)
              :
              SAN_SIGNAL::NOTRADE;

   prntStr += prntStrOpen;

   //{"DateTime","CurrencyPair","TimeFrame","Spread","High","Open","Close","Low","Volume","CpStdDev","ATR","RSI","MovingAvg5","MovingAvg14","MovingAvg30","MovingAvg60","MovingAvg120","MovingAvg240","MovingAvg500","ORDER"}

   prntStr += " \"DateTime\":\""+(TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES))+"\",";
   prntStr += " \"CurrencyPair\":\""+getSymbolString(Symbol())+"\",";
   prntStr += " \"TimeFrame\":\""+getSymbolString(Period())+"\",";
   prntStr += " \"Spread\":"+(int)MarketInfo(_Symbol,MODE_SPREAD)+",";
   prntStr += " \"Open\":"+DoubleToString(Open[1],8)+",";
   prntStr += " \"High\":"+DoubleToString(High[1],8)+",";
   prntStr += " \"Low\":"+DoubleToString(Low[1],8)+",";
   prntStr += " \"Close\":"+DoubleToString(Close[1],8)+",";
   prntStr += " \"Volume\":"+DoubleToString(Volume[1],8)+",";
   prntStr += " \"StdDevCp\":"+DoubleToString(indData.std[1],8)+",";
   prntStr += " \"ATR\":"+DoubleToString(indData.atr[1],8)+",";
   prntStr += " \"RSI\":"+DoubleToString(indData.rsi[1],8)+",";

   prntStr += " \"SlopeIMA14\":"+DoubleToString(dt14.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA30\":"+DoubleToString(dt30.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA120\":"+DoubleToString(dt120.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA240\":"+DoubleToString(dt240.matrixD[0],8)+",";
   prntStr += " \"SlopeIMA500\":"+DoubleToString(dt500.matrixD[0],8)+",";
   prntStr += " \"STDSlope\":"+DoubleToString(stdCPSlope.matrixD[0],8)+",";
   prntStr += " \"RFM\":"+DoubleToString(clusterData.matrixD[0],8)+",";
   prntStr += " \"RMS\":"+DoubleToString(clusterData.matrixD[1],8)+",";
   prntStr += " \"RFS\":"+DoubleToString(clusterData.matrixD[2],8)+",";
   prntStr += " \"fMSR\":"+DoubleToString(slopeRatioData.matrixD[0],8)+",";
   prntStr += " \"fMSWR\":"+DoubleToString(slopeRatioData.matrixD[1],8)+",";

   prntStr += " \"MovingAvg5\":"+DoubleToString(indData.ima5[1],8)+",";
   prntStr += " \"MovingAvg14\":"+DoubleToString(indData.ima14[1],8)+",";
   prntStr += " \"MovingAvg30\":"+DoubleToString(indData.ima30[1],8)+",";
   prntStr += " \"MovingAvg60\":"+DoubleToString(indData.ima60[1],8)+",";
   prntStr += " \"MovingAvg120\":"+DoubleToString(indData.ima120[1],8)+",";
   prntStr += " \"MovingAvg240\":"+DoubleToString(indData.ima240[1],8)+",";
   prntStr += " \"MovingAvg500\":"+DoubleToString(indData.ima500[1],8)+",";
   prntStr += " \"ORDER\":\""+getSigString(TRADESIG)+"\"";

   prntStr += prntStrClose;

   datetime currentTime = TimeCurrent();
   datetime currentMinute = currentTime - (currentTime % 60);
   //if(min1!=TimeMinute(currentTime)){
   //  min1 = TimeMinute(currentTime);
   //  Print(" +Min:"+min1+" Now do your thing");
   //}
   if (currentMinute != lastMinute) {
      // Update the last processed minute
      lastMinute = currentMinute;
      writeOHLCVJsonData(JSONFILE,prntStr);
      Print(prntStr);
   }


//---
}
//+------------------------------------------------------------------+
