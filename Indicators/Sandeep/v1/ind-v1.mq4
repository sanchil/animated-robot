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
#property indicator_buffers 5
#include <Sandeep/v1/SanStrategies-v1.mqh>

// This seq of inputs stated here must match the parameters entered for the indicator function used in EA
input ulong magicNumber;
input int noOfCandles;
input double stopLoss; // Loss at which a trade is condsidered for closing.
input double closeProfit; // Profit at which a trade is condsidered for closing.
input double currProfit; // The profit of the currently held trade
input double maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
input bool recordData; // begin recording data for vector database for a RAG AI application.
input SAN_SIGNAL recordSignal; // This is the default signal recorded for vector database for a RAG AI application.
input string dataFileName;// This is the default signal data file name recorded for vector database for a RAG AI application.
input bool flipSig; // flips signals. BUY is SELL and SELL is BUY.


const int SHIFT = 1;
datetime lastMinute = 0;


double buff1[];
double buff2[];
double buff3[];
double buff4[];
double buff5[];
double buff6[];


INDDATA indData;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

   ArrayInitialize(buff1,EMPTY);
   ArrayInitialize(buff2,EMPTY);
   ArrayInitialize(buff3,EMPTY);
   ArrayInitialize(buff4,EMPTY);
   ArrayInitialize(buff5,EMPTY);
   ArrayInitialize(buff6,EMPTY);


//--- indicator buffers mapping
   ArraySetAsSeries(buff1,true);
   ArraySetAsSeries(buff2,true);
   ArraySetAsSeries(buff3,true);
   ArraySetAsSeries(buff4,true);
   ArraySetAsSeries(buff5,true);
   ArraySetAsSeries(buff6,true);

   SetIndexBuffer(0,buff1,INDICATOR_CALCULATIONS);
   SetIndexBuffer(1,buff2,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,buff3,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,buff4,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,buff5,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,buff6,INDICATOR_CALCULATIONS);

//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---

//ArraySetAsSeries(time,true);
//ArraySetAsSeries(open,true);
//ArraySetAsSeries(high,true);
//ArraySetAsSeries(low,true);
//ArraySetAsSeries(close,true);
//ArraySetAsSeries(tick_volume,true);
//ArraySetAsSeries(volume,true);
//ArraySetAsSeries(spread,true);
   indData.freeData();
   indData.magicnumber = magicNumber;
   indData.stopLoss = stopLoss;
   indData.currProfit = currProfit;
   indData.closeProfit = closeProfit;
   indData.maxProfit = maxProfit;
   indData.shift = SHIFT;
   indData.currSpread = (int)MarketInfo(_Symbol,MODE_SPREAD);

//   Print("Spread in indicator: "+(int)MarketInfo(_Symbol,MODE_SPREAD));

//if(rates_total>prev_calculated)
   for(int i = prev_calculated; i < rates_total; i++) {



      for(int i=0; i<31; i++) {
         //indData.open[i] = open[i];
         indData.high[i] = high[i];
         indData.low[i] = low[i];
         //indData.close[i] = close[i];
         indData.time[i] = time[i];
         //indData.tick_volume[i]=tick_volume[i];
         indData.volume[i] = iVolume(_Symbol,PERIOD_CURRENT,i);
         indData.std[i]= iStdDev(_Symbol,PERIOD_CURRENT,noOfCandles,0,MODE_EMA,PRICE_CLOSE,i);
         indData.mfi[i]= iMFI(_Symbol,PERIOD_CURRENT, noOfCandles,i);
         indData.rsi[i]= iRSI(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_WEIGHTED,i);
         indData.adx[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MAIN,i);
         indData.adxPlus[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_PLUSDI,i);
         indData.adxMinus[i]=iADX(_Symbol,PERIOD_CURRENT,noOfCandles, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MINUSDI,i);
         indData.ima5[i]= iMA(_Symbol,PERIOD_CURRENT,5,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.ima14[i]= iMA(_Symbol,PERIOD_CURRENT,14,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.ima30[i]= iMA(_Symbol,PERIOD_CURRENT,30,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.ima60[i]= iMA(_Symbol,PERIOD_CURRENT,60,0,MODE_SMMA, PRICE_CLOSE,i);
         //         indData.ima120[i]= iMA(_Symbol,PERIOD_CURRENT,120,0,MODE_SMMA, PRICE_CLOSE,i);
         //         indData.ima240[i]= iMA(_Symbol,PERIOD_CURRENT,240,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.atr[i] = iATR(_Symbol,PERIOD_CURRENT,noOfCandles,i);
      }

      for(int i=0; i<201; i++) {
         indData.open[i] = open[i];
         indData.close[i] = close[i];
         indData.tick_volume[i]=tick_volume[i];
         indData.ima120[i]= iMA(_Symbol,PERIOD_CURRENT,120,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.ima240[i]= iMA(_Symbol,PERIOD_CURRENT,240,0,MODE_SMMA, PRICE_CLOSE,i);
         indData.ima500[i]= iMA(_Symbol,PERIOD_CURRENT,500,0,MODE_SMMA, PRICE_CLOSE,i);
      }

      //Print("ima30 current 1: "+indData.ima30[1]+" :ima30 5: "+ indData.ima30[5]+" :ima30 10: "+ indData.ima30[10]+" :21:" + indData.ima30[21] );
      //Print("Indicators: StdDev: "+NormalizeDouble(indData.std[SHIFT],2)+" MFI: "+NormalizeDouble(indData.mfi[SHIFT],2)+" Adx Main: "+NormalizeDouble(indData.adx[SHIFT],2)+" DI+: "+NormalizeDouble(indData.adxPlus[SHIFT],2)+" DI-: "+NormalizeDouble(indData.adxMinus[SHIFT],2)," Atr: "+indData.atr[SHIFT]+" Volume: "+indData.volume[SHIFT]+" tick_volume: "+indData.tick_volume[SHIFT]);
      //initCalc(indData);

      if(GetLastError() == 4001) { // ERR_NOT_ENOUGH_MEMORY
         Print("Memory error at bar ", i);
         return(0); // Stop calculation
      }

   }

   initCalc(indData);

//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initCalc(const INDDATA &indData) {
   buff1[0] = buySell(indData);

   if(recordData) {
      datetime currentTime = TimeCurrent();
      datetime currentMinute = currentTime - (currentTime % 60);
      if(currentMinute!=lastMinute) {
         lastMinute=currentMinute;
         st1.writeOHLCVJsonData(dataFileName,indData,sig,util,1);
         //util.writeJsonData(dataFileName,indData,recordSignal,1);
      }
      // if(util.fileSizeCheck(dataFileName,0.5))Print("File size is greater that 0.5 mb");
      //util.writeStructData(dataFileName,indData,recordSignal,1);
//      util.writeJsonData(dataFileName,indData,recordSignal,1);
   }

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double buySell(const INDDATA &indData) {

   SIGBUFF sbuff = st1.imaSt1(indData);



   if((sbuff.buff2[0]!=EMPTY) && (sbuff.buff2[0]!=EMPTY_VALUE) && (sbuff.buff2[0]!=NULL)) {
      //buff2[0] = sbuff.buff2[0];
      if(!flipSig) {
         buff2[0] = sbuff.buff2[0];
      } else if(flipSig) {
         buff2[0] = util.flipSig((SAN_SIGNAL)sbuff.buff2[0]);
      }
   } else {
      buff2[0] = EMPTY_VALUE;
   }
   if((sbuff.buff3[0]!=EMPTY) && (sbuff.buff3[0]!=EMPTY_VALUE) && (sbuff.buff3[0]!=NULL)) {
      buff3[0] = sbuff.buff3[0];
   } else {
      buff3[0] = EMPTY_VALUE;
   }
   if((sbuff.buff4[0]!=EMPTY) && (sbuff.buff4[0]!=EMPTY_VALUE) && (sbuff.buff4[0]!=NULL)) {
      // Setting Market type. Trending or flat
      buff4[0] = sbuff.buff4[0];
   } else {
      buff4[0] = EMPTY_VALUE;
   }

   if(((sbuff.buff1[0]==EMPTY) || (sbuff.buff1[0]==EMPTY_VALUE) || (sbuff.buff1[0]==NULL))) {
      //sbuff.buff1[0]=1000.314;
      sbuff.buff1[0]=EMPTY_VALUE;
      return sbuff.buff1[0];
   }

   if((sbuff.buff1[0]!=EMPTY) && (sbuff.buff1[0]!=EMPTY_VALUE) && (sbuff.buff1[0]!=NULL)) {
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

   int i=rates_total-prev_calculated-1;
   if(i<0)
      i=0;
   while(i>=0)
      return true;


   return false;
}
//+------------------------------------------------------------------+
