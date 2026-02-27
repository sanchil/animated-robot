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


   double fastSlope = (data.ima30[0] - data.ima30[3]) / (3 * pipValue);
   double medSlope  = (data.ima60[0] - data.ima60[10]) / (10 * pipValue);
   double slowSlope = (data.ima120[0] - data.ima120[30]) / (30 * pipValue);

// Pass the raw, signed measurement.
// The Sages and Neuron will apply their Bimodal math to this!
   data.fMSR = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);

   double fractal = ms.fractalAlignment(fastSlope, medSlope, slowSlope);
   data.fractalAlignment = fractal;


}
//+------------------------------------------------------------------+

//void OnTimer()
void OnTick() {
   OnCycleTask1();
//   int totalOrders = OrdersTotalByMagic(magicNumber);
//
//   if(totalOrders > 0 && util.isNewBar())
//      BarsHeld++;
//   else if(totalOrders == 0)
//      BarsHeld = 0;
//
//   int orderMesg = NULL;
//   INDDATA indData;
//   RefreshPhysicsData(indData);
//
//// Steering
//   SIGBUFF signals = st1.imaSt2(indData);
//   SAN_SIGNAL direction = (SAN_SIGNAL)signals.buff1[0];
//   SAN_SIGNAL closeSIG = (SAN_SIGNAL)signals.buff2[0];
//
//   SIGBUFF marketIntensity = st1.featureCloud_Strategy(indData);
//   double mktIntensity = marketIntensity.buff3[0];
//   double regimeMagnitude = marketIntensity.buff3[1];
//   string marketState = ((bool)marketIntensity.buff4[0])
//                        ?"DORMANT":(((bool)marketIntensity.buff4[1])
//                                    ?"AWAKE":(((bool)marketIntensity.buff4[2])
//                                          ?"STRETCH":(((bool)marketIntensity.buff4[3])
//                                                ?"CLIMAX":"NOSTATE")));
//
//   int marketAction = (((bool)marketIntensity.buff4[1]) || ((bool)marketIntensity.buff4[2]))
//                      ? 1:(((bool)marketIntensity.buff4[0])
//                           ?0:-1);
//
//   PrintFormat("[MARKET] Intensity: %.2f | Regime: %.2f: | Market State: %s | Market Action: %d",
//               mktIntensity,regimeMagnitude,marketState,marketAction);
//
//// Decisions
//   double b = indData.bayesianHoldScore;
//   double n = indData.neuronHoldScore;
//   double f = indData.fMSR;
//   double fra = indData.fractalAlignment;
//
//   double totalConf = MathPow(f+0.01, 1.0) * MathPow(n+0.01, 1.2) * MathPow(b+0.01, 1.5);
//   int cobbsDouglasAction = ms.getCobbDouglasCombinedScore(b, n, f, fra);
//   int physicsAction = ms.getHyperbolicCombinedScore(b, n, f, fra);
//
//   PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %.2f",
//               b, n, f, fra, totalConf, cobbsDouglasAction);
//
//   PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %.2f",
//               b, n, f, fra, physicsAction);
//
//// ===============================================
//// THE TRINITY CONSENSUS (SINGLE SOURCE OF TRUTH)
//// ===============================================
//
//// 1. The Environment Vote
//   bool hasConsensus = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 1);
//   bool hasCollapse  = (physicsAction == -1 || cobbsDouglasAction == -1 || marketAction == -1);
//
//// 2. Identify the Structural Phase
//   double absF = MathAbs(f);
//   bool isSqueeze = (absF <= 0.15);
//
//// 3. Extract the Tactical Vanguard (The Sniper)
//// We pull this directly from the internal SanStrategies object state
//   SAN_SIGNAL vanguardSignal = st1.s.volatilitySIG;
//   if (vanguardSignal == SAN_SIGNAL::NOSIG) {
//      vanguardSignal = st1.s.candleVolSIG; // Fallback to secondary volume metric if needed
//   }
//
//// 4. The Phase-Dependent Trigger
//   SAN_SIGNAL triggerSignal = SAN_SIGNAL::NOSIG;
//   if (isSqueeze) {
//      triggerSignal = vanguardSignal; // Sniper reads tick volume in the dark
//   } else {
//      triggerSignal = direction;      // Macro generals read the expanding trend
//   }
//
//// 5. Dynamic Risk Scaling
//// We automatically scale down risk by 25% when sniping a blind squeeze
//   double convictionFactor = isSqueeze ? 0.75 : 1.0;
//   double baseLots = microLots * minLotSize;
//   double dynamicLots = baseLots * convictionFactor;
//
////################################################################
//// FINAL GOVERNANCE (EXECUTION)
////################################################################
//
//// --- ENTRY LOGIC ---
//   if(totalOrders == 0) {
//      if(hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
//
//         string phaseStr = isSqueeze ? "COMPRESSION SQUEEZE" : "MACRO EXPANSION";
//
//         PrintFormat("⚡ SNIPER [%s]: Sages Approved. Trigger dictates: %s. (Lots: %.2f)",
//                     phaseStr, util.getSigString(triggerSignal), dynamicLots);
//
//         orderMesg = util.placeOrder(magicNumber, dynamicLots,
//                                     (triggerSignal == SAN_SIGNAL::BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL), 3, 0, 0);
//         BarsHeld = 0;
//      } else if(triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS && util.isNewBar()) {
//         PrintFormat("🛡️ ENTRY BLOCKED: Trigger %s fired, but Sages vetoed (Phy:%d, Cobb:%d, Mkt:%d)",
//                     util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
//      }
//   }
//
//// --- EXIT LOGIC ---
//   else {
//      SAN_SIGNAL tradePosition = util.getTradePosition();
//
//      // EXIT A: MACRO COLLAPSE (The Ultimate Failsafe)
//      if(hasCollapse) {
//         PrintFormat("🚨 GOVERNANCE: Macro Collapse Detected (Phy:%d, Cobb:%d, Mkt:%d). Forcing Exit.",
//                     physicsAction, cobbsDouglasAction, marketAction);
//         orderMesg = util.closeOrders();
//         BarsHeld = 0;
//      }
//      // EXIT B: TACTICAL TRAP (Stop Hunt Defense)
//      // Market is expanding, but our tactical volume violently flipped against our position.
//      else if (!isSqueeze && vanguardSignal != SAN_SIGNAL::NOSIG && util.oppSignal(tradePosition, vanguardSignal)) {
//         PrintFormat("🚨 GOVERNANCE: Tactical Trap! Vanguard violently flipped to %s. EJECTING.",
//                     util.getSigString(vanguardSignal));
//         orderMesg = util.closeOrders();
//         BarsHeld = 0;
//      }
//      // EXIT C: STANDARD CLOSE (Natural trend death)
//      else if(closeSIG == SAN_SIGNAL::CLOSE && util.isNewBar()) {
//         Print("🛡️ GOVERNANCE: Standard Close Signal honored. Exiting.");
//         orderMesg = util.closeOrders();
//         BarsHeld = 0;
//      }
//
//      if(util.isNewBar()) BarsHeld++;
//
//      if(GetLastError() != ERR_NO_ERROR)
//         Print("Order result: ", orderMesg, " :: Last Error: ", util.getUninitReasonText(GetLastError()));
//   }
//
//// Data Telemetry
//
//   indData.convictionFactor = convictionFactor;
//   if(recordData && util.isNewBarTime())
//      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);
}


void OnCycleTask1() {

// 1. Capture Bar State ONCE per tick
   bool isNewCandle = util.isNewBar();

   int totalOrders = OrdersTotalByMagic(magicNumber);

   if(totalOrders > 0 && isNewCandle)
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
   int cobbsDouglasAction = ms.getCobbDouglasCombinedScore(b, n, f, fra);
   int physicsAction = ms.getHyperbolicCombinedScore(b, n, f, fra);

   PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %d",
               b, n, f, fra, totalConf, cobbsDouglasAction);

   PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %d",
               b, n, f, fra, physicsAction);


// ===============================================
// THE TRINITY CONSENSUS (SINGLE SOURCE OF TRUTH)
// ===============================================

// 1. The Environment Vote
   bool hasConsensus = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 1);
   bool hasCollapse  = (physicsAction == -1 || cobbsDouglasAction == -1 || marketAction == -1);

// 2. Identify the Structural Phase
   double absF = MathAbs(f);
   bool isSqueeze = (absF <= 0.15);

// 3. Extract the Tactical Vanguard (The Sniper)
// We pull this directly from the internal SanStrategies object state
   SAN_SIGNAL vanguardSignal = st1.s.volatilitySIG;
   if (vanguardSignal == SAN_SIGNAL::NOSIG) {
      vanguardSignal = st1.s.candleVolSIG; // Fallback to secondary volume metric if needed
   }

// 4. The Phase-Dependent Trigger
   SAN_SIGNAL triggerSignal = SAN_SIGNAL::NOSIG;
   if (isSqueeze) {
      triggerSignal = vanguardSignal; // Sniper reads tick volume in the dark
   } else {
      triggerSignal = direction;      // Macro generals read the expanding trend
   }

// 5. Dynamic Risk Scaling
// We automatically scale down risk by 25% when sniping a blind squeeze
   double convictionFactor = isSqueeze ? 0.75 : 1.0;
   double baseLots = microLots * minLotSize;
   double dynamicLots = baseLots * convictionFactor;

//################################################################
// FINAL GOVERNANCE (EXECUTION)
//################################################################

// --- ENTRY LOGIC ---
   if(totalOrders == 0) {
      if(hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         string phaseStr = isSqueeze ? "COMPRESSION SQUEEZE" : "MACRO EXPANSION";
         PrintFormat("⚡ SNIPER [%s]: Sages Approved. Trigger dictates: %s. (Lots: %.2f)",
                     phaseStr, util.getSigString(triggerSignal), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL), 3, 0, 0);
         BarsHeld = 0;
      } else if(triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS && isNewCandle) {
         PrintFormat("🛡️ ENTRY BLOCKED: Trigger %s fired, but Sages vetoed (Phy:%d, Cobb:%d, Mkt:%d)",
                     util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
      }
   }
// --- EXIT LOGIC ---
   else {
      SAN_SIGNAL tradePosition = util.getTradePosition();

      if(hasCollapse) {
         PrintFormat("🚨 GOVERNANCE: Macro Collapse Detected (Phy:%d, Cobb:%d, Mkt:%d). Forcing Exit.",
                     physicsAction, cobbsDouglasAction, marketAction);
         orderMesg = util.closeOrders();
         BarsHeld = 0;
      }
      else if (!isSqueeze && vanguardSignal != SAN_SIGNAL::NOSIG && util.oppSignal(tradePosition, vanguardSignal)) {
         PrintFormat("🚨 GOVERNANCE: Tactical Trap! Vanguard violently flipped to %s. EJECTING.",
                     util.getSigString(vanguardSignal));
         orderMesg = util.closeOrders();
         BarsHeld = 0;
      }
      else if(closeSIG == SAN_SIGNAL::CLOSE && isNewCandle) {
         Print("🛡️ GOVERNANCE: Standard Close Signal honored. Exiting.");
         orderMesg = util.closeOrders();
         BarsHeld = 0;
      }

      if(GetLastError() != ERR_NO_ERROR)
         Print("Order result: ", orderMesg, " :: Last Error: ", util.getUninitReasonText(GetLastError()));
   }

// Data Telemetry
   indData.convictionFactor = convictionFactor;
   if(recordData && isNewCandle)
      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);
      
}

