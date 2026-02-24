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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

input double physicsWeight      = 0.48;   // Slightly more voice to Hyperbolic
input double cobbWeight         = 0.32;// Cobb-Douglas weight (balanced)
input double cloudWeight        = 0.20;  // Market Cloud weight (conservative)
input double consensusThreshold = 0.32;   // Slightly more aggressive

input double maxMultiplier = 2.0; // Maximum risk for elite setups
double minLotSize = 0.01;      // Terminal minimum
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
double pipValue;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

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
   pipValue = util.getPipValue(_Symbol);
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
         data.mfi[i] = iMFI(_Symbol, PERIOD_CURRENT,noOfCandles,i);
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


//// Inside RefreshPhysicsData in ea-v2.mq4
//   double fastSlope   = (data.ima120[0] - data.ima120[3])/(3*pipValue);   // Fast context
//   double medSlope    = (data.ima240[0] - data.ima240[10])/(10*pipValue);  // Medium context
//   double slowSlope   = (data.ima500[0] - data.ima500[30])/(30*pipValue);  // Slow context
// Inside RefreshPhysicsData in ea-v2.mq4
//   double fastSlope   = (data.ima30[0] - data.ima30[3])/(3*pipValue);   // Fast context
//   double medSlope    = (data.ima60[0] - data.ima60[10])/(10*pipValue);  // Medium context
//   double slowSlope   = (data.ima120[0] - data.ima120[30])/(30*pipValue);  // Slow context
//
//   double fMSR = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);
//   double fMSR_norm = 0;
//
//   if(fMSR > 0.80)
//      fMSR_norm = 1.00; // Hyper-Expansion
//   else if(fMSR > 0.50)
//      fMSR_norm = 0.75; // Healthy
//   else if(fMSR > 0.10)
//      fMSR_norm = 0.30; // Dragging
//   else
//      fMSR_norm = 0.00; // Conflict/Whipsaw
//
//   data.fMSR = fMSR_norm; // Now normalized 0 to 1


   double fastSlope = (data.ima30[0] - data.ima30[3]) / (3 * pipValue);
   double medSlope  = (data.ima60[0] - data.ima60[10]) / (10 * pipValue);
   double slowSlope = (data.ima120[0] - data.ima120[30]) / (30 * pipValue);

   double fMSR_raw = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);

// Continuous linear version — Option 1 (smooth 0.0 to 1.0)
   double fMSR_norm = MathMax(0.0, MathMin(1.0, (fMSR_raw - 0.5) / 1.5));

   data.fMSR = fMSR_norm;

//double fractal = ms.fractalAlignment(fastSlope, medSlope, slowSlope,data.atr[0],pipValue);
   double fractal = ms.fractalAlignment(fastSlope, medSlope, slowSlope);

   data.fractalAlignment = fractal;

}
//+------------------------------------------------------------------+

//void OnTimer()
void OnTick() {
   int totalOrders = OrdersTotalByMagic(magicNumber);

   if(totalOrders > 0 && util.isNewBar())
      BarsHeld++;
   else if(totalOrders == 0)
      BarsHeld = 0;

   int orderMesg = NULL;
   INDDATA indData;
   RefreshPhysicsData(indData);

// Steering
   SIGBUFF signals = st1.imaSt2(indData);
   SAN_SIGNAL direction = (SAN_SIGNAL)signals.buff1[0];
   SAN_SIGNAL closeSIG = (SAN_SIGNAL)signals.buff2[0];

   SIGBUFF marketIntensity = st1.featureCloud_Strategy(indData);
   double mktIntensity = marketIntensity.buff3[0];
   double regimeMagnitude = marketIntensity.buff3[1];
   string marketState = ((bool)marketIntensity.buff4[0])
                        ?"DORMANT":(((bool)marketIntensity.buff4[1])
                                    ?"AWAKE":(((bool)marketIntensity.buff4[2])
                                          ?"STRETCH":(((bool)marketIntensity.buff4[3])
                                                ?"CLIMAX":"NOSTATE")));

   int marketAction = (((bool)marketIntensity.buff4[1]) || ((bool)marketIntensity.buff4[2]))
                      ? 1:(((bool)marketIntensity.buff4[0])
                           ?0:-1);

   PrintFormat("[MARKET] Intensity: %.2f | Regime: %.2f: | Market State: %s | Market Action: %d",
               mktIntensity,regimeMagnitude,marketState,marketAction);

// Decisions
   double b = indData.bayesianHoldScore;
   double n = indData.neuronHoldScore;
   double f = indData.fMSR;
   double fra = indData.fractalAlignment;

   double totalConf = MathPow(f+0.01, 1.0) * MathPow(n+0.01, 1.2) * MathPow(b+0.01, 1.5);
   int cobbsDouglasAction = ms.getCobbDouglasCombinedScore(b, n);//, f, fra);
   int physicsAction = ms.getHyperbolicCombinedScore(b, n);//, f, fra);

   PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %.2f",
               b, n, f, fra, totalConf, cobbsDouglasAction);

   PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %.2f",
               b, n, f, fra, physicsAction);

// ===============================================
// CONSENSUS ENGINE — SINGLE SOURCE OF TRUTH
// ===============================================
   double consensusScore = (physicsAction * physicsWeight) +
                           (cobbsDouglasAction * cobbWeight) +
                           (marketAction * cloudWeight);

   int finalAction = 0;
   if(consensusScore > consensusThreshold)      finalAction = 1;   // SNIPE
   else if(consensusScore < -consensusThreshold) finalAction = -1; // COLLAPSE
   else finalAction = 0;                                           // HOLD

   PrintFormat("[CONSENSUS] Score: %.3f | FinalAction: %d | Physics:%d | Cobb:%d | Market:%d",
               consensusScore, finalAction, physicsAction, cobbsDouglasAction, marketAction);

// Conviction scaling (only when consensus is strong)
   double convictionFactor = 1.0;
   if(finalAction == 1) {
      double entryFloor = 0.185;
      double eliteCeiling = 0.300;
      double depth = (totalConf - entryFloor) / (eliteCeiling - entryFloor);
      depth = MathMax(0.0, MathMin(1.0, depth));
      convictionFactor = 1.0 + (depth * (maxMultiplier - 1.0));
      PrintFormat("CONSENSUS REACHED: Confidence %.4f | Conviction Multiplier: %.2fx", totalConf, convictionFactor);
   } else if (direction != SAN_SIGNAL::NOSIG && util.isNewBar()) {
      PrintFormat("CONSENSUS FAILED: Hyperbolic:%d | CobbDouglas:%d | Conf:%.4f", physicsAction, cobbsDouglasAction, totalConf);
   }

   double baseLots = microLots * minLotSize;
   double dynamicLots = baseLots * convictionFactor;

//################################################################
// FINAL GOVERNANCE
//################################################################

// ENTRY
   if(totalOrders == 0) {
      if(finalAction == 1 && direction != SAN_SIGNAL::NOSIG) {
         PrintFormat("SNIPER: Entering with %.2fx Conviction (Lots: %.2f) | Final Consensus: %d",
                     convictionFactor, dynamicLots, finalAction);
         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (direction == SAN_SIGNAL::BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL), 3, 0, 0);
         BarsHeld = 0;
      } else if(direction != SAN_SIGNAL::NOSIG && finalAction != 1 && util.isNewBar()) {
         PrintFormat("ENTRY BLOCKED by Consensus: Signal %s but FinalAction %d",
                     util.getSigString(direction), finalAction);
      }
   }

// EXIT
   else {
      if(finalAction == -1) {
         Print("🚨 GOVERNANCE: Consensus Collapsed → Forcing Exit");
         orderMesg = util.closeOrders();
         BarsHeld = 0;
      } else if(closeSIG == SAN_SIGNAL::CLOSE && util.isNewBar()) {
         Print("🛡️ Signal wants CLOSE but Consensus is stable → HOLDING");
      }

      if(util.isNewBar()) BarsHeld++;
      if(GetLastError() != ERR_NO_ERROR)
         Print("Order result: " + orderMesg + " :: Last Error: " + util.getUninitReasonText(GetLastError()));
   }

   if(recordData && util.isNewBarTime())
      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);
}


//+------------------------------------------------------------------+
