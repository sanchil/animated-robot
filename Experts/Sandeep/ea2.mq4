//+------------------------------------------------------------------+
//|                                                          ea2.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
//void OnTick()
  {
//---
   string url = "https://codestral.mistral.ai/v1/chat/completions";
   string apiKey= "9gFms2xwFyGDKci2kGfFQCpcj9FwSmdb";
   string data="Tell me about Coffee";
   WebService_CodestralCall(url,apiKey,data,"GET");
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WebService_CodestralCall(string url, string apiKey, string data, string method = "GET")
  {
//// Define the request and response variables
//   string request = "";
   string response = "";
   string res_headers;
   char post[],result[];
   int timeout=5000; 
   int size = (StringLen(data)+1); 
   ArrayResize(post,size);
   int res;
//
//// Build the request headers
   string headers = StringFormat("Authorization: Bearer %s\nContent-Type: application/json\n", apiKey);
   
   int i=0;
   while(data[i]!=0){
   post[i]=data[i];
   i++;
   }
   post[i]=0;
   
  ResetLastError();
  res = WebRequest(method,url,headers,timeout,post,result,res_headers);

if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
     }
   else
     {
      PrintStringFromArray(result);
     }
  }

// Function to print an array of characters (string)
void PrintStringFromArray(const char &array[]) {

  int i = 0;
  while (array[i] != '\0') {
    Print(CharToString(array[i]));
    i++;
  }
}