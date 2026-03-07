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
input int activeStrategy = 5; // 1: Trinity Sniper, 2: Trend Pyramiding
input int maxPyramidTrades = 15; // Stop adding after 15 open trades
input int noOfCandles = 21;
input const double TAKE_PROFIT = 1.4; // TakeProfit
input const double STOP_LOSS = 0.3; //StopLoss
//input int SPREAD_LIMIT  = 30;

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
   BarsHeld = util.getPyramidAge(magicNumber);

   if(OrdersTotalByMagic(magicNumber) > 0) {
      for(int i = OrdersTotal()-1; i >= 0; i--) {
         if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {

            // Calculate actual printed bars elapsed since the order was opened
            // iBarShift handles weekends, holidays, and missing data automatically
            BarsHeld = iBarShift(_Symbol, PERIOD_CURRENT, OrderOpenTime());

            break; // Breaks after finding the first one (which is the oldest due to the loop order)
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

//void OnTimer()
void OnTick() {
   OnCycleTask1();
}

//######################################################################################################
//######################################################################################################
// EA Lib functions:

//######################################################################################################
//######################################################################################################



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
   data.newBar = util.isNewBarTime();
   data.currSpread = (int)MarketInfo(_Symbol, MODE_SPREAD);


   data.maxPyramidTrades = maxPyramidTrades;
   data.totalOrders = OrdersTotalByMagic(magicNumber);
   data.currBarOrders = util.numOfOrdersCurrBar(magicNumber);
   data.newBarOpenTime = iTime(_Symbol,PERIOD_CURRENT,0);
   data.prevBarOpenTime = iTime(_Symbol,PERIOD_CURRENT,1);
   data.candleTraded = util.hasTradedCurrentBar(magicNumber);

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
//double bScore = ms.bayesianHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);
//double nScore = ms.neuronHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);

   double bScore = ms.bayesianHoldScore(data.ima30, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);
   double nScore = ms.neuronHoldScore(data.ima30, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);


// Update the snapshot so the Strategy (st1) can see the results
   data.bayesianHoldScore = bScore;
   data.neuronHoldScore = nScore;


   double fastSlope = (data.ima14[SHIFT] - data.ima30[3]) / (3 * pipValue);
   double medSlope  = (data.ima30[SHIFT] - data.ima60[10]) / (10 * pipValue);
   double slowSlope = (data.ima60[SHIFT] - data.ima120[30]) / (30 * pipValue);

// NEW: Apply your strict Macro Trend threshold (e.g., 0.1 pips per bar)
   double macroThreshold = 0.1;
   data.baseSlope = (slowSlope > macroThreshold) ? 1 : ((slowSlope < -macroThreshold) ? -1 : 0);

//// NEW: Macro trend direction from slow/base slope
//   data.baseSlope = (slowSlope > 0.01) ? 1 : ((slowSlope < -0.01) ? -1 : 0);

// Pass the raw, signed measurement.
// The Sages and Neuron will apply their Bimodal math to this!
   double fMSR_Raw = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);
   data.fMSR_Raw = fMSR_Raw;

   data.fMSR_Norm = fMSR_Raw / (1.0 + MathAbs(fMSR_Raw));

   double fractal = ms.fractalAlignment(fastSlope, medSlope, slowSlope);
   data.fractalAlignment = fractal;
   data.spreadLimit = ms.getDynamicSpreadLimit(data.atr[1],_Period);


}


void OnCycleTask1() {

// 1. Capture Bar State ONCE per tick
//   bool isNewCandle = util.isNewBarTime();

   int totalOrders = OrdersTotalByMagic(magicNumber);
   BarsHeld = util.getPyramidAge(magicNumber);
//   Print("OCOMMON Message: "+ocommon.mesg1);

   ulong orderMesg = NULL;
   INDDATA indData;
   RefreshPhysicsData(indData);
   bool isNewCandle = false;
   bool candleTraded = indData.candleTraded;
   int numOfTrades = indData.currBarOrders;


// --- THE POST-FLIGHT TRIGGER ---
   if(indData.newBar) {
      // Capture the state of the latch before the new bar resets it
      if ((activeStrategy == 4)||(activeStrategy == 5)) {
         util.postFlightLog(indData, activeStrategy, ocommon.newCandleGate);
      } else if (activeStrategy == 1) {
         util.postFlightLog(indData, activeStrategy, ocommon.newCandleGate);
      }
      Print("🔄 GLOBAL RESET: New bar started. Performance Logged.");
   }


   if(indData.newBar) {
      ocommon.newCandleGate = true;
   }

   if(!(indData.newBar) && (numOfTrades > 0) && indData.candleTraded) {
      ocommon.newCandleGate = false;
   }

// Steering
   SIGBUFF signals;

   if (activeStrategy == 1) {
      signals = st1.imaSt2(indData);
      isNewCandle = ocommon.newCandleGate;
   } else {
      signals = st1.imaSt3(indData);
      isNewCandle = ocommon.newCandleGate;
   }

   SAN_SIGNAL direction = (SAN_SIGNAL)signals.buff1[0];
   SAN_SIGNAL closeSIG = (SAN_SIGNAL)signals.buff2[0];

   int marketAction =        ms.getMarketActionCombinedScore(indData);


// Decisions
   double b = indData.bayesianHoldScore;
   double n = indData.neuronHoldScore;
   double f = indData.fMSR_Norm;
   double f_Raw = indData.fMSR_Raw;
   double fra = indData.fractalAlignment;

   double absF = MathAbs(f);

   double totalConf = MathPow(absF+0.01, 1.0) * MathPow(n+0.01, 1.2) * MathPow(b+0.01, 1.5);
   int cobbsDouglasAction = ms.getCobbDouglasCombinedScore(b, n, f, fra);
   int physicsAction = ms.getHyperbolicCombinedScore(b, n,f_Raw, fra);

   PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %d",
               b, n, f, fra, totalConf, cobbsDouglasAction);

   PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %d",
               b, n, f, fra, physicsAction);

// ===============================================
// THE TRINITY CONSENSUS & PHASE TRIGGER
// ===============================================

   bool hasConsensus = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 1);
   bool hasCollapse  = (physicsAction == -1 || cobbsDouglasAction == -1 || marketAction == -1);

//   double absF = MathAbs(f);
//bool isSqueeze = (absF <= 0.15);
   bool isSqueeze = (absF <= 0.4);


   SAN_SIGNAL vanguardSignal = (SAN_SIGNAL)signals.buff5[0];
   if (vanguardSignal == SAN_SIGNAL::NOSIG) {
      vanguardSignal = (SAN_SIGNAL)signals.buff5[1];
   }

////SAN_SIGNAL triggerSignal = isSqueeze ? vanguardSignal : direction;
//SAN_SIGNAL triggerSignal =  direction;

// 1. Switch off consensus, use purely tactical direction
//SAN_SIGNAL triggerSignal = direction;
//// === PURE VOLATILITY FOR STRATEGY 4 (Harvester) ===
//   SAN_SIGNAL triggerSignal = ((activeStrategy == 4)&&(isNewCandle))
//                              ? (SAN_SIGNAL)signals.buff5[0]
//                              : direction;
//
//// 2. THE SQUEEZE BLOCKER (Your Pseudo-Code Translated)
//
//// 2. THE AUTOMATED STATE MACHINE
//   if (!isSqueeze) {
//      // --- STATE A: MACRO EXPANSION ---
//      // Sages are REQUIRED. If no consensus, kill the signal.
//      if (!hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG) {
//         triggerSignal = SAN_SIGNAL::NOSIG;
//         Print("🛡️ EXPANSION: Tactical signal fired, but Sages vetoed. Waiting for consensus.");
//      }
//   } else {
//      // --- STATE B: COMPRESSION SQUEEZE ---
//      // Sages are BYPASSED. The Squeeze Blocker takes over.
//      if (indData.baseSlope == 1 && triggerSignal == SAN_SIGNAL::BUY) {
//         triggerSignal = SAN_SIGNAL::NOSIG;
//         Print("🛑 BUY SQUEEZE: Trend is UP, buyers exhausted. BUY blocked, waiting for SELL pullback.");
//      } else if (indData.baseSlope == -1 && triggerSignal == SAN_SIGNAL::SELL) {
//         triggerSignal = SAN_SIGNAL::NOSIG;
//         Print("🛑 SELL SQUEEZE: Trend is DOWN, sellers exhausted. SELL blocked, waiting for BUY pullback.");
//      }
//   }

// ===============================================
// THE AUTOMATED STATE MACHINE (WITH DEBUG LOGS)
// ===============================================
   SAN_SIGNAL triggerSignal = ((activeStrategy == 4)||(activeStrategy == 5))
                              ? (SAN_SIGNAL)signals.buff5[0]
                              : direction;

   if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {

      if (!isSqueeze) {
         // --- EXPANSION GATE CHECK ---
         if (!hasConsensus) {
            PrintFormat("🔍 DEBUG: [%s] Expansion Signal %s VETOED by Sages. (Phy:%d, Cobb:%d, Mkt:%d)",
                        _Symbol, util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
            triggerSignal = SAN_SIGNAL::NOSIG;
         }
      } else {
         // --- SQUEEZE BLOCKER CHECK ---
         if (indData.baseSlope == 1 && triggerSignal == SAN_SIGNAL::BUY) {
            PrintFormat("🔍 DEBUG: [%s] Buy Squeeze Detected. Blocked %s to prevent Trend Exhaustion trap.",
                        _Symbol, util.getSigString(triggerSignal));
            triggerSignal = SAN_SIGNAL::NOSIG;
         } else if (indData.baseSlope == -1 && triggerSignal == SAN_SIGNAL::SELL) {
            PrintFormat("🔍 DEBUG: [%s] Sell Squeeze Detected. Blocked %s to prevent Trend Exhaustion trap.",
                        _Symbol, util.getSigString(triggerSignal));
            triggerSignal = SAN_SIGNAL::NOSIG;
         }
      }

      if (triggerSignal != SAN_SIGNAL::NOSIG) {
         PrintFormat("🚀 DEBUG: [%s] %s Signal AUTHORIZED for Strategy %d.",
                     _Symbol, util.getSigString(triggerSignal), activeStrategy);
      }
   }

   double convictionFactor = isSqueeze ? 0.75 : 1.0;
   double baseLots = microLots * minLotSize;
   double dynamicLots = baseLots * convictionFactor;

// Get broker's lot step (usually 0.01)
   double lotStep = MarketInfo(_Symbol, MODE_LOTSTEP);

// Mathematically round to the nearest valid broker step
// If your broker uses 0.01 increments, that is 2 decimal places.
   dynamicLots = NormalizeDouble(MathRound(dynamicLots / lotStep) * lotStep, 2);

// Failsafe: Ensure it never drops below the terminal minimum
   if (dynamicLots < minLotSize) dynamicLots = minLotSize;



   if(isNewCandle) {
      PrintFormat("🔍 DIAGNOSTIC [%s]: Trigger: %s | Squeeze: %s | Consensus: %s | TotalOrders: %d",
                  _Symbol, util.getSigString(triggerSignal), (isSqueeze?"YES":"NO"), (hasConsensus?"YES":"NO"), totalOrders);

      if(triggerSignal == SAN_SIGNAL::NOSIG)
         Print("❌ SILENCE CAUSE: Tactical Brain (imaSt3) returned NOSIG.");
      else if(!hasConsensus && !isSqueeze)
         Print("❌ SILENCE CAUSE: Sages (Physics/Cobb) Vetoed the Expansion trade.");
      else if(indData.currSpread > indData.spreadLimit)
         PrintFormat("❌ SILENCE CAUSE: Spread (%d) is above Limit (%d).", indData.currSpread, indData.spreadLimit);
   }

// Call the modular execution strategy



//################################################################
// EXECUTION ROUTING
//################################################################



// Call the modular execution strategy
   if (activeStrategy == 1) {
      OnEntryExit_1(
         totalOrders, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction, orderMesg
      );
   } else if (activeStrategy == 2) {
      OnEntryExit_2(
         totalOrders, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction, orderMesg
      );
   } else if (activeStrategy == 3) {
      OnEntryExit_3(
         totalOrders, isNewCandle, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction, orderMesg
      );
   } else if (activeStrategy == 4) {
      OnEntryExit_4(
         totalOrders, isNewCandle, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction, orderMesg
      );
   } else if (activeStrategy == 5) {
      OnEntryExit_5(
         totalOrders, isNewCandle,candleTraded, numOfTrades,dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction, orderMesg
      );
   }

//else if (activeStrategy == 4) {
//   OnEntryExit_4(
//      totalOrders, isNewCandle, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
//      vanguardSignal, triggerSignal, closeSIG,
//      physicsAction, cobbsDouglasAction, marketAction, orderMesg
//   );
//}


// Data Telemetry
   indData.convictionFactor = convictionFactor;
   if(recordData && isNewCandle)
      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);

}





//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 1: The Phase-Blended Trinity Sniper        |
//+------------------------------------------------------------------+
void OnEntryExit_1(
   const int totalOrders,
   const double dynamicLots,
   const bool hasConsensus,
   const bool hasCollapse,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   ulong& orderMesg
) {

// --- ENTRY LOGIC ---
   if(totalOrders == 0) {
      if(hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         string phaseStr = isSqueeze ? "COMPRESSION SQUEEZE" : "MACRO EXPANSION";

         PrintFormat("⚡ SNIPER [%s]: Sages Approved. Trigger dictates: %s. (Lots: %.2f)",
                     phaseStr, util.getSigString(triggerSignal), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
         BarsHeld = 0; // Note: BarsHeld is a global variable

      } else if(triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         PrintFormat("🛡️ ENTRY BLOCKED: Trigger %s fired, but Sages vetoed (Phy:%d, Cobb:%d, Mkt:%d)",
                     util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
      }
   }

// --- EXIT LOGIC ---
   else {
      SAN_SIGNAL tradePosition = util.getTradePosition(); // Relies on global 'util'

      // EXIT A: MACRO COLLAPSE
      if(hasCollapse) {
         PrintFormat("🚨 GOVERNANCE: Macro Collapse Detected (Phy:%d, Cobb:%d, Mkt:%d). Forcing Exit.",
                     physicsAction, cobbsDouglasAction, marketAction);
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }
      // EXIT B: TACTICAL TRAP
      else if (!isSqueeze && vanguardSignal != SAN_SIGNAL::NOSIG && util.oppSignal(tradePosition, vanguardSignal)) {
         PrintFormat("🚨 GOVERNANCE: Tactical Trap! Vanguard violently flipped to %s. EJECTING.",
                     util.getSigString(vanguardSignal));
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }
      // EXIT C: STANDARD CLOSE
      else if(closeSIG == SAN_SIGNAL::CLOSE) {
         Print("🛡️ GOVERNANCE: Standard Close Signal honored. Exiting.");
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }

      if(GetLastError() != ERR_NO_ERROR)
         Print("Order result: ", orderMesg, " :: Last Error: ", util.getUninitReasonText(GetLastError()));
   }
}

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 2: Continuous Pyramiding & Flip-Reversal   |
//+------------------------------------------------------------------+
void OnEntryExit_2(
   int& totalOrders,
   const double dynamicLots,
   const bool hasConsensus,
   const bool hasCollapse,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   ulong& orderMesg
) {

   SAN_SIGNAL tradePosition = util.getTradePosition();

// --- EXIT LOGIC (The Flip & The Failsafe) ---
   if (totalOrders > 0) {
      // Failsafe: Total Macro Collapse
      if (hasCollapse) {
         PrintFormat("🚨 STRATEGY 2: Macro Collapse Detected. Liquidating %d positions.", totalOrders);
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
         totalOrders = 0; // <--- UPDATE STATE
         return; // Abort further action on this candle
      }

      // The Flip Reversal: If Sages scream SELL, but we hold BUYs -> Close all BUYs.
      if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         if (util.oppSignal(tradePosition, triggerSignal)) {
            PrintFormat("🔄 STRATEGY 2: Market violently flipped from %s to %s! Liquidating portfolio.",
                        util.getSigString(tradePosition), util.getSigString(triggerSignal));
            orderMesg = util.closeOrders(magicNumber);
            BarsHeld = 0;
            totalOrders = 0;
            tradePosition = SAN_SIGNAL::NOSIG; // Reset state so we can immediately enter the new direction
         }
      }
   }

// --- ENTRY LOGIC (Continuous Piling) ---
// Notice there is NO "if(totalOrders == 0)" here. It will run every single candle.
   if ((totalOrders < maxPyramidTrades)) {
      if (hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {

         PrintFormat("📈 STRATEGY 2: Trend is %s. Adding position #%d to the portfolio. (Lots: %.2f)",
                     util.getSigString(triggerSignal), (totalOrders + 1), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
         BarsHeld = 0; // Reset holding time since we just modified the portfolio

      }
   } else {
      //  Print("🛡️ STRATEGY 2: Max pyramid capacity reached. Riding the trend without adding more.");
   }
}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 3: Tactical Pyramiding with Auto-Pruning   |
//+------------------------------------------------------------------+
void OnEntryExit_3(
   int& totalOrders,
   const bool isNewCandle,
   const double dynamicLots,
   const bool hasConsensus,
   const bool hasCollapse,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   ulong& orderMesg
) {

// --- EXIT LOGIC (The Automated Gardener / Pruner) ---
// OPTIMIZATION: Only evaluate the weeds once per candle!
   if ((totalOrders > 0) && isNewCandle) {

      // Call the plugin! Cut negative trades older than 4 bars.
      int prunedWeeds = util.pruneTrades(magicNumber, 4, 30);

      // If we pruned anything, update the totalOrders count for the Entry Logic below
      if (prunedWeeds > 0) {
         totalOrders = OrdersTotalByMagic(magicNumber);
         // NOTE: Do NOT set BarsHeld = 0 here anymore! getPyramidAge() handles it.
      }
   }

// --- ENTRY LOGIC (Continuous Piling) ---
   if (totalOrders < maxPyramidTrades) {

      // Strategy 3 ignores Sages (hasConsensus), relies only on tactical signal
      if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {

         PrintFormat("📈 STRATEGY 3: Tactical Trend is %s. Adding position #%d to the portfolio. (Lots: %.2f)",
                     util.getSigString(triggerSignal), (totalOrders + 1), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);

         // NOTE: Do NOT set BarsHeld = 0 here! If you do, the Sages forget the age of the trend.
      }
   }
}
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 4: Pure Volatility Harvester (1 per candle)|
//+------------------------------------------------------------------+
void OnEntryExit_4(
   const int totalOrders,
   const bool isNewCandle,
   const double dynamicLots,
   const bool hasConsensus,
   const bool hasCollapse,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   ulong& orderMesg
) {

// === 1. PYRAMID LIMIT ===
   if (totalOrders >= maxPyramidTrades) return;

// === 2. ONE ENTRY PER CANDLE ONLY ===
// We use the exact same gate that imaSt3 already computed
   if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
      PrintFormat("🚜 HARVESTER: Volatility Signal → %s | Lots: %.2f | Candle: %s",
                  util.getSigString(triggerSignal), dynamicLots,
                  TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));

      orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                  (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
      BarsHeld = 0;
   }
}


//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 4/5: Pure Volatility Harvester             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 5: Pure Volatility Harvester + Smart Pruner|
//+------------------------------------------------------------------+
void OnEntryExit_5(
   int& totalOrders,
   const bool isNewCandle,
   const bool candleTraded,
   const int numOfTrades,
   const double dynamicLots,
   const bool hasConsensus,
   const bool hasCollapse,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   ulong& orderMesg
) {

   if(isNewCandle) {
      util.cleanUpOrphanedMemory();
   }

// === 1. EXIT LOGIC (Pruners run first) ===
   if(totalOrders > 0) {
      int weedsCut = 0;
      int profitsHarvested = 0;

      if(isNewCandle) {
         int pruneAge = (int)MathFloor(maxPyramidTrades / 4.0);
         // Fixed: Hardcoded 4 bars (MT4 standard for quick weed removal)
         weedsCut = util.pruneTrades(magicNumber, pruneAge, 30);
      }

      // Profit Harvester runs every tick (correct)
      // Raised threshold to 300 points (~30 pips) + can be made ATR-based later
      profitsHarvested = util.pruneByTrailingProfit(magicNumber, 0.80, 300, 30);

      if(weedsCut > 0 || profitsHarvested > 0) {
         totalOrders = OrdersTotalByMagic(magicNumber);
      }
   }

// === 2. PYRAMID LIMIT ===
   if(totalOrders >= maxPyramidTrades) return;

// === 3. ENTRY LOGIC — FIXED: isNewCandle gate restored ===
// This is the single highest-leverage fix — one trade per candle only
   if(isNewCandle && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
      PrintFormat("🚜 HARVESTER: Volatility Signal → %s | Lots: %.2f | Candle: %s",
                  util.getSigString(triggerSignal), dynamicLots,
                  TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));

      orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                  (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
      ocommon.newCandleGate=false;
   }
}

