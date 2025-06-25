//+------------------------------------------------------------------+
//|                                                          ea3.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//input string ApiUrl = "https://your-api-domain.com/signal"; // HTTPS endpoint
input double LotSize = 0.1;                                 // Fixed lot size
input int StopLoss = 50;                                    // Stop loss in pips
input int TakeProfit = 100;                                 // Take profit in pips
input int PollInterval = 60;   
string ApiUrl = "https://codestral.mistral.ai/v1/chat/completions";
string apiKey= "9gFms2xwFyGDKci2kGfFQCpcj9FwSmdb";
string data="Tell me about Coffee";
   
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  string response = FetchSignalWithWebRequest();
  Print("Mistral response is: "+response);
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
//---

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string FetchSignalWithWebRequest()
  {
   string headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: Bearer $"+apiKey; // Optional: API-specific headers
   char post[], result[];
   string result_headers;
   string data = "{\"model\": \"mistral-small-latest\",\"messages\": [{\"role\": \"user\", \"content\": \"Who is the most renowned French painter?\"}]}";
   int length = StringToCharArray(data, post);
   
   int res = WebRequest("GET", ApiUrl, headers, 5000, post, result, result_headers);

   if(res == 200)    // HTTP OK
     {
      string response = CharArrayToString(result, 0);//, result_len);
      Print("API Response: ", response);
      return response;
     }
   else
     {
      Print("WebRequest failed. HTTP code: ", res, " Error: ", GetLastError());
      return "";
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProcessApiResponse(string response)
  {
   string signal = "";
   double price = 0.0;

   if(StringFind(response, "\"signal\":\"buy\"") >= 0)
      signal = "buy";
   else
      if(StringFind(response, "\"signal\":\"sell\"") >= 0)
         signal = "sell";

   int pricePos = StringFind(response, "\"price\":");
   if(pricePos >= 0)
     {
      string priceStr = StringSubstr(response, pricePos + 8);
      priceStr = StringSubstr(priceStr, 0, StringFind(priceStr, "}"));
      price = StringToDouble(priceStr);
     }

   if(signal == "" || price == 0.0)
     {
      Print("Invalid API response: ", response);
      return;
     }

   if(signal == "buy" && OrdersTotal() == 0)
     {
      double sl = price - StopLoss * Point;
      double tp = price + TakeProfit * Point;
      int ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, sl, tp, "API Buy", 0, 0, clrGreen);
      if(ticket < 0)
         Print("OrderSend failed: ", GetLastError());
      else
         Print("Buy order placed: Ticket #", ticket);
     }
   else
      if(signal == "sell" && OrdersTotal() == 0)
        {
         double sl = price + StopLoss * Point;
         double tp = price - TakeProfit * Point;
         int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, sl, tp, "API Sell", 0, 0, clrRed);
         if(ticket < 0)
            Print("OrderSend failed: ", GetLastError());
         else
            Print("Sell order placed: Ticket #", ticket);
        }
  }
