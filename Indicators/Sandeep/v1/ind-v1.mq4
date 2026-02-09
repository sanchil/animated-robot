//+------------------------------------------------------------------+
//|                                                        ind-1.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_plots 0
#property indicator_buffers 3
#include <Sandeep/v1/SanStrategies-v1.mqh>

// This seq of inputs stated here must match the parameters entered for the indicator function used in EA
input ulong magicNumber;
input int noOfCandles;
input double stopLoss; // Loss at which a trade is condsidered for closing.
input double closeProfit; // Profit at which a trade is condsidered for closing.
input double currProfit; // The profit of the currently held trade
input double maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
input bool recordData; // begin recording data for vector database for a RAG AI application.
//input int recordFreqInMinutes; // Record after the mentioned period. Default is record once every minute.
input SAN_SIGNAL recordSignal; // This is the default signal recorded for vector database for a RAG AI application.
input string dataFileName;// This is the default signal data file name recorded for vector database for a RAG AI application.
input bool flipSig; // flips signals. BUY is SELL and SELL is BUY.

input int BarsHeld; // no of bars held;
// Lot size = 0.01. 
// 1 Microlot = 1*0.01=0.01, 10 Microlots = 10*0.01 = 0.1, 100 Microlots = 1,
input double microLots; // Micro Lots
const int SHIFT = 1;

//int recordFreq = _Period;
//int currentRecordTime = 0;
//int lastRecordTime = -1;



double buff1[];
double buff2[];
double buff3[];
//double buff4[];
//double buff5[];
//double buff6[];


INDDATA indData;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   ArrayInitialize(buff1, EMPTY);
   ArrayInitialize(buff2, EMPTY);
   ArrayInitialize(buff3, EMPTY);
//ArrayInitialize(buff4,EMPTY);
//ArrayInitialize(buff5,EMPTY);
//ArrayInitialize(buff6,EMPTY);
//--- indicator buffers mapping
   ArraySetAsSeries(buff1, true);
   ArraySetAsSeries(buff2, true);
   ArraySetAsSeries(buff3, true);
//ArraySetAsSeries(buff4,true);
//ArraySetAsSeries(buff5,true);
//ArraySetAsSeries(buff6,true);
   SetIndexBuffer(0, buff1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(1, buff2, INDICATOR_CALCULATIONS);
   SetIndexBuffer(2, buff3, INDICATOR_CALCULATIONS);
//SetIndexBuffer(3,buff4,INDICATOR_CALCULATIONS);
//SetIndexBuffer(4,buff5,INDICATOR_CALCULATIONS);
//SetIndexBuffer(5,buff6,INDICATOR_CALCULATIONS);
//---
   return(INIT_SUCCEEDED);
}



/**
//+------------------------------------------------------------------+
//| Custom indicator iteration function.
//  Switched to if block. This was suggested by grok over a while loop
//  that I was trying to implement without modifying the i var based on which
// the while loop iterated. The code failed to execute because of compiler optimization
// leading to a hard to figure out behaviour of code. A simple if block fixed the issue.
//                               |
//+------------------------------------------------------------------+
*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
   indData.freeData();
   indData.magicnumber = magicNumber;
   indData.stopLoss = stopLoss;
   indData.currProfit = currProfit;
   indData.closeProfit = closeProfit;
   indData.maxProfit = maxProfit;
   indData.shift = SHIFT;
   indData.BarsHeld = BarsHeld;
   indData.microLots = microLots;
   
   indData.currSpread = (int)MarketInfo(_Symbol, MODE_SPREAD);
   int i = rates_total - prev_calculated - 1;
   if(i < 0)
      i = 0;
   if(i >= 0) {
      for(int j = 0; j < 31; j++) {
         indData.high[j] = high[j];
         indData.low[j] = low[j];
         indData.time[j] = time[j];
         indData.std[j] = iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_CLOSE, j);
         indData.stdOpen[j] = iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_OPEN, j);
         indData.obv[j] = iOBV(_Symbol, PERIOD_CURRENT, PRICE_CLOSE, j);
         indData.rsi[j] = iRSI(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_WEIGHTED, j);
         indData.ima5[j] = iMA(_Symbol, PERIOD_CURRENT, 5, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.ima14[j] = iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.ima30[j] = iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.ima60[j] = iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.atr[j] = iATR(_Symbol, PERIOD_CURRENT, noOfCandles, j);
         //indData.adx[j] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,MODE_MAIN,j);
         //indData.adxPlus[j] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,1,j);
         //indData.adxMinus[j] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,2,j);
         if(GetLastError() != 0) {
            Print("Error in first loop at j = ", j, ": ", GetLastError());
            return(0);
         }
      }
      for(int j = 0; j < 201; j++) {
         indData.open[j] = open[j];
         indData.close[j] = close[j];
         indData.tick_volume[j] = tick_volume[j];
         indData.ima120[j] = iMA(_Symbol, PERIOD_CURRENT, 120, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.ima240[j] = iMA(_Symbol, PERIOD_CURRENT, 240, 0, MODE_SMMA, PRICE_CLOSE, j);
         indData.ima500[j] = iMA(_Symbol, PERIOD_CURRENT, 500, 0, MODE_SMMA, PRICE_CLOSE, j);
         if(GetLastError() != 0) {
            Print("Error in second loop at j = ", j, ": ", GetLastError());
            return(0);
         }
      }
      initCalc(indData);
      buff1[0] = buff1[0]; // Force buffer update
   }
   return(rates_total);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initCalc(const INDDATA &indData) {
//   Print("initCalc called"); // Debug
   buff1[0] = buySell(indData);
   if (recordData && util.isNewBarTime()) {
      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);
   }
   buff1[0] = buff1[0]; // Dummy write to force buffer update
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double buySell(const INDDATA &indData) {
   SIGBUFF sbuff = st1.imaSt1(indData);
//   Print("buySell: sbuff.buff1[0] = ", sbuff.buff1[0], ", buff2[0] = ", sbuff.buff2[0], ", buff3[0] = ", sbuff.buff3[0]); // Debug
   if((sbuff.buff2[0] != EMPTY) && (sbuff.buff2[0] != EMPTY_VALUE) && (sbuff.buff2[0] != NULL)) {
      //buff2[0] = sbuff.buff2[0];
      if(!flipSig) {
         buff2[0] = sbuff.buff2[0];
      } else if(flipSig) {
         buff2[0] = util.flipSig((SAN_SIGNAL)sbuff.buff2[0]);
      }
   } else {
      buff2[0] = EMPTY_VALUE;
   }
   if((sbuff.buff3[0] != EMPTY) && (sbuff.buff3[0] != EMPTY_VALUE) && (sbuff.buff3[0] != NULL)) {
      buff3[0] = sbuff.buff3[0];
   } else {
      buff3[0] = EMPTY_VALUE;
   }
//if((sbuff.buff4[0]!=EMPTY) && (sbuff.buff4[0]!=EMPTY_VALUE) && (sbuff.buff4[0]!=NULL)) {
//   // Setting Market type. Trending or flat
//   buff4[0] = sbuff.buff4[0];
//} else {
//   buff4[0] = EMPTY_VALUE;
//}
   if(((sbuff.buff1[0] == EMPTY) || (sbuff.buff1[0] == EMPTY_VALUE) || (sbuff.buff1[0] == NULL))) {
      //sbuff.buff1[0]=1000.314;
      sbuff.buff1[0] = EMPTY_VALUE;
      return sbuff.buff1[0];
   }
   if((sbuff.buff1[0] != EMPTY) && (sbuff.buff1[0] != EMPTY_VALUE) && (sbuff.buff1[0] != NULL)) {
      if(!flipSig) {
         return sbuff.buff1[0];
      } else if(flipSig) {
         sbuff.buff1[0] = util.flipSig((SAN_SIGNAL)sbuff.buff1[0]);
         return  sbuff.buff1[0];
      }
   }
   return sbuff.buff1[0];
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool calculateNow(const int rates_total,
                  const int prev_calculated) {
   int i = rates_total - prev_calculated - 1;
   if(i < 0)
      i = 0;
   while(i >= 0)
      return true;
   return false;
}
//+------------------------------------------------------------------+
