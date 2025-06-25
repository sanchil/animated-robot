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
#include <Sandeep/SanStrategies.mqh>

input ulong magicnumber;
input double stopLoss; // Loss at which a trade is condsidered for closing.
input double closeProfit; // Profit at which a trade is condsidered for closing.
input double currProfit; // The profit of the currently held trade
input double maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
const int SHIFT = 1;



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
int OnInit()
  {
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
                const int &spread[])
  {
//---
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(tick_volume,true);
   ArraySetAsSeries(volume,true);
   ArraySetAsSeries(spread,true);

   indData.magicnumber = magicnumber;
   indData.stopLoss = stopLoss;
   indData.currProfit = currProfit;
   indData.closeProfit = closeProfit;
   indData.maxProfit = maxProfit;
   indData.shift = SHIFT;

   if(rates_total>prev_calculated)
     {

      for(int i=0; i<30; i++)
        {
         indData.open[i] = open[i];
         indData.high[i] = high[i];
         indData.low[i] = low[i];
         indData.close[i] = close[i];
         indData.time[i] = time[i];
         indData.tick_volume[i]=tick_volume[i];
         indData.volume[i] = iVolume(_Symbol,PERIOD_CURRENT,i);
         indData.std[i]= iStdDev(_Symbol,PERIOD_CURRENT,21,0,MODE_SMA,PRICE_CLOSE,i);
         indData.mfi[i]= iMFI(_Symbol,PERIOD_CURRENT, 21,i);
         indData.adx[i]=iADX(_Symbol,PERIOD_CURRENT,21, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MAIN,i);
         indData.adxPlus[i]=iADX(_Symbol,PERIOD_CURRENT,21, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_PLUSDI,i);
         indData.adxMinus[i]=iADX(_Symbol,PERIOD_CURRENT,21, ENUM_APPLIED_PRICE::PRICE_CLOSE,MODE_MINUSDI,i);
         indData.ima5[i]= iMA(_Symbol,PERIOD_CURRENT,5,0,MODE_SMA, PRICE_CLOSE,i);
         indData.ima14[i]= iMA(_Symbol,PERIOD_CURRENT,14,0,MODE_SMA, PRICE_CLOSE,i);
         indData.ima30[i]= iMA(_Symbol,PERIOD_CURRENT,30,0,MODE_SMA, PRICE_CLOSE,i);
         indData.atr[i] = iATR(_Symbol,PERIOD_CURRENT,21,i);
        }

      //Print("Indicators: StdDev: "+NormalizeDouble(indData.std[SHIFT],2)+" MFI: "+NormalizeDouble(indData.mfi[SHIFT],2)+" Adx Main: "+NormalizeDouble(indData.adx[SHIFT],2)+" DI+: "+NormalizeDouble(indData.adxPlus[SHIFT],2)+" DI-: "+NormalizeDouble(indData.adxMinus[SHIFT],2)," Atr: "+indData.atr[SHIFT]+" Volume: "+indData.volume[SHIFT]+" tick_volume: "+indData.tick_volume[SHIFT]);
      initCalc(indData);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initCalc(const INDDATA &indData)
  {

   buff1[0] = buySell(indData);
// Print("Signal in buff1[0]: "+buff1[0]);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double buySell(const INDDATA &indData)
  {
//   SIGBUFF sbuff = st1.imaSt1(indData);
//   Print("Current candle time: "+indData.time[0]+"Previous Candle time: "+indData.time[1]);
   SIGBUFF sbuff = st1.paSt1(indData);

   buff2[0] = sbuff.buff2[0];
   buff3[0] = sbuff.buff3[0];
   buff4[0] = sbuff.buff4[0];


   return sbuff.buff1[0];
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool calculateNow(const int rates_total,
                  const int prev_calculated)
  {

   int i=rates_total-prev_calculated-1;
   if(i<0)
      i=0;
   while(i>=0)
      return true;


   return false;
  }
//+------------------------------------------------------------------+
