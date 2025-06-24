//+------------------------------------------------------------------+
//|                                                     testFunc.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isMidnight(int bufferSecs=60)
  {
   datetime currentTime = TimeCurrent();
   datetime midnight = TimeCurrent() - (TimeCurrent() % 86400);
   return (currentTime >= midnight && currentTime < midnight + bufferSecs); // 60-second window
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool renameFile(string oldFileName, string newFileName)
  {
   string src_path="./"+oldFileName;
   string dst_path="./"+newFileName;
   if(!FileMove(src_path,0,dst_path,FILE_COMMON|FILE_REWRITE))
     {
      Print("Error moving file: ", GetLastError());
      return false;
     }
   Print("File successfully renamed from ", oldFileName, " to ", newFileName);
   return true;
  }
void OnStart()
  {
   Print("Hello script");
   //Comment("Hello script");
   Comment("");
//    renameFile("NEWDATA.csv","NEWDATA.csv-"+TimeToString(TimeCurrent,TIME_DATE));
  }
//+------------------------------------------------------------------+
