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
INDDATA_CB indData_cb;
bool g_cbWarmedUp = false;

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
bool printStatus = false;
//double ciTradeSig; // buff4 : Trade NoTrade signal.
//double ciMktType; // buff4 : Set Market type: Trending or Flat.

bool TRADESWITCH = true;
ORDERPARAMS op3;
double pipValue;

int vSIG[12][5];


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


//double fastSlope = (data.ima14[SHIFT] - data.ima30[3]) / (3 * pipValue);
//double medSlope  = (data.ima30[SHIFT] - data.ima60[10]) / (10 * pipValue);
//double slowSlope = (data.ima60[SHIFT] - data.ima120[30]) / (30 * pipValue);

   double fastSlope = (data.ima14[SHIFT] - data.ima14[5]) / (5 * pipValue);
   double medSlope  = (data.ima30[SHIFT] - data.ima30[10]) / (10 * pipValue);
   double slowSlope = (data.ima60[SHIFT] - data.ima60[30]) / (30 * pipValue);


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
//   data.spreadLimit = ms.getDynamicSpreadLimit(data.atr[1],_Period);
   data.spreadLimit = ms.atrScale(data.atr[1],15,120);



}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshPhysicsData_CB(INDDATA_CB &data) {
   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
   closeProfit = op3.TAKEPROFIT; // Profit at which a trade is condsidered for closing.
   stopLoss = op3.STOPLOSS;
   currProfit = op3.TRADEPROFIT; // The profit of the currently held trade
   maxProfit = op3.MAXTRADEPROFIT; // The current profit is adjusted by subtracting the spread and a margin added.
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


      data.open.push(iOpen(_Symbol, PERIOD_CURRENT, i));
      data.close.push(iClose(_Symbol, PERIOD_CURRENT, i));
      data.tick_volume.push((long)iVolume(_Symbol, PERIOD_CURRENT, i));
      data.ima120.push(iMA(_Symbol, PERIOD_CURRENT, 120, 0, MODE_SMMA, PRICE_CLOSE, i));
      data.ima240.push(iMA(_Symbol, PERIOD_CURRENT, 240, 0, MODE_SMMA, PRICE_CLOSE, i));
      data.ima500.push(iMA(_Symbol, PERIOD_CURRENT, 500, 0, MODE_SMMA, PRICE_CLOSE, i));

      // Heavy computation only for the "active" zone (last 31 bars)
      if(i < 120) {
         data.high.push(iHigh(_Symbol,PERIOD_CURRENT,i));
         data.low.push(iLow(_Symbol,PERIOD_CURRENT,i));
         data.time.push(iTime(_Symbol,PERIOD_CURRENT,i));
         data.std.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_CLOSE, i));
         data.stdOpen.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_OPEN, i));
         data.obv.push(iOBV(_Symbol, PERIOD_CURRENT, PRICE_CLOSE, i));
         data.rsi.push(iRSI(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_WEIGHTED, i));
         data.mfi.push(iMFI(_Symbol, PERIOD_CURRENT,noOfCandles,i));
         data.ima5.push(iMA(_Symbol, PERIOD_CURRENT, 5, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima14.push(iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima30.push(iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima60.push(iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.atr.push(iATR(_Symbol, PERIOD_CURRENT, noOfCandles, i));
         data.adx.push(iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,MODE_MAIN,i));
         data.adxPlus.push(iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,1,i));
         data.adxMinus.push(iADX(_Symbol,PERIOD_CURRENT,noOfCandles,PRICE_CLOSE,2,i));
      }
   }


// 2. Compute the Physics Scores
// We compute these once and store them for both the Sniper and the Strategy
//double bScore = ms.bayesianHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);
//double nScore = ms.neuronHoldScore(data.ima120, data.close, data.open, data.tick_volume, BarsHeld, data.atr[0]);

   double ima14Arr[];
   double ima30Arr[];
   double ima60Arr[];
   double openArr[];
   double closeArr[];
   double tickVolArr[];


   data.ima14.exportToArray(ima14Arr);
   data.ima30.exportToArray(ima30Arr);
   data.ima60.exportToArray(ima60Arr);
   data.open.exportToArray(openArr);
   data.close.exportToArray(closeArr);
   data.tick_volume.exportToArray(tickVolArr);


   double bScore = ms.bayesianHoldScore(ima30Arr, closeArr, openArr, tickVolArr, BarsHeld, data.atr.get(0));
   double nScore = ms.neuronHoldScore(ima30Arr, closeArr, openArr, tickVolArr, BarsHeld, data.atr.get(0));


// Update the snapshot so the Strategy (st1) can see the results
   data.bayesianHoldScore = bScore;
   data.neuronHoldScore = nScore;


//double fastSlope = (data.ima14[SHIFT] - data.ima30[3]) / (3 * pipValue);
//double medSlope  = (data.ima30[SHIFT] - data.ima60[10]) / (10 * pipValue);
//double slowSlope = (data.ima60[SHIFT] - data.ima120[30]) / (30 * pipValue);


   double fastSlope = (ima14Arr[SHIFT] - ima14Arr[5]) / (5 * pipValue);
   double medSlope  = (ima30Arr[SHIFT] - ima30Arr[10]) / (10 * pipValue);
   double slowSlope = (ima60Arr[SHIFT] - ima60Arr[30]) / (30 * pipValue);


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
//   data.spreadLimit = ms.getDynamicSpreadLimit(data.atr[1],_Period);
   data.spreadLimit = ms.atrScale(data.atr.get(SHIFT),15,120);



}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WarmUpCache_CB(INDDATA_CB &data) {
// Loop HIGH to LOW so newest value lands at get(0)
   for(int i = 239; i >= 0; i--) {
      data.open.push(iOpen(_Symbol, PERIOD_CURRENT, i));
      data.close.push(iClose(_Symbol, PERIOD_CURRENT, i));
      data.tick_volume.push((long)iVolume(_Symbol, PERIOD_CURRENT, i));
      data.ima120.push(iMA(_Symbol, PERIOD_CURRENT, 120, 0, MODE_SMMA, PRICE_CLOSE, i));
      data.ima240.push(iMA(_Symbol, PERIOD_CURRENT, 240, 0, MODE_SMMA, PRICE_CLOSE, i));
      data.ima500.push(iMA(_Symbol, PERIOD_CURRENT, 500, 0, MODE_SMMA, PRICE_CLOSE, i));

      if(i < 120) {
         data.high.push(iHigh(_Symbol, PERIOD_CURRENT, i));
         data.low.push(iLow(_Symbol, PERIOD_CURRENT, i));
         data.time.push(iTime(_Symbol, PERIOD_CURRENT, i));
         data.std.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_CLOSE, i));
         data.stdOpen.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_OPEN, i));
         data.obv.push(iOBV(_Symbol, PERIOD_CURRENT, PRICE_CLOSE, i));
         data.rsi.push(iRSI(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_WEIGHTED, i));
         data.mfi.push(iMFI(_Symbol, PERIOD_CURRENT, noOfCandles, i));
         data.ima5.push(iMA(_Symbol, PERIOD_CURRENT, 5,  0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima14.push(iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima30.push(iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.ima60.push(iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, i));
         data.atr.push(iATR(_Symbol, PERIOD_CURRENT, noOfCandles, i));
         data.adx.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, MODE_MAIN, i));
         data.adxPlus.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, 1, i));
         data.adxMinus.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, 2, i));
      }
   }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PushNewBar_CB(INDDATA_CB &data) {
// Push the just-closed bar (shift=1) — this is the confirmed, immutable value
   data.open.push(iOpen(_Symbol, PERIOD_CURRENT, 1));
   data.close.push(iClose(_Symbol, PERIOD_CURRENT, 1));
   data.tick_volume.push((long)iVolume(_Symbol, PERIOD_CURRENT, 1));
   data.ima120.push(iMA(_Symbol, PERIOD_CURRENT, 120, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.ima240.push(iMA(_Symbol, PERIOD_CURRENT, 240, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.ima500.push(iMA(_Symbol, PERIOD_CURRENT, 500, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.high.push(iHigh(_Symbol, PERIOD_CURRENT, 1));
   data.low.push(iLow(_Symbol, PERIOD_CURRENT, 1));
   data.time.push(iTime(_Symbol, PERIOD_CURRENT, 1));
   data.std.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_CLOSE, 1));
   data.stdOpen.push(iStdDev(_Symbol, PERIOD_CURRENT, noOfCandles, 0, MODE_EMA, PRICE_OPEN, 1));
   data.obv.push(iOBV(_Symbol, PERIOD_CURRENT, PRICE_CLOSE, 1));
   data.rsi.push(iRSI(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_WEIGHTED, 1));
   data.mfi.push(iMFI(_Symbol, PERIOD_CURRENT, noOfCandles, 1));
   data.ima5.push(iMA(_Symbol, PERIOD_CURRENT, 5,  0, MODE_SMMA, PRICE_CLOSE, 1));
   data.ima14.push(iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.ima30.push(iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.ima60.push(iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, 1));
   data.atr.push(iATR(_Symbol, PERIOD_CURRENT, noOfCandles, 1));
   data.adx.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, MODE_MAIN, 1));
   data.adxPlus.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, 1, 1));
   data.adxMinus.push(iADX(_Symbol, PERIOD_CURRENT, noOfCandles, PRICE_CLOSE, 2, 1));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshLiveScalars_CB(INDDATA_CB &data) {
// Trade/order state
   op3.initTrade(microLots, TAKE_PROFIT, STOP_LOSS);
   data.magicnumber    = magicNumber;
   data.stopLoss       = op3.STOPLOSS;
   data.currProfit     = op3.TRADEPROFIT;
   data.closeProfit    = op3.TAKEPROFIT;
   data.maxProfit      = op3.MAXTRADEPROFIT;
   data.shift          = SHIFT;
   data.microLots      = microLots;
   data.BarsHeld       = BarsHeld;
   data.newBar         = util.isNewBarTime();
   data.currSpread     = (int)MarketInfo(_Symbol, MODE_SPREAD);
   data.maxPyramidTrades = maxPyramidTrades;
   data.totalOrders    = OrdersTotalByMagic(magicNumber);
   data.currBarOrders  = util.numOfOrdersCurrBar(magicNumber);
   data.newBarOpenTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   data.prevBarOpenTime= iTime(_Symbol, PERIOD_CURRENT, 1);
   data.candleTraded   = util.hasTradedCurrentBar(magicNumber);

// Live current bar — shift=0, changes every tick
   double live_ima14 = iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double live_ima30 = iMA(_Symbol, PERIOD_CURRENT, 30, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double live_ima60 = iMA(_Symbol, PERIOD_CURRENT, 60, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double live_atr   = iATR(_Symbol, PERIOD_CURRENT, noOfCandles, 0);

// Physics scores — use cached history (get(1) = SHIFT=1, confirmed bar)
   double ima30Arr[], closeArr[], openArr[];
   double   volArr[];
   data.ima30.exportToArray(ima30Arr);
   data.close.exportToArray(closeArr);
   data.open.exportToArray(openArr);
   data.tick_volume.exportToArray(volArr);

   data.bayesianHoldScore = ms.bayesianHoldScore(ima30Arr, closeArr, openArr, volArr,
                            BarsHeld, live_atr);
   data.neuronHoldScore   = ms.neuronHoldScore(ima30Arr, closeArr, openArr, volArr,
                            BarsHeld, live_atr);

// Slope calculations using cached confirmed bars (get(1), get(5), etc.)
   double fastSlope = (data.ima14.get(SHIFT) - data.ima14.get(5)) / (5 * pipValue);
   double medSlope  = (data.ima30.get(SHIFT) - data.ima30.get(10)) / (10 * pipValue);
   double slowSlope = (data.ima60.get(SHIFT) - data.ima60.get(30)) / (30 * pipValue);

   double macroThreshold  = 0.1;
   data.baseSlope         = (slowSlope > macroThreshold) ? 1 : ((slowSlope < -macroThreshold) ? -1 : 0);
   double fMSR_Raw        = ms.slopeAccelerationRatio(fastSlope, medSlope, slowSlope);
   data.fMSR_Raw          = fMSR_Raw;
   data.fMSR_Norm         = fMSR_Raw / (1.0 + MathAbs(fMSR_Raw));
   data.fractalAlignment  = ms.fractalAlignment(fastSlope, medSlope, slowSlope);
   data.spreadLimit       = ms.atrScale(data.atr.get(SHIFT), 15, 120);
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

//RefreshPhysicsData_CB(indData_cb);

   if(!g_cbWarmedUp) {
      WarmUpCache_CB(indData_cb);       // fills history oldest-first on first run
      g_cbWarmedUp = true;
   } else if(indData.newBar) {
      PushNewBar_CB(indData_cb);        // pushes ONE value per series on new bar
   }

// Mid-bar ticks: zero MT4 indicator calls for history

// Update live current-bar values every tick (shift=0 only)
   RefreshLiveScalars_CB(indData_cb);    // ~15 calls: spread, orders, live ima30[0], etc.


   if(MathAbs(indData.ima30[1] - indData_cb.ima30.get(1)) > _Point) {
      PrintFormat("⚠️ CB MISMATCH ima30[1]: old=%.5f cb=%.5f",
                  indData.ima30[1], indData_cb.ima30.get(1));
   }

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

   int marketAction = ms.getMarketActionCombinedScore(indData);


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

   if(printStatus) {
      PrintFormat("[COBBDOUGLAS] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | Confidence: %.4f | CombinedScore: %d",
                  b, n, f, fra, totalConf, cobbsDouglasAction);

      PrintFormat("[HYPERBOLIC] Bayes: %.2f | Neuron: %.2f | Fanness(fMSR): %.2f | Fractal: %.2f | CombinedScore: %d",
                  b, n, f, fra, physicsAction);
   }

// ===============================================
// THE TRINITY CONSENSUS & PHASE TRIGGER
// ===============================================

   bool hasConsensus = (physicsAction == 1 && cobbsDouglasAction == 1 && marketAction == 1);
   bool hasCollapse  = (physicsAction == -1 || cobbsDouglasAction == -1 || marketAction == -1);

//   double absF = MathAbs(f);
//bool isSqueeze = (absF <= 0.15);
   bool isSqueeze = (absF <= 0.4);

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
                                 direction                   // raw direction, not closeSIG
                              );



// 3. Conviction sizing
   bool squeezeReversal = ms.isSqueezeReversal(
                             indData.fMSR_Norm,
                             (double)indData.baseSlope,
                             direction                   // pre-filter so reversal is detectable
                          );


   if(triggerSignal == SAN_SIGNAL::NOSIG && isSqueeze && squeezeReversal) {
      triggerSignal = direction;  // allow the reversal at reduced conviction
   }

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
      if(printStatus)PrintFormat("🔍 DIAGNOSTIC [%s]: Trigger: %s | Squeeze: %s | Consensus: %s | TotalOrders: %d",
                                    _Symbol, util.getSigString(triggerSignal), (isSqueeze?"YES":"NO"), (hasConsensus?"YES":"NO"), totalOrders);

      if(triggerSignal == SAN_SIGNAL::NOSIG)
         if(printStatus)Print("❌ SILENCE CAUSE: Tactical Brain (imaSt3) returned NOSIG.");
         else if(!hasConsensus && !isSqueeze)
            if(printStatus)Print("❌ SILENCE CAUSE: Sages (Physics/Cobb) Vetoed the Expansion trade.");
            else if(indData.currSpread > indData.spreadLimit)
               if(printStatus)PrintFormat("❌ SILENCE CAUSE: Spread (%d) is above Limit (%d).", indData.currSpread, indData.spreadLimit);
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
         physicsAction, cobbsDouglasAction, marketAction,atrRaw,orderMesg
      );
   } else if (activeStrategy == 2) {
      OnEntryExit_2(
         totalOrders, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw,orderMesg
      );
   } else if (activeStrategy == 3) {
      OnEntryExit_3(
         totalOrders, isNewCandle, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw,orderMesg
      );
   } else if (activeStrategy == 4) {
      OnEntryExit_4(
         totalOrders, isNewCandle, dynamicLots, hasConsensus, hasCollapse, isSqueeze,
         vanguardSignal, triggerSignal, closeSIG,
         physicsAction, cobbsDouglasAction, marketAction,atrRaw, orderMesg
      );
   } else if (activeStrategy == 5) {
      OnEntryExit_5(
         totalOrders, isNewCandle,candleTraded, numOfTrades,dynamicLots, hasConsensus, hasCollapse, isSqueeze,
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
   const double atrRaw,
   ulong& orderMesg
) {

// --- ENTRY LOGIC ---
   if(totalOrders == 0) {
      if(hasConsensus && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         string phaseStr = isSqueeze ? "COMPRESSION SQUEEZE" : "MACRO EXPANSION";

         if(printStatus)PrintFormat("⚡ SNIPER [%s]: Sages Approved. Trigger dictates: %s. (Lots: %.2f)",
                                       phaseStr, util.getSigString(triggerSignal), dynamicLots);

         orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                     (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
         BarsHeld = 0; // Note: BarsHeld is a global variable

      } else if(triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         if(printStatus)PrintFormat("🛡️ ENTRY BLOCKED: Trigger %s fired, but Sages vetoed (Phy:%d, Cobb:%d, Mkt:%d)",
                                       util.getSigString(triggerSignal), physicsAction, cobbsDouglasAction, marketAction);
      }
   }

// --- EXIT LOGIC ---
   else {
      SAN_SIGNAL tradePosition = util.getTradePosition(); // Relies on global 'util'

      // EXIT A: MACRO COLLAPSE
      if(hasCollapse) {
         if(printStatus)PrintFormat("🚨 GOVERNANCE: Macro Collapse Detected (Phy:%d, Cobb:%d, Mkt:%d). Forcing Exit.",
                                       physicsAction, cobbsDouglasAction, marketAction);
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }
      // EXIT B: TACTICAL TRAP
      else if (!isSqueeze && vanguardSignal != SAN_SIGNAL::NOSIG && util.oppSignal(tradePosition, vanguardSignal)) {
         if(printStatus)PrintFormat("🚨 GOVERNANCE: Tactical Trap! Vanguard violently flipped to %s. EJECTING.",
                                       util.getSigString(vanguardSignal));
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }
      // EXIT C: STANDARD CLOSE
      else if(closeSIG == SAN_SIGNAL::CLOSE) {
         if(printStatus)Print("🛡️ GOVERNANCE: Standard Close Signal honored. Exiting.");
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
      }

      if(GetLastError() != ERR_NO_ERROR)
         if(printStatus)Print("Order result: ", orderMesg, " :: Last Error: ", util.getUninitReasonText(GetLastError()));
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
   const double atrRaw,
   ulong& orderMesg
) {

   SAN_SIGNAL tradePosition = util.getTradePosition();

// --- EXIT LOGIC (The Flip & The Failsafe) ---
   if (totalOrders > 0) {
      // Failsafe: Total Macro Collapse
      if (hasCollapse) {
         if(printStatus)PrintFormat("🚨 STRATEGY 2: Macro Collapse Detected. Liquidating %d positions.", totalOrders);
         orderMesg = util.closeOrders(magicNumber);
         BarsHeld = 0;
         totalOrders = 0; // <--- UPDATE STATE
         return; // Abort further action on this candle
      }

      // The Flip Reversal: If Sages scream SELL, but we hold BUYs -> Close all BUYs.
      if (triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS) {
         if (util.oppSignal(tradePosition, triggerSignal)) {
            if(printStatus)PrintFormat("🔄 STRATEGY 2: Market violently flipped from %s to %s! Liquidating portfolio.",
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

         if(printStatus)PrintFormat("📈 STRATEGY 2: Trend is %s. Adding position #%d to the portfolio. (Lots: %.2f)",
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
   const double atrRaw,
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

         if(printStatus)PrintFormat("📈 STRATEGY 3: Tactical Trend is %s. Adding position #%d to the portfolio. (Lots: %.2f)",
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
   const double atrRaw,
   ulong& orderMesg
) {


// CLOSE block if trigger Singal is CLOSE
   if(triggerSignal == SAN_SIGNAL::CLOSE) {
      util.closeOrders(magicNumber);
      totalOrders = OrdersTotalByMagic(magicNumber);
   }

   if(totalOrders>0) {
      int reverseTrades = 0;
      if(isNewCandle) {
         reverseTrades = util.pruneReverseTrades(magicNumber,triggerSignal, 30);
      }
      if(reverseTrades>0) {
         totalOrders = OrdersTotalByMagic(magicNumber);
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
      BarsHeld = 0;
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
   const double atrRaw,
   ulong& orderMesg
) {

   if(isNewCandle) {
      util.cleanUpOrphanedMemory();
   }

// ======================= 1. EXIT LOGIC (CLOSE) ===
// CLOSE block if trigger Singal is CLOSE
   if(triggerSignal == SAN_SIGNAL::CLOSE) {
      util.closeAllOrdersOnReverse(magicNumber,vanguardSignal);
      totalOrders = OrdersTotalByMagic(magicNumber);
   }
// ==========================================================


// === 1. EXIT LOGIC (Pruners run first) ===
   if(totalOrders > 0) {
      int weedsCut = 0;
      int profitsHarvested = 0;
      int reverseTrades = 0;
      int profitThreshold  = (int)ms.atrScale(atrRaw, 100, 1000); // low bar → high bar

      if(isNewCandle) {
         //int pruneAge = MathMax(3,(int)MathFloor(maxPyramidTrades / 4.0));
         //int spreadLimit      = (int)ms.atrScale(atrRaw, 15,  120);  // tight → loose
         int pruneAge         = (int)ms.atrScale(atrRaw, 3, 5);    // patient → aggressive
         // profitThreshold  = (int)ms.atrScale(atrRaw, 100, 1000); // low bar → high bar
//         weedsCut = util.pruneTrades(magicNumber, pruneAge, 30);
//         reverseTrades = util.pruneReverseTrades(magicNumber,triggerSignal, 30);
      }

      // Profit Harvester runs every tick (correct)
      // Raised threshold to 300 points (~30 pips) + can be made ATR-based later

      //profitsHarvested = util.pruneByTrailingProfit(magicNumber, 0.80, profitThreshold, 30);

      //Print("[Prune] weeds: "+weedsCut+" Reverse: "+reverseTrades+" profits: "+profitsHarvested);

      if(weedsCut > 0 || profitsHarvested > 0 || reverseTrades>0) {
         totalOrders = OrdersTotalByMagic(magicNumber);
      }
   }


// === 2. PYRAMID LIMIT ===
   if(totalOrders >= maxPyramidTrades) return;


// === 3. ENTRY LOGIC — FIXED: isNewCandle gate restored ===
// This is the single highest-leverage fix — one trade per candle only
   if(isNewCandle && triggerSignal != SAN_SIGNAL::NOSIG && triggerSignal != SAN_SIGNAL::SIDEWAYS && triggerSignal != SAN_SIGNAL::CLOSE ) {
      if(printStatus)PrintFormat("🚜 HARVESTER: Volatility Signal → %s | Lots: %.2f | Candle: %s",
                                    util.getSigString(triggerSignal), dynamicLots,
                                    TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES));

      orderMesg = util.placeOrder(magicNumber, dynamicLots,
                                  (triggerSignal == SAN_SIGNAL::BUY ? OP_BUY : OP_SELL), 30, 0, 0);
      ocommon.newCandleGate=false;
   }
}

//+------------------------------------------------------------------+
