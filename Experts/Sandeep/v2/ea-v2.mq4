//+------------------------------------------------------------------+
//|                                                         ea-v2.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// ea-v2.mq4 - TOP SECTION
#include <Sandeep/v2/SanStrategies-v2.mqh> // This now "owns" SanSignals

input ulong magicNumber = 1002; // MagicNumber
input int noOfCandles = 21;
input const double TAKE_PROFIT = 1.4; // TakeProfit
input const double STOP_LOSS = 0.3; //StopLoss
// Data File Inputs
input bool recordData = false; // Record Data
//input int recordFreqInMinutes=1; // Record after the mentioned period. Default is record once every minute.
//input string dataFileName="NEWDATA.csv";
// Activate when using FileStreamSourceConnector for handling of single json file by kafka-connect docker service
//input string dataFileName="NEWDATA.json";
// Activate when using SpoolDirJsonSourceConnector for handling of mulptiple json files by kafka-connect docker service
string dataFileName = "NEWDATA_" + TimeToString(TimeCurrent(), TIME_DATE) + ".json";
input SAN_SIGNAL recordSignal = SAN_SIGNAL::NOTRADE;
// Flip signal. BUY becomes SELL and SELL becomes BUY
input bool flipSig = false; // Flip Signal
// Lot size = 0.01.
// 1 Microlot = 1*0.01=0.01, 10 Microlots = 10*0.01 = 0.1, 100 Microlots = 1,
input double microLots = 1; // Micro Lots
const int SHIFT = 1;

double closeProfit;// Profit at which a trade is considered for closing. Also used for takeProfit.
double stopLoss; // The current profit is adjusted by subtracting the spread and a margin added.

double currProfit; // The profit of the currently held trade
double maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.

double ciHandle; // buff1 : Comprehensive Buy Sell composite signals based on other signals.
double ciClose; // buff2: Quick close signal based on candle close below ima5
double ciStrategy; // buff3: The Signal strategy used to generate buy sell signals
int BarsHeld = 0;   // per trade
//double ciTradeSig; // buff4 : Trade NoTrade signal.
//double ciMktType; // buff4 : Set Market type: Trending or Flat.

bool TRADESWITCH = true;
ORDERPARAMS op3;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//int OnInit()
//  {
////---
//   EventSetTimer(1);
//   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
//   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
//   stopLoss = op3.STOPLOSS;
//   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
//   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
//   BarsHeld = 0;
////   ---
//   return(INIT_SUCCEEDED);
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   EventSetTimer(1);
   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = op3.STOPLOSS;
   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
// --- RECOVERY LOGIC ---
   BarsHeld = 0;
   if(OrdersTotalByMagic(magicNumber) > 0) {
      for(int i = OrdersTotal()-1; i >= 0; i--) {
         if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {
            // Calculate bars elapsed since the order was opened
            BarsHeld = (int)((TimeCurrent() - OrderOpenTime()) / PeriodSeconds());
            break;
         }
      }
   }
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
//--- The first way to get the uninitialization reason code
   Print(__FUNCTION__, "_Uninitalization reason code = ", reason);
//--- The second way to get the uninitialization reason code
   Print(__FUNCTION__, "_UninitReason = ", util.getUninitReasonText(_UninitReason));
   EventKillTimer();
}


//////+------------------------------------------------------------------+
//////| Expert tick function                                             |
//////+------------------------------------------------------------------+
//////void OnTimer()
//void _OnTick()
//  {
//
//// ai.WebService_CodestralCall("https://codestral.mistral.ai/v1/chat/completions","9gFms2xwFyGDKci2kGfFQCpcj9FwSmdb","Get some coffee","GET");
////---
////Print("ELEMENT [0,0]: "+stats.getElement(matrix,0,0,3));
////Print("ELEMENT [0,1]: "+stats.getElement(matrix,0,1,3));
////Print("ELEMENT [0,2]: "+stats.getElement(matrix,0,2,3));
////
////Print("ELEMENT [1,0]: "+stats.getElement(matrix,1,0,3));
////Print("ELEMENT [1,1]: "+stats.getElement(matrix,1,1,3));
////Print("ELEMENT [1,2]: "+stats.getElement(matrix,1,2,3));
////
////Print("ELEMENT [2,0]: "+stats.getElement(matrix,2,0,3));
////Print("ELEMENT [2,1]: "+stats.getElement(matrix,2,1,3));
////Print("ELEMENT [2,2]: "+stats.getElement(matrix,2,2,3));
//// Print("[DETERMINANT] 2x2 Determinant: ", stats.detLU(matrix2x2, 2)); // Expected: -2
////
////// 3x3: [1, 2, 3; 4, 5, 6; 7, 8, 9]
//// Print("[DETERMINANT] 3x3 Determinant: ", stats.detLU(matrix3x3, 3)); // Expected: 0
////
////// 4x4 identity
//// Print("[DETERMINANT] 4x4 Determinant: ", stats.detLU(matrix4x4, 4)); // Expected: 1
////
////// 5x5 identity
//// Print("[DETERMINANT] 5x5 Determinant: ", stats.detLU(matrix5x5, 5)); // Expected: 1
////   ResetLastError();
////Print("standard dev: "+stats.stdDev(x));
////Print("Pearson Coeff: "+stats.pearsonCoeff(x,y));
//// Print("ACF(1): "+stats.acf(a,0,1));
//// Print(" Mean: "+ stats.mean(a));
//// Print("STD(1): "+stats.stdDev(x)+" Mean: "+ stats.mean(x)+" z Score: "+ stats.zScore(20,stats.mean(x),stats.stdDev(x)));
//// DataTransport t = stats.scatterPlotSlope(y,x);
//// Print(" Slope1 : "+ t.matrixD[0]+" intercept1: "+t.matrixD[1]+" slope2: "+t.matrixD[2]+" intercept2: "+t.matrixD[3]);
////Print("Convergence Divergence test: "+stats.convDivTest(top,bottom,5));
//// Print(" The slope: "+stats.scatterPlotSlope(y,x).matrixD[0]+" intercept: "+stats.scatterPlotSlope(y,x).matrixD[1]);
//// Print(" Hello from VPS !!!");
//   int orderMesg = NULL;
////util.initTrade();
////closeProfit = SAN_TAKEPROFIT; // Profit at which a trade is condsidered for closing.
////stopLoss = SAN_STOPLOSS;
////currProfit = TRADEPROFIT; // The profit of the currently held trade
////maxProfit = MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
//   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
//   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
//   stopLoss = op3.STOPLOSS;
//   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
//   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
//
////int totalOrders = OrdersTotal();
//   int totalOrders = OrdersTotalByMagic(magicNumber);
////if((totalOrders > 0)
////   && (util.isNewBar()))
////  {
////   BarsHeld++;
////  }
//
//   if(totalOrders > 0 && util.isNewBar())
//      BarsHeld++;
//   else
//      if(totalOrders == 0)
//         BarsHeld = 0;
//
//// Print("Empty value: "+ EMPTY_VALUE+" EMPTY: "+EMPTY);
//// Print("[TSTAT] Take Profit: "+closeProfit+" stopLoss: "+stopLoss+" currProfit: "+currProfit+" maxProfit: "+maxProfit + " Trade Vol: "+op3.SAN_TRADE_VOL+" TPROFIT: "+TAKE_PROFIT);
////########
//   ciHandle = iCustom(_Symbol, PERIOD_CURRENT, "./Sandeep/v1/ind-v1", magicNumber, noOfCandles, stopLoss, closeProfit, currProfit, maxProfit, recordData, recordSignal, dataFileName, flipSig,BarsHeld,microLots, 0, 0);
//   ciClose = iCustom(_Symbol, PERIOD_CURRENT, "./Sandeep/v1/ind-v1", magicNumber, noOfCandles,stopLoss, closeProfit, currProfit, maxProfit, recordData, recordSignal, dataFileName, flipSig,BarsHeld,microLots, 1, 0);
//   ciStrategy =  iCustom(_Symbol, PERIOD_CURRENT, "./Sandeep/v1/ind-v1", magicNumber, noOfCandles, stopLoss, closeProfit, currProfit, maxProfit, recordData, recordSignal, dataFileName, flipSig,BarsHeld,microLots, 2, 0);
////ciMktType = iCustom(_Symbol,PERIOD_CURRENT,"./Sandeep/v1/ind-v1",magicNumber,noOfCandles,stopLoss,closeProfit,currProfit,maxProfit,recordData,recordSignal,dataFileName,flipSig,3,0);
////########
////  Print(" Signal strategy: "+ ciStrategy + " ciTradeSig: "+ciTradeSig+" SIG: "+ ciHandle);
////  Print(" Trade SIG: "+ util.getSigString(ciHandle)+" Market Type: "+ util.getSigString(ciMktType));
////   if((ciHandle==EMPTY)&&(ciHandle==EMPTY_VALUE))
////      Print(" Trade SIG: "+ util.getSigString(ciHandle)+" absolute value: "+ ciHandle);
//
//// Print("EMPTY:  "+ EMPTY+" EMPTY_VALUE: "+EMPTY_VALUE);
//// Print("[EA] Total orders: "+ totalOrders+" Signal: "+ (SAN_SIGNAL)ciHandle + " Sig str: "+ util.getSigString((SAN_SIGNAL)ciHandle)+ " Close sig: "+ (SAN_SIGNAL)ciClose+" close str: "+ util.getSigString((SAN_SIGNAL)ciClose)+" Point: "+Point+" Digits: "+_Digits);
////########
////##################################################################################################################
//   if((ciHandle != EMPTY) && (ciHandle != EMPTY_VALUE))
//     {
//      if((totalOrders > 0) && ((SAN_SIGNAL)ciClose == SAN_SIGNAL::CLOSE) && ((STRATEGYTYPE)ciStrategy == STRATEGYTYPE::CLOSEPOSITIONS))
//        {
//         Print(" Trying to close orders");
//         if(TRADESWITCH)
//           {
//            BarsHeld = 0;
//            util.closeOrders();
//           }
//
//
//        }
//      //##################################################################################################################
//      //##################################################################################################################
//      // CLOSE trade on reverse for now
//      //      if((totalOrders > 0) && ((SAN_SIGNAL)ciClose!=SAN_SIGNAL::CLOSE)&& ((STRATEGYTYPE)ciStrategy == STRATEGYTYPE::IMACLOSE)) {
//      //         //  Print(" Trade position: "+ op3.TRADEPOSITION + "| Trade Profit: "+TRADEPROFIT+" |Max Trade Profit: "+MAXTRADEPROFIT+" | Opposing signals: "+util.oppSignal((SAN_SIGNAL)ciClose,op3.TRADEPOSITION)+" 20% profit fall:"+util.closeOnProfitPercentage(0.2));
//      //         if(util.oppSignal((SAN_SIGNAL)ciClose,op3.TRADEPOSITION)) {
//      //            Print(" Trying to reverse orders");
//      //            if(TRADESWITCH)
//      //               util.closeOrdersOnRevSignal((SAN_SIGNAL)ciClose,0);
//      //         }
//      //
//      //      }
//      //##################################################################################################################
//      //##################################################################################################################
//      if(totalOrders == 0)
//        {
//         BarsHeld = 0;
//         if(((SAN_SIGNAL)ciHandle) == SAN_SIGNAL::BUY)
//           {
//            Print(" Placing a buy ! order: ");
//            if(TRADESWITCH)
//              {
//               orderMesg = util.placeOrder(magicNumber, op3.SAN_TRADE_VOL, ENUM_ORDER_TYPE::ORDER_TYPE_BUY, 3, 0, 0);
//               //////orderMesg = OrderSend(_Symbol,OP_BUY,op3.SAN_TRADE_VOL,Ask,3,0,0,"My buy order",magicNumber,0,clrNONE);
//              }
//           }
//         if(((SAN_SIGNAL)ciHandle) == SAN_SIGNAL::SELL)
//           {
//            Print(" Placing a sell ! order: ");
//            if(TRADESWITCH)
//              {
//               orderMesg = util.placeOrder(magicNumber, op3.SAN_TRADE_VOL, ENUM_ORDER_TYPE::ORDER_TYPE_SELL, 3, 0, 0);
//               //////orderMesg = OrderSend(_Symbol,OP_SELL,op3.SAN_TRADE_VOL,Bid,3,0,0,"My sell order",magicNumber,0,clrNONE);
//              }
//           }
//         //Print(" Order Ticket: "+ orderMesg);
//         if(GetLastError() != ERR_NO_ERROR)
//            Print(" Order result: " + orderMesg + " :: Last Error Message: " + (util.getUninitReasonText(GetLastError())));
//        }
//      //##################################################################################################################
//     }
////########
//  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Count only orders with our magic number                          |
//+------------------------------------------------------------------+
int OrdersTotalByMagic(ulong magic) {
   int cnt = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magic)
         cnt++;
   return cnt;
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshPhysicsData(INDDATA &data) {
   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = op3.STOPLOSS;
   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.


//data.freeData(); // Vital: Clean the slate
   data.magicnumber = magicNumber;
   data.stopLoss = stopLoss;
   data.currProfit = currProfit;
   data.closeProfit = closeProfit;
   data.maxProfit = maxProfit;
   data.shift = SHIFT;
   data.microLots = microLots;
// 2. Sync EA State
   data.BarsHeld   = BarsHeld;
   data.currSpread = (int)MarketInfo(_Symbol, MODE_SPREAD);

// 1. Fill the "Macro" perspective (last 240 bars)
   for(int i = 0; i < 240; i++) {


      data.open[i] = iOpen(_Symbol, PERIOD_CURRENT, i);
      data.close[i] = iClose(_Symbol, PERIOD_CURRENT, i);
      data.tick_volume[i] = (long)iVolume(_Symbol, PERIOD_CURRENT, i);
      data.ima120[i] = iMA(_Symbol, PERIOD_CURRENT, 120, 0, MODE_SMMA, PRICE_CLOSE, i);
      data.ima240[i] = iMA(_Symbol, PERIOD_CURRENT, 240, 0, MODE_SMMA, PRICE_CLOSE, i);
      data.ima500[i] = iMA(_Symbol, PERIOD_CURRENT, 500, 0, MODE_SMMA, PRICE_CLOSE, i);

      // Heavy computation only for the "active" zone (last 31 bars)
      if(i < 120) {
         data.high[i] = iHigh(_Symbol,PERIOD_CURRENT,i);
         data.low[i] = iLow(_Symbol,PERIOD_CURRENT,i);
         data.time[i] = iTime(_Symbol,PERIOD_CURRENT,i);
         data.std[i] = iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_CLOSE, i);
         data.stdOpen[i] = iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_OPEN, i);
         data.obv[i] = iOBV(_Symbol, PERIOD_CURRENT, PRICE_CLOSE, i);
         data.rsi[i] = iRSI(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_WEIGHTED, i);
         data.ima5[i] = iMA(_Symbol, PERIOD_CURRENT, 5, 0, MODE_SMMA, PRICE_CLOSE, i);
         data.ima14[i] = iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, i);
         data.ima30[i] = iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, i);
         data.ima60[i] = iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, i);
         data.atr[i] = iATR(_Symbol, PERIOD_CURRENT, noOfCandles, i);
         data.adx[i] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,MODE_MAIN,i);
         data.adxPlus[i] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,1,i);
         data.adxMinus[i] = iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,2,i);
      }
   }


// 2. Compute the Physics Scores
// We compute these once and store them for both the Sniper and the Strategy
   double bScore = ms.bayesianHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);
   double nScore = ms.neuronHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);

// Update the snapshot so the Strategy (st1) can see the results
   data.bayesianHoldScore = bScore;
   data.neuronHoldScore = nScore;


// Inside RefreshPhysicsData in ea-v2.mq4
   double fastSlope   = data.ima120[0] - data.ima120[3];   // Fast context
   double medSlope    = data.ima240[0] - data.ima240[10];  // Medium context
   double slowSlope   = data.ima500[0] - data.ima500[30];  // Slow context

   double fMSR = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);
   double fMSR_norm = 0;

   if(fMSR > 0.80)
      fMSR_norm = 1.00; // Hyper-Expansion
   else if(fMSR > 0.50)
      fMSR_norm = 0.75; // Healthy
   else if(fMSR > 0.10)
      fMSR_norm = 0.30; // Dragging
   else
      fMSR_norm = 0.00; // Conflict/Whipsaw

   data.fMSR = fMSR_norm; // Now normalized 0 to 1

}
//+------------------------------------------------------------------+

//void OnTimer()
void OnTick() {

//static double lastBid = 0;
//if(MathAbs(Bid - lastBid) < Point && !util.isNewBar())
//   return;
//lastBid = Bid;

// 1. UPDATE STATE FIRST
   int totalOrders = OrdersTotalByMagic(magicNumber);

   if(totalOrders > 0 && util.isNewBar())
      BarsHeld++;
   else if(totalOrders == 0)
      BarsHeld = 0;

// 2. Supply the Engine with Data
   int orderMesg = NULL;
   INDDATA indData;
   RefreshPhysicsData(indData);



// 3. The Steering (Where?)
   SIGBUFF signals = st1.imaSt1(indData);
   SAN_SIGNAL direction = (SAN_SIGNAL)signals.buff1[0];
   SAN_SIGNAL closeSIG = (SAN_SIGNAL)signals.buff2[0];
   STRATEGYTYPE stgyType = (STRATEGYTYPE)signals.buff3[0];

// 4. The Decision (1=Trade, 0=Hold, -1=Exit)
   int physicsAction = ms.getCombinedScore(indData.bayesianHoldScore, indData.neuronHoldScore);




// Log the 3D Vector for "Soundness" analysis
   if(totalOrders > 0 || direction != SAN_SIGNAL::NOSIG) {
      PrintFormat("[3D VECTOR] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f",
                  indData.bayesianHoldScore, indData.neuronHoldScore, indData.fMSR);
   }


   if((totalOrders > 0) && (closeSIG == SAN_SIGNAL::CLOSE) && (stgyType == STRATEGYTYPE::CLOSEPOSITIONS)) {
      Print(" Trying to close orders");
      BarsHeld = 0;
      util.closeOrders();
   }


   if(totalOrders == 0) {
      BarsHeld = 0;
      if(direction == SAN_SIGNAL::BUY) {
         Print(" Placing a buy ! order: ");
         orderMesg = util.placeOrder(magicNumber, op3.SAN_TRADE_VOL, ENUM_ORDER_TYPE::ORDER_TYPE_BUY, 3, 0, 0);
      }
      if(direction == SAN_SIGNAL::SELL) {
         Print(" Placing a sell ! order: ");
         orderMesg = util.placeOrder(magicNumber, op3.SAN_TRADE_VOL, ENUM_ORDER_TYPE::ORDER_TYPE_SELL, 3, 0, 0);
      }
      //Print(" Order Ticket: "+ orderMesg);
      if(GetLastError() != ERR_NO_ERROR)
         Print(" Order result: " + orderMesg + " :: Last Error Message: " + (util.getUninitReasonText(GetLastError())));
   }

//   if(totalOrders == 0)
//     {
//      // ENTERING: Requires Physics (action=1) and Steering (direction)
//      if(physicsAction == 1 && direction != SAN_SIGNAL::NOSIG)
//        {
//         Print("🎯 SNIPER: Physics(", indData.bayesianHoldScore, "/", indData.neuronHoldScore, ") aligned with Direction. Entering.");
//         util.placeOrder(magicNumber, microLots, (direction == SAN_SIGNAL::BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL), 3, 0, 0);
//         BarsHeld = 0; // Reset for the new trade
//        }
//     }
//   else
//     {
//      // EXITING: Bayesian/Neuron say the structure has collapsed
//      if(physicsAction == -1)
//        {
//         Print("🚨 EMERGENCY: Physics collapsed. Closing positions.");
//         util.closeOrders();
//         BarsHeld = 0;
//        }
//
//      // Update BarsHeld for the next tick
//      if(util.isNewBar())
//         BarsHeld++;
//     }
}
//+------------------------------------------------------------------+
