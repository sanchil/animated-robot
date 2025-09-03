//+------------------------------------------------------------------+
//|                                          hilbertDftTransform.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

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
   Print("open[1]: "+ open[1]+" Open[1]: "+Open[1]);
   Print("high[1]: "+ high[1]+" High[1]: "+High[1]);
   Print("low[1]: "+ low[1]+" Low[1]: "+Low[1]);
   Print("close[1]: "+ close[1]+" Close[1]: "+Close[1]);
   Print("tick_volume[1]: "+ tick_volume[1]+" Volume[1]: "+Volume[1]);
   Print("time[1]: "+ time[1]+" Time[1]: "+Time[1]);


//int i = rates_total-prev_calculated-1;
//if(i<0)i=0;
//while(i>=0) {
//   Print("rates_total: "+rates_total+" prev_calculated: "+prev_calculated);
//   i=-1;
//}

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
