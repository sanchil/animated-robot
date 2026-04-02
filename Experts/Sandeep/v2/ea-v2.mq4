//+------------------------------------------------------------------+
//|                                                         ea-v2.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#define M_PI 3.14159265358979323846

// ea-v2.mq4 - TOP SECTION
#include <Sandeep/v2/SanStrategies-v2.mqh> // This now "owns" SanSignals

input ulong magicNumber = 1002; // MagicNumber
input int activeStrategy = 3; // 1: Trinity Sniper, 2: Trend Pyramiding
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
INDDATA_CB indData_cb;
bool g_cbWarmedUp = false;
const double SQUEEZE_LIMIT = 0.4; //SqueezeLimit
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
bool printStatus = true;
//double ciTradeSig; // buff4 : Trade NoTrade signal.
//double ciMktType; // buff4 : Set Market type: Trending or Flat.

bool TRADESWITCH = true;
ORDERPARAMS opMain;

double pipValue;

//int vSIG[12][5];


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   EventSetTimer(1);
   opMain.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
   closeProfit = opMain.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = opMain.STOPLOSS;
   currProfit = opMain.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = opMain.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
   pipValue = util.getPipValue(_Symbol);
// --- RECOVERY LOGIC ---
//   BarsHeld = 0;
   BarsHeld = util.getPyramidAge(magicNumber);

//   if(OrdersTotalByMagic(magicNumber) > 0) {
//      for(int i = OrdersTotal()-1; i >= 0; i--) {
//         if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {
//
//            // Calculate actual printed bars elapsed since the order was opened
//            // iBarShift handles weekends, holidays, and missing data automatically
//            BarsHeld = iBarShift(_Symbol, PERIOD_CURRENT, OrderOpenTime());
//
//            break; // Breaks after finding the first one (which is the oldest due to the loop order)
//         }
//      }
//   }

   ocommon.magicNumber = magicNumber;
   ocommon.activeStrategy = activeStrategy;
   ocommon.noOfCandles=noOfCandles;
   ocommon.SHIFT=SHIFT;
   ocommon.microLots = microLots;
   ocommon.minLotSize = minLotSize;
   ocommon.maxMultiplier = maxMultiplier;
   ocommon.maxPyramidTrades = maxPyramidTrades;
   ocommon.TAKEPROFIT = TAKE_PROFIT;
   ocommon.STOPLOSS = STOP_LOSS;
   ocommon.physicsWeight = physicsWeight;
   ocommon.cobbWeight = cobbWeight;
   ocommon.cloudWeight = cloudWeight;
   ocommon.consensusThreshold = consensusThreshold;
   ocommon.pipValue = pipValue;

// Following state is modifiable.
   ocommon.g_cbWarmedUp = g_cbWarmedUp;
   ocommon.BarsHeld=BarsHeld;
   ocommon.isNewBar = false;

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


//
////+------------------------------------------------------------------+
////| Count only orders with our magic number                          |
////+------------------------------------------------------------------+
//int OrdersTotalByMagic(ulong magic) {
//   int cnt = 0;
//   for(int i = OrdersTotal()-1; i >= 0; i--)
//      if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magic)
//         cnt++;
//   return cnt;
//}
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshAll_CB(INDDATA_CB &data, STRATEGY_STATE& ocommon) {
   if(!ocommon.g_cbWarmedUp) {
      st1.WarmUpCache_CB(data,ocommon);
      g_cbWarmedUp = true;
      ocommon.g_cbWarmedUp = true;
   } else if(ocommon.isNewBar) {
      st1.PushNewBar_CB(data,ocommon);
   }
   st1.RefreshLiveScalars_CB(data,ocommon);
}

//+------------------------------------------------------------------+
//| GOVERNANCE MODULE: Manages Macro Panics, Tactical Exits & Pruning|
//+------------------------------------------------------------------+
//void ManageRiskAndExits(
//   STRATEGY_STATE& ocommon,
//   int& totalOrders,
//   const bool isNewCandle,
//   const bool hasCollapse,
//   const int physicsAction,
//   const SAN_SIGNAL triggerSignal,
//   const SAN_SIGNAL closeSIG,
//   const double atrRaw,
//   const bool printLogs
//) {
//   if (totalOrders <= 0) return; // Fast return if portfolio is empty
//
//   bool fullLiquidation = false;
//
//// 1. MACRO PANIC: Check Sages First (They bypass everything)
//   bool sagesWantOut = hasCollapse;
//
//   if (sagesWantOut && (ocommon.BarsHeld >= 2)) {
//      if(printLogs && isNewCandle) Print("🚨 MACRO COLLAPSE: Sages forced emergency liquidation. Shield bypassed.");
//      util.closeOrders(ocommon.magicNumber);
//      totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//      ocommon.BarsHeld = 0;
//      fullLiquidation = true;
//   }
//
//// 2. TACTICAL CLOSE: Check Fast Trigger (Needs the Trade Shield)
//   else if((triggerSignal == SAN_SIGNAL::CLOSE)||(closeSIG == SAN_SIGNAL::CLOSE)) {
//      bool enoughHoldTime = (ocommon.BarsHeld >= 5);
//
//      if(enoughHoldTime) {
//         if(printLogs) PrintFormat("🛡️ MATURE EXIT: Trade held for %d bars. Fast CLOSE accepted.", ocommon.BarsHeld);
//         util.closeOrders(ocommon.magicNumber);
//         totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//         ocommon.BarsHeld = 0;   // reset for next entry
//         fullLiquidation = true;
//      } else if (printLogs && isNewCandle) {
//         PrintFormat("🛡️ SHIELD ACTIVE: Ignored CLOSE signal. Trade age is %d/5 bars.", ocommon.BarsHeld);
//      }
//   }
//
//// 3. MAINTENANCE (PRUNERS): Trim the fat ONLY if the basket survived
//   if (!fullLiquidation) {
//      /*
//      int weedsCut = 0;
//      int profitsHarvested = 0;
//      int reverseTrades = 0;
//      int profitThreshold  = (int)ms.atrScale(atrRaw, 100, 1000);
//
//      if(isNewCandle) {
//         // int pruneAge = MathMax(3, (int)MathFloor(ocommon.maxPyramidTrades / 4.0));
//         // weedsCut = util.pruneTrades(ocommon.magicNumber, pruneAge, 30);
//         // reverseTrades = util.pruneReverseTrades(ocommon.magicNumber, triggerSignal, 30);
//      }
//
//      // profitsHarvested = util.pruneByTrailingProfit(ocommon.magicNumber, 0.80, profitThreshold, 30);
//
//      if(weedsCut > 0 || profitsHarvested > 0 || reverseTrades > 0) {
//         if(printLogs) PrintFormat("✂️ PRUNER: Weeds Cut: %d | Reverse: %d | Profits Harvested: %d", weedsCut, reverseTrades, profitsHarvested);
//         totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//      }
//      */
//   }
//}


//void ManageRiskAndExits(
//   STRATEGY_STATE& ocommon,
//   int& totalOrders,
//   const bool isNewCandle,
//   const bool hasCollapse,
//   const int physicsAction,
//   const SAN_SIGNAL triggerSignal,
//   const SAN_SIGNAL closeSIG,
//   const double atrRaw,
//   const bool printLogs
//) {
//   if (totalOrders <= 0) return;
//
//   bool fullLiquidation = false;
//
//   // 1. MACRO PANIC (unchanged)
//   if (hasCollapse && (ocommon.BarsHeld >= 2)) {
//      if(printLogs && isNewCandle) Print("🚨 MACRO COLLAPSE: Sages forced emergency liquidation.");
//      util.closeOrders(ocommon.magicNumber);
//      totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//      ocommon.BarsHeld = 0;
//      fullLiquidation = true;
//   }
//
//   // 2. FAST TACTICAL CLOSE — now ATR + timeframe adaptive
//   else if((triggerSignal == SAN_SIGNAL::CLOSE) || (closeSIG == SAN_SIGNAL::CLOSE)) {
//      // Adaptive shield: shorter on M1, longer on higher TFs
//      int adaptiveHoldBars = 3;
//      if(_Period >= PERIOD_H1)   adaptiveHoldBars = 4;   // 4 hours on H1
//      else if(_Period >= PERIOD_M15) adaptiveHoldBars = 3; // 45 min on M15
//      // M1/M5 stays at 3 bars
//
//      bool enoughHoldTime = (ocommon.BarsHeld >= adaptiveHoldBars);
//
//      if(enoughHoldTime) {
//         if(printLogs) PrintFormat("🛡️ FAST EXIT: Trade held for %d bars (adaptive). CLOSE accepted.", ocommon.BarsHeld);
//         util.closeOrders(ocommon.magicNumber);
//         totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//         ocommon.BarsHeld = 0;
//         fullLiquidation = true;
//      }
//      else if (printLogs && isNewCandle) {
//         PrintFormat("🛡️ SHIELD ACTIVE: Ignored CLOSE (age %d/%d bars).", ocommon.BarsHeld, adaptiveHoldBars);
//      }
//   }
//
//   // 3. PROFIT PROTECTOR — now looser when ATR is higher (your exact philosophy)
//   if (!fullLiquidation && totalOrders > 0 && isNewCandle) {
//      double retainPct = 0.80;                     // base
//      if(atrRaw > 0.0003) retainPct = 0.75;       // higher volatility → let it breathe more
//      if(atrRaw > 0.0006) retainPct = 0.70;       // very high ATR → even looser
//
//      int profitsHarvested = util.pruneByTrailingProfit(ocommon.magicNumber, retainPct, 0, 30);
//      if(profitsHarvested > 0 && printLogs) {
//         PrintFormat("✂️ PROFIT PROTECTOR: Harvested %d trades at %.0f%% trailing.", profitsHarvested, retainPct*100);
//         totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
//      }
//   }
//}


//+------------------------------------------------------------------+
//| UNIVERSAL RISK & EXIT GOVERNANCE — uses your atrScale + atrKinetic |
//+------------------------------------------------------------------+
void ManageRiskAndExits(
   STRATEGY_STATE& ocommon,
   int& totalOrders,
   const bool isNewCandle,
   const bool isNoTrade,
   const int physicsAction,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const double atrRaw,
   const bool printLogs
) {
   if(totalOrders <= 0) return;

   bool fullLiquidation = false;

// Use your scaler: min=2 bars (M1), max=5 bars (H4+)
   int adaptiveHoldBars = (int)ms.atrScale(atrRaw, 2.0, 5.0);   // ← your atrScale + atrKinetic does the TF magic
   adaptiveHoldBars = MathMax(2, adaptiveHoldBars);           // safety floor

   bool enoughHoldTime = (ocommon.BarsHeld >= adaptiveHoldBars);


// 1. MACRO PANIC (sage collapse) — keep 2-bar emergency gate (very fast on any TF)
//   if(hasCollapse && (ocommon.BarsHeld >= 2)) {
   if(isNoTrade && (ocommon.BarsHeld >= 2) && false) {
      if(printLogs && isNewCandle)
         Print("🚨 MACRO COLLAPSE: Sages forced emergency liquidation.");
      util.closeOrders(ocommon.magicNumber);
      totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
      ocommon.BarsHeld = 0;
      fullLiquidation = true;
   }
// 3. FAST TACTICAL CLOSE — now fully scaled with your atrScale
   else if((closeSIG == SAN_SIGNAL::CLOSE)&&enoughHoldTime) {

      //if(enoughHoldTime) {
      if(printLogs)
         PrintFormat("🛡️ FAST EXIT: Trade held for %d bars (adaptive). CLOSE accepted.", ocommon.BarsHeld);
      util.closeOrders(ocommon.magicNumber);
      totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
      ocommon.BarsHeld = 0;
      fullLiquidation = true;
      //}

   } else if(printLogs && isNewCandle) {
      PrintFormat("🛡️ SHIELD ACTIVE: Ignored CLOSE (age %d/%d bars).", ocommon.BarsHeld, adaptiveHoldBars);
   }

// 3. PROFIT PROTECTOR — trailing % now scales with volatility
   if(!fullLiquidation && totalOrders > 0 && isNewCandle && false) {

      // Higher ATR → looser trailing (let winners breathe)
      double retainPct = ms.atrScale(atrRaw, 0.70, 0.85);   // 70 % on very high ATR, 85 % on low ATR

      int profitsHarvested = util.pruneByTrailingProfit(ocommon.magicNumber, retainPct, 0, 30);
      if(profitsHarvested > 0 && printLogs) {
         PrintFormat("✂️ PROFIT PROTECTOR: Harvested %d trades at %.0f%% trailing.",
                     profitsHarvested, retainPct*100);
         totalOrders = util.OrdersTotalByMagic(ocommon.magicNumber);
      }
   }
}

//+------------------------------------------------------------------+
//| ENTRY MODULE: Evaluates Limits, Approvals, and Executes Trades   |
//+------------------------------------------------------------------+
void ManageEntries(
   STRATEGY_STATE& ocommon,
   const int totalOrders,
   const bool isNewCandle,
   const bool isTrade,
   const bool isEntryApproved,      // Allows specific strategies to require 'hasConsensus'
   const SAN_SIGNAL triggerSignal,
   const double dynamicLots,
   const string strategyName,       // For clean logging (e.g., "🚜 HARVESTER")
   const bool printLogs,
   ulong& orderMesg
) {
// === 1. PYRAMID LIMIT ===
   if(totalOrders >= ocommon.maxPyramidTrades) return;

// === 2. EXECUTION GATE ===
// Must be a new candle, must be approved by strategy rules, and must have a valid directional signal
   if(isNewCandle &&
         isEntryApproved &&
//isTrade &&
         triggerSignal != SAN_SIGNAL::NOSIG &&
         triggerSignal != SAN_SIGNAL::SIDEWAYS &&
         triggerSignal != SAN_SIGNAL::CLOSE ) {

      if(printLogs) {
         PrintFormat("%s: Volatility Signal → %s | Lots: %.2f | Candle: %s",
                     strategyName,
                     util.getSigString(triggerSignal),
                     dynamicLots,
                     TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));
      }

      // Execute Order
      int cmd = (triggerSignal == SAN_SIGNAL::BUY) ? OP_BUY : OP_SELL;
      orderMesg = util.placeOrder(ocommon.magicNumber, dynamicLots, cmd, 30, 0, 0);

      // Close the internal state gate to strictly enforce 1-trade-per-candle
      ocommon.newCandleGate = false;
   }
}

void OnCycleTask1() {

// 1. Capture Bar State ONCE per tick
   bool isNewBar = util.isNewBarTime();
   int totalOrders = util.OrdersTotalByMagic(magicNumber);
   ocommon.isNewBar = isNewBar;
//BarsHeld = util.getPyramidAge(magicNumber);
//ocommon.BarsHeld = BarsHeld;
//   Print("OCOMMON Message: "+ocommon.mesg1);

   ulong orderMesg = NULL;
   INDDATA indData;

   st1.RefreshPhysicsData(indData,ocommon);
   ocommon.BarsHeld = indData.BarsHeld;

//   RefreshAll_CB(indData_cb,ocommon);
//
//   if(MathAbs(indData.ima30[1] - indData_cb.ima30.get(1)) > _Point) {
//      PrintFormat("⚠️ CB MISMATCH ima30[1]: old=%.5f cb=%.5f",
//                  indData.ima30[1], indData_cb.ima30.get(1));
//   } else {
//      PrintFormat("⚠️ CB MATCHED ima30[1]: old=%.5f cb=%.5f, Match : %s",
//                  indData.ima30[1], indData_cb.ima30.get(1),
//                  util.boolToStr((MathAbs(indData.ima30[1] - indData_cb.ima30.get(1)) < _Point)));
//   }

   int SHIFT = indData.shift;
   bool isNewCandle = false;
   bool candleTraded = indData.candleTraded;
   int numOfTrades = indData.currBarOrders;
   double atrRaw = indData.atr[SHIFT];

   if(indData.newBar) {
      util.postFlightLog(indData, activeStrategy, ocommon.newCandleGate);
      if(printStatus)Print("🔄 GLOBAL RESET: New bar started. Performance Logged.");
   }


   if(indData.newBar) {
      ocommon.newCandleGate = true;
   }

   if(!(indData.newBar) && (numOfTrades > 0) && indData.candleTraded) {
      ocommon.newCandleGate = false;
   }


// Steering
   SIGBUFF signals;

   isNewCandle = ocommon.newCandleGate;



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
   int marketAction = ms.getMarketActionCombinedScore(indData);



// ===============================================
// THE TRINITY CONSENSUS & PHASE TRIGGER
// ===============================================

//bool hasConsensus = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 1);
//bool hasCollapse  = (physicsAction == -1 && cobbsDouglasAction == -1 && marketAction == -1);


   bool hasConsensus = (((physicsAction == 1) || (cobbsDouglasAction == 1)) && marketAction == 1);
   bool isRebirth = (physicsAction == -1 && cobbsDouglasAction == 1 && marketAction == 1);
   bool isIgnition = (physicsAction == 0 && cobbsDouglasAction == 1 && marketAction == 1);

   bool isReinforce = (physicsAction == 1 && cobbsDouglasAction == 0 && marketAction == 1);
   bool isGrind = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 0);
   bool isSaturation  = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 0);



   bool hasCollapse  = (physicsAction == -1 && cobbsDouglasAction == -1 && marketAction == -1);
   bool isRot  = (physicsAction == 1 && cobbsDouglasAction == -1 && marketAction == 1);
   bool isMutiny  = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == -1);
   bool isApathy  = (physicsAction == 0 && cobbsDouglasAction == 0 && marketAction == 0);
   bool isTrap  = (physicsAction == 0 && cobbsDouglasAction == 0 && marketAction == 1);
   bool isDesertion  = (physicsAction == 1 && cobbsDouglasAction == -1 && marketAction == -1);
   bool isInertia = (physicsAction == 1 && cobbsDouglasAction == 0 && marketAction == -1);

   bool isTrade = (hasConsensus||isRebirth||isIgnition||isReinforce);
   bool isNoTrade = !isTrade;


//   double absF = MathAbs(f);
//bool isSqueeze = (absF <= 0.15);
   bool isSqueeze = (absF <= SQUEEZE_LIMIT);

   if(printStatus) {
      PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %d",
                  b, n, f, fra, totalConf, cobbsDouglasAction);

      PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %d",
                  b, n, f, fra, physicsAction);


      PrintFormat("[ACTION] Market: %.2f | Physics: %.2f | Cobb: %.2f | Squeeze: %s "
                  , marketAction, physicsAction,cobbsDouglasAction,util.boolToStr(isSqueeze));


   }


   if (activeStrategy == 1) {
      signals = st1.imaSt2(indData);
   } else {
      signals = st1.imaSt3(indData);
   }

   SAN_SIGNAL direction = (SAN_SIGNAL)signals.buff1[0];
   SAN_SIGNAL closeSIG = (SAN_SIGNAL)signals.buff2[0];



   SAN_SIGNAL vanguardSignal = (SAN_SIGNAL)signals.buff5[0];
   if (vanguardSignal == SAN_SIGNAL::NOSIG) {
      vanguardSignal = (SAN_SIGNAL)signals.buff5[1];
   }


// #####################################################################################################

// ===============================================
// THE AUTOMATED STATE MACHINE (WITH DEBUG LOGS)
// ===============================================
//SAN_SIGNAL triggerSignal = ((activeStrategy == 4)||(activeStrategy == 5))
//                           ? (SAN_SIGNAL)signals.buff5[0]
//                           : direction;
//SAN_SIGNAL triggerSignal = direction;


// ####################################################################################################
// #################### SQUEEZE BLOCK #################################################################
// ####################################################################################################

// 2. Apply squeeze filter to entry direction only
   SAN_SIGNAL triggerSignal = sig.squeezeFilter(
                                 indData.fMSR_Norm,
                                 (double)indData.baseSlope,
                                 direction,
                                 SQUEEZE_LIMIT                   // raw direction, not closeSIG
                              );



// 3. Conviction sizing
   bool squeezeReversal = ms.isSqueezeReversal(
                             indData.fMSR_Norm,
                             (double)indData.baseSlope,
                             direction,
                             SQUEEZE_LIMIT                   // pre-filter so reversal is detectable
                          );
   Print("[SQPARAMS]: Squeeze: "+isSqueeze+" Squeeze reversal: "+squeezeReversal+" Squeezed trigger: "+ util.getSigString(triggerSignal));
// #################### SQUEEZE BLOCK #################################################################


//double convictionFactor = isSqueeze ? 0.75 : 1.0;
   double convictionFactor = (!isSqueeze)? 1.0
                             :((squeezeReversal)?0.55 :0.75);

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
      if(printStatus) PrintFormat("🔍 DIAGNOSTIC [%s]: Trigger: %s | Squeeze: %s | Consensus: %s | TotalOrders: %d",
                                     _Symbol, util.getSigString(triggerSignal), (isSqueeze?"YES":"NO"), (hasConsensus?"YES":"NO"), totalOrders);

      // FIXED: Added explicit scope so the compiler evaluates the logic correctly
      if(triggerSignal == SAN_SIGNAL::NOSIG) {
         if(printStatus) Print("❌ SILENCE CAUSE: Tactical Brain (imaSt3) returned NOSIG.");
      } else if(!hasConsensus && !isSqueeze) {
         if(printStatus) Print("❌ SILENCE CAUSE: Sages (Physics/Cobb) Vetoed the Expansion trade.");
      } else if(indData.currSpread > indData.spreadLimit) {
         if(printStatus) PrintFormat("❌ SILENCE CAUSE: Spread (%d) is above Limit (%d).", indData.currSpread, indData.spreadLimit);
      }
   }

// Call the modular execution strategy



//################################################################
// EXECUTION ROUTING
//################################################################

// Call the modular execution strategy
   if (activeStrategy == 1) {
      OnEntryExit_1(
         ocommon,
         totalOrders, dynamicLots, isTrade, isNoTrade, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw,orderMesg
      );

   } else if (activeStrategy == 2) {
      OnEntryExit_2(
         ocommon,
         totalOrders, isNewCandle, dynamicLots, isTrade, isNoTrade, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw, orderMesg
      );
   } else if (activeStrategy == 3) {
      OnEntryExit_3(
         ocommon,
         totalOrders, isNewCandle,candleTraded, numOfTrades,dynamicLots, isTrade, isNoTrade, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw, orderMesg
      );
   }

// Data Telemetry
   indData.convictionFactor = convictionFactor;
   if(recordData && isNewCandle)
      st1.writeOHLCVJsonData(dataFileName, indData, util, 1);

}





//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 1: The Phase-Blended Trinity Sniper        |
//+------------------------------------------------------------------+
void OnEntryExit_1(
   STRATEGY_STATE& ocommon,
   const int totalOrders,
   const double dynamicLots,
   const bool isTrade,
   const bool isNoTrade,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   const double atrRaw,
   ulong& orderMesg
) {

// --- ENTRY LOGIC ---
   if(totalOrders == 0) {
      if(isTrade && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         string phaseStr = isSqueeze ? "COMPRESSION SQUEEZE" : "MACRO EXPANSION";

         if(printStatus)PrintFormat("⚡ SNIPER [%s]: Sages Approved. Trigger dictates: %s. (Lots: %.2f)",
                                       phaseStr, util.getSigString(triggerSignal), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
         //BarsHeld = 0; // Note: BarsHeld is a global variable
         ocommon.BarsHeld = 0;

      } else if(triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         if(printStatus)PrintFormat("🛡️ ENTRY BLOCKED: Trigger %s fired, but Sages vetoed (Phy:%d, Cobb:%d, Mkt:%d)",
                                       util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
      }
   }

// --- EXIT LOGIC ---
   else {
      SAN_SIGNAL tradePosition = util.getTradePosition(); // Relies on global 'util'

      // EXIT A: MACRO COLLAPSE
      if(isNoTrade) {
         if(printStatus)PrintFormat("🚨 GOVERNANCE: Macro Collapse Detected (Phy:%d, Cobb:%d, Mkt:%d). Forcing Exit.",
                                       physicsAction, cobbsDouglasAction, marketAction);
         orderMesg = util.closeOrders(magicNumber);
         //BarsHeld = 0;
         ocommon.BarsHeld = 0;
      }
      // EXIT B: TACTICAL TRAP
      else if (!isSqueeze && vanguardSignal != SAN_SIGNAL::NOSIG && util.oppSignal(tradePosition, vanguardSignal)) {
         if(printStatus)PrintFormat("🚨 GOVERNANCE: Tactical Trap! Vanguard violently flipped to %s. EJECTING.",
                                       util.getSigString(vanguardSignal));
         orderMesg = util.closeOrders(magicNumber);
         //BarsHeld = 0;
         ocommon.BarsHeld = 0;
      }
      // EXIT C: STANDARD CLOSE
      else if(closeSIG == SAN_SIGNAL::CLOSE) {
         if(printStatus)Print("🛡️ GOVERNANCE: Standard Close Signal honored. Exiting.");
         orderMesg = util.closeOrders(magicNumber);
         //BarsHeld = 0;
         ocommon.BarsHeld = 0;
      }

      if(GetLastError() != ERR_NO_ERROR)
         if(printStatus)Print("Order result: ", orderMesg, " :: Last Error: ", util.getUninitReasonText(GetLastError()));
   }
}

//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 4: Pure Volatility Harvester (1 per candle)|
//+------------------------------------------------------------------+
void OnEntryExit_2(
   STRATEGY_STATE& ocommon,
   int& totalOrders,
   const bool isNewCandle,
   const double dynamicLots,
   const bool isTrade,
   const bool isNoTrade,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   const double atrRaw,
   ulong& orderMesg
) {


// CLOSE block if trigger Singal is CLOSE
   if((triggerSignal == SAN_SIGNAL::CLOSE)||(closeSIG == SAN_SIGNAL::CLOSE)) {
      util.closeOrders(magicNumber);
      totalOrders = util.OrdersTotalByMagic(magicNumber);
   }

   if(totalOrders>0) {
      int reverseTrades = 0;
      if(isNewCandle) {
         reverseTrades = util.pruneReverseTrades(magicNumber,triggerSignal, 30);
      }
      if(reverseTrades>0) {
         totalOrders = util.OrdersTotalByMagic(magicNumber);
      }
   }

// === 1. PYRAMID LIMIT ===
   if (totalOrders >= maxPyramidTrades) return;

// === 2. ONE ENTRY PER CANDLE ONLY ===
// We use the exact same gate that imaSt3 already computed
   if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
      if(printStatus)PrintFormat("🚜 HARVESTER: Volatility Signal → %s | Lots: %.2f | Candle: %s",
                                    util.getSigString(triggerSignal), dynamicLots,
                                    TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));

      orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                  (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
      //BarsHeld = 0;
      ocommon.BarsHeld = 0;
   }
}


//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 4/5: Pure Volatility Harvester             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ENTRY & EXIT STRATEGY 5: Pure Volatility Harvester + Smart Pruner|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnEntryExit_3(
   STRATEGY_STATE& ocommon,
   int& totalOrders,
   const bool isNewCandle,
   const bool candleTraded,
   const int numOfTrades,
   const double dynamicLots,
   const bool isTrade,
   const bool isNoTrade,
   const bool isSqueeze,
   const SAN_SIGNAL vanguardSignal,
   const SAN_SIGNAL triggerSignal,
   const SAN_SIGNAL closeSIG,
   const int physicsAction,
   const int cobbsDouglasAction,
   const int marketAction,
   const double atrRaw,
   ulong& orderMesg
) {

   if(isNewCandle) {
      util.cleanUpOrphanedMemory();
   }

// ======================= 1. EXIT LOGIC (GOVERNANCE) =======================
   ManageRiskAndExits(
      ocommon,
      totalOrders,
      isNewCandle,
      isNoTrade,
      physicsAction,
      triggerSignal,
      closeSIG,
      atrRaw,
      printStatus
   );

// ======================= 2. ENTRY LOGIC (EXECUTION) =======================
// Strategy 5 is a raw Harvester, so 'isEntryApproved' is automatically true.
// If this were Strategy 1, you would pass 'hasConsensus' instead.
   ManageEntries(
      ocommon,
      totalOrders,
      isNewCandle,
      isTrade,
      true,                // isEntryApproved
      triggerSignal,
      dynamicLots,
      "🚜 HARVESTER",      // strategyName
      printStatus,
      orderMesg
   );
}
//+------------------------------------------------------------------+
