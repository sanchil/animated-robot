//+------------------------------------------------------------------+
//|                                                         ea-1.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Sandeep/SanUtils.mqh>

//#include "sanlib1.mq4"
//#include <Sandeep/SanStrategies.mqh>


ulong magicNumber = 1001;
int noOfCandles = 21;
double closeProfit;// Profit at which a trade is considered for closing. Also used for takeProfit.
double stopLoss; // The current profit is adjusted by subtracting the spread and a margin added.

double currProfit; // The profit of the currently held trade
double maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.


double ciHandle; // buff1 : Comprehensive Buy Sell composite signals based on other signals.
double ciStrategy; // buff2: The Signal strategy used to generate buy sell signals
double ciClose; // buff3: Quick close signal based on candle close below ima5
double ciTradeSig; // buff4 : Trade NoTrade signal.

bool TRADESWITCH = true;
ORDERPARAMS op3;


//double top[]= {20, 30, 100, 150, 300};
//double bottom[]= {10, 20, 90, 100, 200};


//double x[]= {10, 20, 30, 40, 50}; // std dev sample 15.81
//double y[]= {20, 40, 60, 80, 100};// coeff:1
//double y[]= {50, 40, 30, 20, 10}; //coeff:-1
//
//double m[]={4,8,6,5,3,7,9,8,6,5}; // acf(k) = 0.14 for lag k=1.
// double m[]={0.4967,0.4967,1.2332,-1.1168,1.0269,-0.9046,1.1502,-1.0215,0.9984,-0.8864} // ack lag 1 : -0.8
// double m[]={0.4967, 0.7338, 1.0379, 1.2972, 1.6108, 1.5634, 1.3321} // acf(1) 0.8
//double m[]={0.4967, -0.6441, 0.5483, -0.6931, 0.7195, -0.8793, 0.8504} // acf(1) -0.8
//  double m[]={0.5, -0.4, 0.3, -0.5, 0.7, -0.6, 0.5, -0.8, 0.6, -0.4, 0.5, -0.7, 0.8, -0.9, 0.6, -0.5, 0.4, -0.7, 0.9, -0.6}  // acf(1) -0.8
//  double o[]={-1,-2,-3,-4,-5,-6,-7};  // acf(1): 1
// double o[]={7,6,5,4,3,2,1};  // acf(1): -1

//double x[]= {10, 20, 30, 40, 50};
//double y[]= {20, 30, 40, 50, 60};// coeff:1
//double m[]={4,5,6,10,11,13,14,16,18,20}; // acf(k) = 0.778 for lag k=1.

// data for stats.scatterPlotSlope(y,x)
//double y[] = {150.0017999999995,149.9941999999995, 149.9683999999995,149.9689999999995,149.9837999999995,149.9763999999996,149.9287999999995, 149.8767999999995, 149.8623999999996,149.8621999999996};
//double x[] = {10,9,8,7,6,5,4,3,2,1};

// slope for following data is 0.9
// formula m = n*sum(xi,yi)-sum(xi)*sum(yi)/n*sum(xi^2)-(sum(xi)^2)
// b intercept b = (sum(yi)-m*sum(xi))/n
// ans:m = 0.9 b = 1.3
// y = 0.9x+1.3
// double x[] = {1,2,3,4,5};
// double y[] = {2,3,5,4,6};
// double a[] = {3,5,2,8,7}; //acf(1): −0.115: Formula: ACF(k) = (∑(Xt - μ)(Xt-k - μ)) / (∑(Xt - μ)²
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---


//util.initTrade();
//closeProfit = SAN_TAKEPROFIT; // Profit at which a trade is condsidered for closing.
//stopLoss = SAN_STOPLOSS;
//currProfit = TRADEPROFIT; // The profit of the currently held trade
//maxProfit = MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
   EventSetTimer(1);
   op3.initTrade(1,0.4);
   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = op3.STOPLOSS;
   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.

//   ---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//--- The first way to get the uninitialization reason code
   Print(__FUNCTION__,"_Uninitalization reason code = ",reason);
//--- The second way to get the uninitialization reason code
   Print(__FUNCTION__,"_UninitReason = ",util.getUninitReasonText(_UninitReason));
   EventKillTimer();

  }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//void OnTimer()
void OnTick()
  {
// ai.WebService_CodestralCall("https://codestral.mistral.ai/v1/chat/completions","9gFms2xwFyGDKci2kGfFQCpcj9FwSmdb","Get some coffee","GET");
//---

//   ResetLastError();
//Print("standard dev: "+stats.stdDev(x));
//Print("Pearson Coeff: "+stats.pearsonCoeff(x,y));
// Print("ACF(1): "+stats.acf(a,0,1));
// Print(" Mean: "+ stats.mean(a));

// Print("STD(1): "+stats.stdDev(x)+" Mean: "+ stats.mean(x)+" z Score: "+ stats.zScore(20,stats.mean(x),stats.stdDev(x)));
// DataTransport t = stats.scatterPlotSlope(y,x);
// Print(" Slope1 : "+ t.matrixD[0]+" intercept1: "+t.matrixD[1]+" slope2: "+t.matrixD[2]+" intercept2: "+t.matrixD[3]);

//Print("Convergence Divergence test: "+stats.convDivTest(top,bottom,5));
// Print(" The slope: "+stats.scatterPlotSlope(y,x).matrixD[0]+" intercept: "+stats.scatterPlotSlope(y,x).matrixD[1]);
// Print(" Hello from VPS !!!");
   int orderMesg = NULL;

//util.initTrade();
//closeProfit = SAN_TAKEPROFIT; // Profit at which a trade is condsidered for closing.
//stopLoss = SAN_STOPLOSS;
//currProfit = TRADEPROFIT; // The profit of the currently held trade
//maxProfit = MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.

   op3.initTrade(1,0.4);
   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = op3.STOPLOSS;
   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
//Print("Empty value: "+ EMPTY_VALUE+" EMPTY: "+EMPTY);
Print("Take Profit: "+closeProfit+" stopLoss: "+stopLoss+" currProfit: "+currProfit+" maxProfit: "+maxProfit + " Trade Vol: "+op3.SAN_TRADE_VOL);

   ciHandle = iCustom(_Symbol,PERIOD_CURRENT,"./Sandeep/ind1",magicNumber,noOfCandles,stopLoss,closeProfit,currProfit,maxProfit,0,0);
   ciClose = iCustom(_Symbol,PERIOD_CURRENT,"./Sandeep/ind1",magicNumber,noOfCandles,stopLoss,closeProfit,currProfit,maxProfit,1,0);
   ciStrategy =  iCustom(_Symbol,PERIOD_CURRENT,"./Sandeep/ind1",magicNumber,noOfCandles,stopLoss,closeProfit,currProfit,maxProfit,2,0);
   ciTradeSig = iCustom(_Symbol,PERIOD_CURRENT,"./Sandeep/ind1",magicNumber,noOfCandles,stopLoss,closeProfit,currProfit,maxProfit,3,0);

//  Print(" Signal strategy: "+ ciStrategy + " ciTradeSig: "+ciTradeSig+" SIG: "+ ciHandle);
//Print(" Trade SIG: "+ util.getSigString(ciHandle)+" absolute value: "+ ciHandle);
//   if((ciHandle==EMPTY)&&(ciHandle==EMPTY_VALUE))
//      Print(" Trade SIG: "+ util.getSigString(ciHandle)+" absolute value: "+ ciHandle);

   int totalOrders=OrdersTotal();

//Print("EMPTY:  "+ EMPTY+" EMPTY_VALUE: "+EMPTY_VALUE);
// Print("Total orders: "+ totalOrders+" Signal: "+ (SAN_SIGNAL)ciHandle + " Sig str: "+ util.getSigString((SAN_SIGNAL)ciHandle)+ " Close sig: "+ (SAN_SIGNAL)ciClose+" close str: "+ util.getSigString((SAN_SIGNAL)ciClose));

   if((ciHandle!=EMPTY)&&(ciHandle!=EMPTY_VALUE))
     {
      if((totalOrders > 0) && ((SAN_SIGNAL)ciClose==SAN_SIGNAL::CLOSE) && ((STRATEGYTYPE)ciStrategy == STRATEGYTYPE::CLOSEPOSITIONS))
        {
         Print(" Trying to close orders");
         if(TRADESWITCH)
            util.closeOrders();
        }
      if((totalOrders > 0) && ((SAN_SIGNAL)ciClose!=SAN_SIGNAL::CLOSE)&& ((STRATEGYTYPE)ciStrategy == STRATEGYTYPE::IMACLOSE))
        {
         //  Print(" Trade position: "+ op3.TRADEPOSITION + "| Trade Profit: "+TRADEPROFIT+" |Max Trade Profit: "+MAXTRADEPROFIT+" | Opposing signals: "+util.oppSignal((SAN_SIGNAL)ciClose,op3.TRADEPOSITION)+" 20% profit fall:"+util.closeOnProfitPercentage(0.2));
         if(util.oppSignal((SAN_SIGNAL)ciClose,op3.TRADEPOSITION))
           {
            Print(" Trying to reverse orders");
            if(TRADESWITCH)
               util.closeOrdersOnRevSignal((SAN_SIGNAL)ciClose,0);
           }

        }


      if(totalOrders==0)
        {
         if(((SAN_SIGNAL)ciHandle) == SAN_SIGNAL::BUY)
           {
            Print(" Placing a buy ! order: ");
            if(TRADESWITCH)
              {
               orderMesg = util.placeOrder(magicNumber,op3.SAN_TRADE_VOL,ENUM_ORDER_TYPE::ORDER_TYPE_BUY,3,0,0);

               //////orderMesg = OrderSend(_Symbol,OP_BUY,op3.SAN_TRADE_VOL,Ask,3,0,0,"My buy order",magicNumber,0,clrNONE);
              }
           }
         if(((SAN_SIGNAL)ciHandle) == SAN_SIGNAL::SELL)
           {
            Print(" Placing a sell ! order: ");
            if(TRADESWITCH)
              {
               orderMesg = util.placeOrder(magicNumber,op3.SAN_TRADE_VOL,ENUM_ORDER_TYPE::ORDER_TYPE_SELL,3,0,0);


               //////orderMesg = OrderSend(_Symbol,OP_SELL,op3.SAN_TRADE_VOL,Bid,3,0,0,"My sell order",magicNumber,0,clrNONE);
              }
           }

         //Print(" Order Ticket: "+ orderMesg);

         if(GetLastError()!=ERR_NO_ERROR)
            Print(" Order result: "+ orderMesg+" :: Last Error Message: " + (util.getUninitReasonText(GetLastError())));


        }
     }

  }
//+------------------------------------------------------------------+
