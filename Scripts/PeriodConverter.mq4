//+------------------------------------------------------------------+
//|                                              PeriodConverter.mq4 |
//|                             Copyright 2000-2025, MetaQuotes Ltd. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright   "2000-2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"
#property description "Period Converter to updated format of history base"
#property strict
#property show_inputs

input int InpPeriodMultiplier=3; // Period multiplier factor
int       ExtHandle=-1;
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime time0;
   ulong    last_fpos=0;
   long     last_volume=0;
   int      i,start_pos,periodseconds;
   int      cnt=0;
//---- History header
   int      file_version=401;
   string   c_copyright;
   string   c_symbol=Symbol();
   int      i_period=Period()*InpPeriodMultiplier;
   int      i_digits=Digits;
   int      i_unused[13];
   MqlRates rate;
//---  
   ExtHandle=FileOpenHistory(c_symbol+(string)i_period+".hst",FILE_BIN|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
   if(ExtHandle<0)
      return;
   c_copyright="Copyright 2005-2025, MetaQuotes Ltd.";
   ArrayInitialize(i_unused,0);
//--- write history file header
   FileWriteInteger(ExtHandle,file_version,LONG_VALUE);
   FileWriteString(ExtHandle,c_copyright,64);
   FileWriteString(ExtHandle,c_symbol,12);
   FileWriteInteger(ExtHandle,i_period,LONG_VALUE);
   FileWriteInteger(ExtHandle,i_digits,LONG_VALUE);
   FileWriteInteger(ExtHandle,0,LONG_VALUE);
   FileWriteInteger(ExtHandle,0,LONG_VALUE);
   FileWriteArray(ExtHandle,i_unused,0,13);
//--- write history file
   periodseconds=i_period*60;
   start_pos=Bars-1;
   rate.open=Open[start_pos];
   rate.low=Low[start_pos];
   rate.high=High[start_pos];
   rate.tick_volume=(long)Volume[start_pos];
   rate.spread=0;
   rate.real_volume=0;
   //--- normalize open time
   rate.time=Time[start_pos]/periodseconds;
   rate.time*=periodseconds;
   for(i=start_pos-1; i>=0; i--)
     {
      if(IsStopped())
         break;
      time0=Time[i];
      //--- history may be updated
      if(i==0)
        {
         //--- modify index if history was updated
         if(RefreshRates())
            i=iBarShift(NULL,0,time0);
        }
      //---
      if(time0>=rate.time+periodseconds || i==0)
        {
         if(i==0 && time0<rate.time+periodseconds)
           {
            rate.tick_volume+=(long)Volume[0];
            if(rate.low>Low[0])
               rate.low=Low[0];
            if(rate.high<High[0])
               rate.high=High[0];
            rate.close=Close[0];
           }
         last_fpos=FileTell(ExtHandle);
         last_volume=(long)Volume[i];
         FileWriteStruct(ExtHandle,rate);
         cnt++;
         if(time0>=rate.time+periodseconds)
           {
            rate.time=time0/periodseconds;
            rate.time*=periodseconds;
            rate.open=Open[i];
            rate.low=Low[i];
            rate.high=High[i];
            rate.close=Close[i];
            rate.tick_volume=last_volume;
           }
        }
       else
        {
         rate.tick_volume+=(long)Volume[i];
         if(rate.low>Low[i])
            rate.low=Low[i];
         if(rate.high<High[i])
            rate.high=High[i];
         rate.close=Close[i];
        }
     } 
   FileFlush(ExtHandle);
   PrintFormat("%d record(s) written",cnt);
//--- collect incoming ticks
   datetime last_time=LocalTime()-5;
   long     chart_id=0;
//---
   while(!IsStopped())
     {
      datetime cur_time=LocalTime();
      //--- check for new rates
      if(RefreshRates())
        {
         time0=Time[0];
         FileSeek(ExtHandle,last_fpos,SEEK_SET);
         //--- is there current bar?
         if(time0<rate.time+periodseconds)
           {
            rate.tick_volume+=(long)Volume[0]-last_volume;
            last_volume=(long)Volume[0]; 
            if(rate.low>Low[0])
               rate.low=Low[0];
            if(rate.high<High[0])
               rate.high=High[0];
            rate.close=Close[0];
           }
         else
           {
            //--- no, there is new bar
            rate.tick_volume+=(long)Volume[1]-last_volume;
            if(rate.low>Low[1])
               rate.low=Low[1];
            if(rate.high<High[1])
               rate.high=High[1];
            //--- write previous bar remains
            FileWriteStruct(ExtHandle,rate);
            last_fpos=FileTell(ExtHandle);
            //----
            rate.time=time0/periodseconds;
            rate.time*=periodseconds;
            rate.open=Open[0];
            rate.low=Low[0];
            rate.high=High[0];
            rate.close=Close[0];
            rate.tick_volume=(long)Volume[0];
            last_volume=rate.tick_volume;
           }
         //----
         FileWriteStruct(ExtHandle,rate);
         FileFlush(ExtHandle);
         //--- target chart is not found yet. it can be opened via Main menu - File - Open offline
         if(chart_id==0)
           {
            long id=ChartFirst();
            while(id>=0)
              {
               //--- find appropriate offline chart
               if(ChartSymbol(id)==Symbol() && ChartPeriod(id)==i_period && ChartGetInteger(id,CHART_IS_OFFLINE))
                 {
                  chart_id=id;
                  ChartSetInteger(chart_id,CHART_AUTOSCROLL,true);
                  ChartSetInteger(chart_id,CHART_SHIFT,true);
                  ChartNavigate(chart_id,CHART_END);
                  ChartRedraw(chart_id);
                  PrintFormat("Chart window [%s,%d] found",Symbol(),i_period);
                  break;
                 }
               //--- enumerate opened charts
               id=ChartNext(id);
              }
           }
         //--- refresh window not frequently than 1 time in 2 seconds
         if(chart_id!=0 && cur_time-last_time>=2)
           {
            ChartSetSymbolPeriod(chart_id,Symbol(),i_period);
            last_time=cur_time;
           }
        }
      Sleep(50); 
     }      
//---
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   if(ExtHandle>=0)
     {
      FileClose(ExtHandle);
      ExtHandle=-1;
     }
//---
  }
//+------------------------------------------------------------------+