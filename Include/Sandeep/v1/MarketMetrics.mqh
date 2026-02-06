//+------------------------------------------------------------------+
//|                                                MarketMetrics.mqh |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Sandeep/v1/SanStats-v1.mqh>

//+------------------------------------------------------------------+
//| CLASS: MarketMetrics                                          |
//| Purpose: Centralized library for Market Physics metrics.         |
//| Contains: ATR (Vol), ADX (Trend), ER (Efficiency), vWCM (Force)  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MarketMetrics
  {
private:
   SanUtils          util;
   Stats             stats;
public:
                     MarketMetrics();
                    ~MarketMetrics();
                     MarketMetrics(SanUtils& ut);
                     MarketMetrics(SanUtils& ut,Stats& st);

   double            adxPotential(int period = 14, int shift = 1);
   double            adxKinetic(const double scale=50.0, int period = 10, int shift = 1);
   double            adxVector(const double main, const double plus, const double minus);
   double            atrKinetic(const double atr);
   double            volatilityEfficiency(const double stdOpen, const double stdCp,
                                          const double slopeOP, const double slopeCP);;
   double            volatilityAnomaly(string symbol, int tf, int period);
   double            efficiencyRatio(const double &price[], int period = 14, int shift = 0);
   double            vWCM(const double &open[], const double &close[], const double &volume[], int N = 10, int SHIFT = 1);
   bool              isTrendAccelerating(const double &sig[], int shift=1);
   double            trendAccelStrength(const double &sig[], int shift=1);
   double            layeredMomentumFilter(const double &values[], int N = 20);
   double            getLinearTimeRetention(int barsHeld, double decayRate = 0.05, double floor = 0.60);
   double            getVolAdaptiveRetention(double atr);
   double            getHybridRetention(int barsHeld, double atr);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MarketMetrics::MarketMetrics()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MarketMetrics::~MarketMetrics()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MarketMetrics::MarketMetrics(SanUtils& ut) {util = ut;}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MarketMetrics::MarketMetrics(SanUtils& ut,Stats& st) { util = ut; stats = st; }
// =================================================================
// GROUP 1: BASE METRICS (The Physics)
// =================================================================


// =================================================================
// GROUP 1: THE ADX PHYSICS ENGINE (The Trinity)
// =================================================================

// 1. adxPotential (Formerly getTrendPower)
// CONCEPT: Potential Energy / Market State
// PURPOSE: Context. "Is the environment charged?"
// RETURNS: Open-ended Ratio (e.g., 1.5 = 1.5x Baseline).
//          < 0.75 is Dead. > 1.5 is Runaway.
double  MarketMetrics::adxPotential(int period = 14, int shift = 1)
  {
   double adx = iADX(NULL, 0, period, PRICE_CLOSE, MODE_MAIN, shift);
// Baseline is ADX 20.
   return (adx / 20.0);
  }

// 2. adxKinetic (Formerly adxStrength)
// CONCEPT: Kinetic Energy / Intensity
// PURPOSE: Weighting. "How much force is in this specific move?"
// RETURNS: 0.0 to 1.0 (Squared curve to suppress noise)
double            MarketMetrics::adxKinetic(const double scale=50.0, int period = 10, int shift = 1)
  {
   double adx = iADX(NULL, 0, period, PRICE_CLOSE, MODE_MAIN, shift);
   double normAdx = MathMin(adx / scale, 1.0);
   return (normAdx*normAdx);
  }

// 3. adxVector (Formerly adxAdvancedStrength)
// CONCEPT: Vector / Velocity
// PURPOSE: Signal. "Which direction and with what conviction?"
// RETURNS: -1.0 (Bearish) to +1.0 (Bullish)
// 3. adxVector (Direction)
// "Which direction and with what conviction?"
double MarketMetrics::adxVector(const double main, const double plus, const double minus)
  {
   double direction = plus - minus;
   double spread = MathMax(fabs(main - plus), fabs(main - minus));

// 1. Get the Raw Physics Potential (Context)
// Note: We use the helper function you added, or calculate inline
   double potential = main / 20.0;

// 2. Apply the "Dead Zone" Physics
// If Potential < 1.0 (ADX < 20), we Square it to suppress noise.
// If Potential >= 1.0, we use it linearly to boost conviction.
   double trendWeight = (potential < 1.0) ? (potential * potential) : potential;

   double rawSignal = direction * trendWeight * (spread * 0.01);
   return stats.tanh(rawSignal);
  }
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//double            MarketMetrics::adxVector(const double main, const double plus, const double minus)
//  {
//   double direction = plus - minus;
//   double spread = MathMax(fabs(main - plus), fabs(main - minus));
//
//// Weight by potential energy (main ADX)
//// If ADX < 20, we dampen the vector (Low Potential).
//   double trendWeight = (main < 20) ? (main / 20.0) * 0.5 : (main / 20.0);
//
//   double rawSignal = direction * trendWeight * (spread * 0.01);
//   return stats.tanh(rawSignal);
//  }

// =================================================================
// GROUP 2: VOLATILITY METRICS
// =================================================================

// 4. atrStrength (Kinetic Volatility)
// Returns 0-1 based on how "loud" the current candle is vs expectation.
double            MarketMetrics::atrKinetic(const double atr)
  {
   double pipValue = util.getPipValue(_Symbol);
   double atrPips = (pipValue > 0) ? atr / pipValue : 0.0;
   double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;
   double atrCeiling = MathCeil(12.0 * tfScale);
   double atrNorm = MathMin(MathMax(atrPips / atrCeiling, 0.0), 1.0);
   return (atrNorm*atrNorm);
  }

// 5. volatilityEfficiency (VE)
// Logic: Measures if current volatility expansion is "Holding" (Structure)
//        and "Moving" (Momentum).
// Returns: -1.0 (Sell Vol) to 1.0 (Buy Vol)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            MarketMetrics::volatilityEfficiency(const double stdOpen, const double stdCp,
      const double slopeOP, const double slopeCP)
  {
// A. Structure & Momentum
   double denominator = (stdOpen < 0.00005) ? 0.00005 : stdOpen;
   double structureRatio = stdCp / denominator;

   double slopeDenom = (MathAbs(slopeOP) < 0.00005) ? 0.00005 : MathAbs(slopeOP);
   double momentumRatio = MathAbs(slopeCP) / slopeDenom;

// C. Convergence
// Positive = Expansion. Negative = Contraction.
   double rawScore = (structureRatio - 1.0) + (momentumRatio - 1.0);

// *** THE FIX ***
// If volatility is contracting (rawScore < 0), there is NO breakout energy.
// We clamp it to 0.0 to prevent "Double Negative" false signals.
   if(rawScore <= 0)
      return 0.0;

// D. Direction & Normalize
   int direction = (slopeCP >= 0) ? 1 : -1;
   return stats.tanh(rawScore * direction * 2.0);
  }

// 6. volatilityAnomaly (Relative Volatility)
// CONCEPT: Climate Check
// PURPOSE: Context. "Is today unusually quiet or unusually loud?"
// RETURNS: Ratio (1.0 = Normal).
//          > 1.5 = Stormy (High Vol). < 0.7 = Quiet (Low Vol).
double            MarketMetrics::volatilityAnomaly(string symbol, int tf, int period)
  {
// 1. Get History
   int bufferSize = period * 2;
   double std_buffer[];
   ArrayResize(std_buffer, bufferSize);
// ... fill buffer loop (same as GetStrength) ...
   for(int i = 0; i < bufferSize; i++)
     {
      std_buffer[i] = iStdDev(symbol, tf, period, 0, MODE_SMA, PRICE_CLOSE, i + 1);
     }

// 2. Compare Current vs Average
   double stdCurrent = std_buffer[0];
   double avgStd = iMAOnArray(std_buffer, 0, bufferSize, 0, MODE_SMA, 0);

   return (avgStd > 0) ? (stdCurrent / avgStd) : 1.0;
  }
// 3. Kaufman's Efficiency Ratio (Directional Efficiency, 0-1)
// 1.0 = Straight Line (Perfect Efficiency)
// 0.0 = Random Chop (Zero Efficiency)
double            MarketMetrics::efficiencyRatio(const double &price[], int period = 14, int shift = 0)
  {
   double net = MathAbs(price[shift] - price[shift + period]);
   double sumAbs = 0.0;
   for(int i = shift; i < shift + period; i++)
      sumAbs += MathAbs(price[i] - price[i+1]);
   return (sumAbs > 0) ? net / sumAbs : 0.0;
  }

// 4. vWCM (Volume-Weighted Candle Momentum, -1 to 1 normalized)
double            MarketMetrics::vWCM(const double &open[], const double &close[], const double &volume[], int N = 10, int SHIFT = 1)
  {
   double sum_force = 0.0;
   double total_vol = 0.0;
   for(int i = SHIFT; i < N + SHIFT; i++)
     {
      double body_pips = (close[i] - open[i]) / util.getPipValue(_Symbol);
      sum_force += body_pips * volume[i];
      total_vol += volume[i];
     }
   if(total_vol <= 0)
      return 0.0;

   double raw = sum_force / total_vol;
   return stats.tanh(raw / 10.0);
  }

//+------------------------------------------------------------------+
//| Function: Calculate MA Acceleration                              |
//| Returns:  True if acceleration is positive (gaining strength)    |
//+------------------------------------------------------------------+
//bool              isTrendAccelerating(string symbol, int timeframe, int ma_period)
bool              MarketMetrics::isTrendAccelerating(const double &sig[], int shift=1)

  {
// 1. Get the MA values for the last 3 completed bars
//double ma0 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 1);
//double ma1 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 2);
//double ma2 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 3);

   double ma0 = sig[shift];
   double ma1 = sig[shift+1];
   double ma2 = sig[shift+2];;


// 2. First Derivative: Velocity (Slope)
// How much did the MA change between bars?
   double velocity_now  = ma0 - ma1; // Current slope
   double velocity_prev = ma1 - ma2; // Previous slope

// 3. Second Derivative: Acceleration
// Is the slope getting steeper?
   double acceleration = velocity_now - velocity_prev;

// Logic: If velocity is positive AND acceleration is positive,
// the bullish trend is gaining strength.
   if(velocity_now > 0 && acceleration > 0)
      return(true);

// Logic: If velocity is negative AND acceleration is negative,
// the bearish trend is gaining strength.
   if(velocity_now < 0 && acceleration < 0)
      return(true);

   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double            MarketMetrics::trendAccelStrength(const double &sig[], int shift=1)
  {
   double v0 = sig[shift];
   double v1 = sig[shift+1];
   double v2 = sig[shift+2];

// 1. Calculate raw change in price units
   double velocity_now  = v0 - v1;
   double velocity_prev = v1 - v2;
   double raw_accel     = velocity_now - velocity_prev;

// 2. Normalize using Point to get a "Sensitivity" score
// We convert the tiny decimal into "Points"
   double accel_in_points = raw_accel / Point;

// 3. Sensitivity Adjustment
// Adjust this 'k' factor to decide how "twitchy" the signal is.
// k = 0.1 means it takes 10 points of acceleration to hit a strong signal.
   double k = 0.1;

   return stats.tanh(accel_in_points * k);
  }


//
//   double            GetStrength(string symbol, int tf, int period)
//     {
//      // 1. Statistical Volatility (Standard Deviation)
//      // We need a small buffer to calculate the average of the StdDev
//      int bufferSize = period * 2;
//      double std_buffer[];
//      ArrayResize(std_buffer, bufferSize);
//      ArraySetAsSeries(std_buffer, true);
//
//      // Fill the buffer with historical StdDev values
//      for(int i = 0; i < bufferSize; i++)
//        {
//         std_buffer[i] = iStdDev(symbol, tf, period, 0, MODE_SMA, PRICE_CLOSE, i + 1);
//        }
//
//      double stdCurrent = std_buffer[0];
//      // Calculate Average StdDev (The "Baseline" Volatility)
//      double avgStd = iMAOnArray(std_buffer, 0, bufferSize, 0, MODE_SMA, 0);
//
//      // 2. Trend Strength (ADX)
//      double adx     = iADX(symbol, tf, period, PRICE_CLOSE, MODE_MAIN, 1);
//      double plusDI  = iADX(symbol, tf, period, PRICE_CLOSE, MODE_PLUSDI, 1);
//      double minusDI = iADX(symbol, tf, period, PRICE_CLOSE, MODE_MINUSDI, 1);
//
//      // 3. Normalize the raw force
//      // Difference in DI scaled by the ADX magnitude (structural permission)
//      double rawForce = (plusDI - minusDI) * (adx / 100.0);
//
//      // 4. Apply Volatility Weighting (The "Fuel" Check)
//      // If current std is twice the average, volWeight = 2.0 (Amplify)
//      // If current std is half the average, volWeight = 0.5 (Dampen)
//      double volWeight = (avgStd > 0) ? (stdCurrent / avgStd) : 1.0;
//      double finalSignal = rawForce * volWeight;
//
//      // 5. Squash with Tanh
//      // Scaling factor 0.1 adjusted for standard currency volatility
//      return stats.tanh(finalSignal * 0.1);
//     }

// =================================================================
// GROUP 2: FILTERS & SIGNALS
// =================================================================

//+------------------------------------------------------------------+
//| FUNCTION: layeredMomentumFilter                                  |
//| REFACTORED: Now uses Universal Trend Power (No Timeframe Hacks)  |
//+------------------------------------------------------------------+
double            MarketMetrics::layeredMomentumFilter(const double &values[], int N = 20)
  {
// --- Step 1: Get Smoothed Slopes ---
   double slopes[];
   if(!stats.slopeRange_v2(values, slopes, N, 3, 1))
      return 0;

   int SIZE = ArraySize(slopes);
   if(SIZE < N)
      return 0;

// --- Step 2: Directional Consensus (The 80% Rule) ---
   int slopeBuy = 0;
   int slopeSell = 0;
   for(int i=0; i<SIZE; i++)
     {
      if(slopes[i] > 0)
         slopeBuy++;
      if(slopes[i] < 0)
         slopeSell++;
     }

   SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
   if((double)slopeBuy >= 0.8 * SIZE)
      sig = SAN_SIGNAL::BUY;
   else
      if((double)slopeSell >= 0.8 * SIZE)
         sig = SAN_SIGNAL::SELL;

   if(sig == SAN_SIGNAL::NOSIG)
      return 0;

// --- Step 3: DYNAMIC ADX GATE (Unified Trend Power) ---
// We reject anything below "Trend Power 0.75" (ADX 15).
// This allows M15 scalps AND early H1 entries, but kills dead markets.
   double power = adxPotential(14, 1);

   if(power < 0.75)
      return 0;

// --- Step 4: Histogram Gate (Momentum Conviction) ---
   int domBin = stats.histogram_Magnitude(slopes, N, 5, 0.2);
   if(domBin == -1)
      return 0;
   if(domBin < 2)
      return 0;

// --- Step 5: Quality Gate (Statistical Stability) ---
   double skew = stats.skewness(slopes, N);
   double kurt = stats.kurtosis_v3(slopes, N);

// Reject Parabolic Bubbles (High Skew > 0.5)
   if(MathAbs(skew) > 0.5)
      return 0;
// Reject News Spikes (High Kurtosis > 2.0)
   if(kurt > 2.0)
      return 0;

// --- Final Signal Trigger ---
   if(sig == SAN_SIGNAL::BUY)
      return 1.0;
   if(sig == SAN_SIGNAL::SELL)
      return -1.0;
   return 0.0;
  }

// =================================================================
// GROUP 3: DECAY & RETENTION STRATEGIES
// =================================================================

// 1. TIME DECAY (Linear)
double            MarketMetrics::getLinearTimeRetention(int barsHeld, double decayRate = 0.05, double floor = 0.60)
  {
   double retention = 1.0 - (barsHeld * decayRate);
   return MathMax(retention, floor);
  }

// 2. VOLATILITY DECAY (Adaptive Trend Following)
double            MarketMetrics::getVolAdaptiveRetention(double atr)
  {
// 1. Get Normalized Volatility (0.0 to 1.0)
//double volScore = atrStrength(atr);
   double volScore = atrKinetic(atr);

// 2. Trend Following Logic
// Sqrt makes it loosen quickly as soon as volatility starts.
   double retention = 0.98 - (0.16 * MathSqrt(volScore));

   return MathMax(retention, 0.70);
  }

// 3. HYBRID DECAY (Time + Volatility)
double            MarketMetrics::getHybridRetention(int barsHeld, double atr)
  {
   double timeRet = getLinearTimeRetention(barsHeld, 0.02, 0.80);
   double volRet  = getVolAdaptiveRetention(atr);
   return (timeRet * volRet);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MarketMetrics ms(util,stats);
//+------------------------------------------------------------------+
