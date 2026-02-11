//+------------------------------------------------------------------+
//|                                                     SanStats.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

//#include <Sandeep/v1/SanTypes-v1.mqh>
#include <Sandeep/v2/SanUtils-v2.mqh>

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//class SanUtils;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Stats
  {
private:
   string            mesg;
   //   SanUtils*         ut;
   SanUtils          ut;
public:
                     Stats();
   //   Stats(SanUtils* utilPtr);
                     Stats(SanUtils& util);
                    ~Stats();


   void              sayMesg1();
   long              getDataSize(const double &data[], int n = 0, int shift = 0);
   double            Arctan2(double y, double x);
   double            mean(const double &data[], int n = 0, double shift = 0);
   double            stdDev(const double &data[], int n = 0, int type = 0, int shift = 0);
   double            skewness(const double &values[], int N, int shift = 0);
   double            kurtosis(const double &values[], int N, int shift = 0);
   double            kurtosis_v2(const double &values[]);
   double            kurtosis_v3(const double &values[], int N, int shift = 0);

   int               histogram(const double &values[], int N = 20, int bins = 5, double binSize = 0.2);
   int               histogram_v2(const double &values[], int bins=5);
   int               histogram_Direction(const double &values[], int N = 20, int bins=5, double threshold=0.2);
   int               histogram_Magnitude(const double &values[], int N = 20, int bins=5, double minThresh=0.2);

   double            acf(const double &data[], int n = 0, int lag = 1);
   //   DataTransport     scatterPlotSlope(const double &y[],int n=0,int shift=0);
   SLOPETYPE         scatterPlot(const double& sig[], int SIZE = 21, int SHIFT = 1);
   double            cov(const double &x[], const double &y[], int n = 0, int shift = 0);
   double            pearsonCoeff(const double &data1[], const double &data2[], int n = 0, int shift = 0);
   SANTREND          convDivTest(const double &top[], const double &bottom[], int n = 0, int shift = 0);
   double            zScore(double inpVal, double mean, double std);
   double            getElement(const double &matrix[], const int i, const int j, const int DIM, const int rowSize);
   void              createSubmatrix(const double &matrix[], double &submatrix[], const int excludeRow, const int excludeCol, const int DIM, const int rowSize);
   double            det(const double &matrix[], const int DIM = 2);
   double            sigmoid(const double x);
   double            tanh(const double x);
   void              swap(double &a, double &b);
   double            det4(double &mat[][4]);
   double            detLU(const double &matrix[], const int rowSize);
   double            dotProd(const double &series1[], const double &series2[], const int SIZE = 10, const int interval = 0, int SHIFT = 1);
   double            arraySum(const double &series1[], const int SIZE = 10, int SHIFT = 0);
   double            vWCM_Score(const double &open[], const double &close[], const double &volume[], int N=10, const int interval = 0,const int SHIFT =1);
   double            vWCM_Score_v2(const double &open[], const double &close[], const double &volume[], int N = 10, int SHIFT = 1);
   DTYPE             getDecimalVal(const double num, const double denom);

   DTYPE             slopeVal(
      const double &sig[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   D20TYPE           slopeRange(
      const double &sig[],
      const int SLOPEDENOM = 3,
      const int range = 15,
      const int shift = 1
   );

   bool              slopeRange_v2(const double &sig[], double &outputArr[], int range=15, int slopeDenom=3, int shift=1);

   DataTransport     slopeFastMediumSlow(
      const double &fast[],
      const double &medium[],
      const double &slow[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

   void              sigMeanDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21);
   void              sigLinearDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21);
   RITYPE            dftFormula(const double timeSeriesVal, const int k, const int n, const int SIZE);
   void              dftTransform(const double &inputSig[], double &magnitude[], double &phase[], double &power[], int SIZE = 8);
   //   void              hilbertTransform(const double &inputSig[], double &amplitude[], double &phase[], int SIZE=21, int FILTER_LENGTH=5);
   void              hilbertTransform(const double &inputSig[], double &amplitude[], double &phase[], int SIZE = 8, int FILTER_LENGTH = 3);
   template<typename T>
   T                 maxVal(const T v1, const T v2);
   DTYPE             extractHilbertAmpNPhase(const double &hilbertAmp[], const double &hilbertPhase[], double cutOff); //,const double &dftMag[],const double &dftPhase[],const double &dftPower[]);
   DTYPE             extractDftPowerNPhase(const double &dftMag[], const double &dftPhase[], const double &dftPower[]);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Stats::Stats():mesg("Hello World") {};
Stats::Stats() {};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Stats::Stats(SanUtils* utilPtr) {
//   ut = utilPtr;
//};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats::Stats(SanUtils& util)
  {
   ut = util;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats::~Stats()
  {
// delete util;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::sayMesg1()
  {
   Print("Message from stats is : " + mesg);
  };
//------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Stats::getDataSize(const double &data[], int n = 0, int shift = 0)
  {
   long SIZE = EMPTY_VALUE;
   if(n <= 0)
     {
      SIZE = (ArraySize(data) - shift);
     }
   else
      if(((n - shift) > 0) && ((n - shift) < ArraySize(data)))
        {
         SIZE = (n - shift);
        }
      else
         if((n - shift) >= ArraySize(data))
           {
            SIZE = ArraySize(data);
           }
   return SIZE;
  };

// double x[] =  { 10, 20, 30, 40, 50};
//  //double y[] ={20, 40, 60, 80, 100};
//  double y[]= {50, 40, 30, 20, 10};
//  double z[]= {2, 4, 6, 8, 10};
//  double m[] = {10, 12, 15, 18, 20, 22, 25, 28, 30, 32}; // acf for lag 1 is The ACF for lag 1 is 0.136. ACF(0) is always 1.
//  double m1[] = {4,8,6,5,3,7,9,8,6,5}; acf(1) is 0.14
////+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  Stats::mean(const double &data[], int n = 0, double shift = 0)
  {
   double sum = 0.0;
   double mean = EMPTY_VALUE;
   long SIZE = getDataSize(data, n, shift);
   int count = 0;
   for(int i = 0; i < SIZE; i++)
     {
      if(data[i] != 0)
        {
         sum += data[i];
         count++;
        }
     }
   mean = (count > 0) ? sum / count : 0.0;
//for(int i = 0; i<SIZE; i++) {
//   sum +=data[i];
//}
//mean = sum/SIZE;
//Print("N: "+SIZE+" mean: "+mean);
   return mean;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stats::Arctan2(double y, double x)
  {
   if(x > 0)
      return MathArctan(y / x);
   if(x < 0)
     {
      if(y >= 0)
         return MathArctan(y / x) + M_PI;
      return MathArctan(y / x) - M_PI;
     }
   if(y > 0)
      return M_PI / 2;
   if(y < 0)
      return -M_PI / 2;
   return 0.0; // x=0, y=0
  }

//+------------------------------------------------------------------+
// Formula for auto correlation.
// Search text for gemini: Time series coeffient correlation
// ACF(k) = ∑(Xt - μ)(Xt-k - μ) / ∑(Xt - μ)²
// A value of 1 represents a strong trend (+ve or -ve). All the prev close prices influence the future prices in same direction.
// negative correlation of -1 indicates a strong divergence and slowing down of a trend.
// {4,8,6,5,3,7,9,8,6,5} acf(k) is approx 0.14~0.15 where k =1
// {4,5,6,10,11,13,14,16,18,20}; acf(k) = 0.7~0.778 for lag k=1.
// variation depending on whether you divide the numerator by n-lag and denonibnator by n or not.
// ACF(k) = (∑(Xt - μ)(Xt-k - μ) /(n-lag))/ (∑(Xt - μ)²/n)
// double a[] = {3,5,2,8,7}; //acf(1): −0.115: Formula: ACF(k) = (∑(Xt - μ)(Xt-k - μ)) / (∑(Xt - μ)²                               |
//+------------------------------------------------------------------+
double  Stats::acf(const double &data[], int n = 0, int lag = 1)
  {
   long SIZE = getDataSize(data, n);
   double yk = 0;
   double y0 = 0;
   double mn = mean(data, n);
   double yn;
   double yn1;
// Print("ACF Mean: "+mn+" SIZE: "+SIZE);
   for(int i = 0; i < (SIZE - lag); ++i)
     {
      yk += (data[i] - mn) * (data[i + lag] - mn);
     }
   for(int i = 0; i < (SIZE); ++i)
     {
      //yd[i] = (data[i]-mn)*(data[i]-mn);
      y0 += (data[i] - mn) * (data[i] - mn);
     }
//yk=yk/(SIZE-lag);
//y0=y0/SIZE;
//   Print("Arraysize: "+SIZE+"yk: "+yk+" y0: "+y0);
   if(y0 == 0)
     {
      return 0;
     }
   if(yk == 0)
     {
      return 0;
     }
   if((yk != 0) && (y0 != 0))
     {
      return yk / y0;
     }
   return EMPTY_VALUE;
  };

//+------------------------------------------------------------------+
//|             σ = √(Σ(xi - μ)² / N)
//      if type is 0 it is calculated for sample else for population. default is for sample
// double x[] =  { 10, 20, 30, 40, 50}; std value = 15.81                                               |
//+------------------------------------------------------------------+
double     Stats::stdDev(const double &data[], int type = 0, int n = 0, int shift = 0)
  {
   double summation = 0;
   double mn = mean(data, n);
   long SIZE = getDataSize(data, n, shift);
   for(int i = shift; i < SIZE; i++)
     {
      summation += (data[i] - mn) * (data[i] - mn);
     }
//  Print("Summation: "+summation+" Denominator:  "+SIZE);
   if(type == 0)
     {
      return sqrt(summation / (SIZE - 1));
     }
   if(type == 1)
     {
      return sqrt(summation / SIZE);
     }
   if(type == 2)
     {
      return sqrt(summation / sqrt(SIZE));
     }
   return EMPTY_VALUE;
  };


// 4. Skewness & Kurtosis (Distribution Shape, skew -1 to 1, kurt excess)
double Stats::skewness(const double &values[], int N, int shift = 0)
  {
   if(N <= 1)
      return 0.0;
   double meanVal = 0.0;
   for(int i = shift; i < N + shift; i++)
      meanVal += values[i];
   meanVal /= N;
   double variance = 0.0, skew = 0.0;
   for(int i = shift; i < N + shift; i++)
     {
      double dev = values[i] - meanVal;
      variance += dev * dev;
      skew += dev * dev * dev;
     }
   variance /= N;
   double stdDev = MathSqrt(variance);
   if(stdDev == 0)
      return 0.0;
   return (skew / N) / (stdDev * stdDev * stdDev);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stats::kurtosis(const double &values[], int N, int shift = 0)
  {
   if(N <= 1)
      return 0.0;
   double meanVal = 0.0;
   for(int i = shift; i < N + shift; i++)
      meanVal += values[i];
   meanVal /= N;
   double variance = 0.0, kurt = 0.0;
   for(int i = shift; i < N + shift; i++)
     {
      double dev = values[i] - meanVal;
      variance += dev * dev;
      kurt += dev * dev * dev * dev;
     }
   variance /= N;
   if(variance < 0.00000001)
      return 0.0;

   double stdDev = MathSqrt(variance);
   if(stdDev == 0)
      return 0.0;
   double rawKurt = (kurt / N) / (variance * variance);
   return rawKurt - 3.0;  // excess kurtosis
  }


//+------------------------------------------------------------------+
//| 3. Kurtosis: Measures "Spikiness"                                |
//+------------------------------------------------------------------+
double Stats::kurtosis_v2(const double &values[])
  {
   int N = ArraySize(values);
   if(N < 4)
      return 0.0;

   double mean = 0;
   for(int i=0; i<N; i++)
      mean += values[i];
   mean /= N;

   double s2 = 0, s4 = 0;
   for(int i=0; i<N; i++)
     {
      double dev = values[i] - mean;
      s2 += dev * dev;
      s4 += dev * dev * dev * dev;
     }
   double variance = s2 / N;

   if(variance < 0.00000001)
      return 0.0;

// Excess Kurtosis (Normal dist = 0)
   return (s4 / N) / (variance * variance) - 3.0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stats::kurtosis_v3(const double &values[], int N, int shift = 0)
  {

//int N = ArraySize(values);
//if(N < 4)
//   return 0.0;

   double mean = 0;
   for(int i=0; i<N; i++)
      mean += values[i];
   mean /= N;

   double s2 = 0, s4 = 0;
   for(int i=0; i<N; i++)
     {
      double dev = values[i] - mean;
      s2 += dev * dev;               // Variance part
      s4 += dev * dev * dev * dev;   // Kurtosis part
     }

   double variance = s2 / N;

// Prevent division by zero in flat markets
   if(variance < 1.0e-16)
      return 0.0;

// Formula: (Fourth Moment / Variance^2) - 3
   double rawKurt = (s4 / N) / (variance * variance);

   return rawKurt - 3.0; // Excess Kurtosis
  }

//+------------------------------------------------------------------+
//| histogram — Dominant Bin Finder with Dynamic Bins               |
//+------------------------------------------------------------------+
int Stats::histogram(const double &values[], int N = 20, int bins = 5, double binSize = 0.2)
  {

   if(bins < 1 || N < 1)
      return -1;  // Safety: invalid params → no dominance
   int counts[];
   ArrayResize(counts, bins);  // Dynamic — fixes MQL4 fixed-size limit
   ArrayInitialize(counts, 0);

// Optional: Normalize by ATR for cross-pair/TF (use iATR)
   double atr = iATR(NULL, 0, 14, 1);
   binSize = binSize * (atr / util.getPipValue(_Symbol));  // adaptive size

   for(int i = 0; i < N; i++)
     {
      // Safety for zero/NaN
      if(!MathIsValidNumber(values[i]))
         continue;
      int bin = (int)((values[i] + 1.0) / binSize);  // shift for negative
      if(bin >= 0 && bin < bins)
         counts[bin]++;
     }

   int maxCount = 0, domBin = -1;
   for(int b = 0; b < bins; b++)
      if(counts[b] > maxCount)
        {
         maxCount = counts[b];
         domBin = b;
        }

   if(maxCount < N * 0.5)
      return -1;  // no dominance

   return domBin;  // e.g., 4 = strong positive
  }

//+------------------------------------------------------------------+
//| 2. Histogram: Centered & Dynamic                                 |
//| Uses Min/Max normalization so it never crashes on negative values|
//+------------------------------------------------------------------+
int Stats::histogram_v2(const double &values[], int bins=5)
  {
   int N = ArraySize(values);
   if(N == 0)
      return -1;

// Find dynamic range to prevent index errors
   double maxVal = -DBL_MAX;
   double minVal = DBL_MAX;
   for(int i=0; i<N; i++)
     {
      if(values[i] > maxVal)
         maxVal = values[i];
      if(values[i] < minVal)
         minVal = values[i];
     }

// If flatline (no variance), return middle bin
   if(maxVal - minVal < 0.00001)
      return bins / 2;

   int counts[];
   ArrayResize(counts, bins);
   ArrayInitialize(counts, 0);

   double step = (maxVal - minVal) / bins;

   for(int i=0; i<N; i++)
     {
      // Normalized mapping 0 to bins-1
      int binIdx = (int)((values[i] - minVal) / step);
      if(binIdx >= bins)
         binIdx = bins - 1;
      if(binIdx < 0)
         binIdx = 0;
      counts[binIdx]++;
     }

   int maxCount = 0;
   int domBin = -1;
   for(int b=0; b<bins; b++)
     {
      if(counts[b] > maxCount)
        {
         maxCount = counts[b];
         domBin = b;
        }
     }

// Require 40% dominance (statistical conviction)
   if(maxCount < N * 0.4)
      return -1;

   return domBin;
  }

//+------------------------------------------------------------------+
//| 3. Histogram: Directional & Safe                                 |
//| Bins are anchored to 0.                                          |
//| Bin 0=Strong Sell, Bin 2=Neutral, Bin 4=Strong Buy               |
//+------------------------------------------------------------------+
int Stats::histogram_Direction(const double &values[], int N = 20, int bins=5, double threshold=0.2)
  {
//int N = ArraySize(values);
   if(N == 0)
      return -1;

   int counts[];
   ArrayResize(counts, bins);
   ArrayInitialize(counts, 0);

   int centerBin = bins / 2; // e.g., 2

// We use a fixed threshold step to maintain absolute direction
// Example: Each bin represents 'threshold' pips of slope

   for(int i=0; i<N; i++)
     {
      // Calculate offset from center (0)
      // If value is +0.0005 and thresh is 0.0002 -> +2.5 -> Bin 2+2 = 4
      int offset = (int)(values[i] / threshold);

      int binIdx = centerBin + offset;

      // CLAMPING: Prevents crash, captures strong trends in outer bins
      if(binIdx >= bins)
         binIdx = bins - 1;
      if(binIdx < 0)
         binIdx = 0;

      counts[binIdx]++;
     }

   int maxCount = 0;
   int domBin = -1;

   for(int b=0; b<bins; b++)
     {
      if(counts[b] > maxCount)
        {
         maxCount = counts[b];
         domBin = b;
        }
     }

// Require 40% dominance for conviction
   if(maxCount < N * 0.4)
      return -1;

   return domBin;
  }

//+------------------------------------------------------------------+
//| Histogram: Magnitude / Strength                                  |
//| Left = Weak (Noise), Right = Strong (Momentum)                   |
//| Enforces a 'floor' so tiny noise doesn't look like a trend.      |
//+------------------------------------------------------------------+
int Stats::histogram_Magnitude(const double &values[], int N = 20, int bins=5, double minThresh=0.2)
  {
// int N = ArraySize(values);
   if(N == 0)
      return -1;

   double maxVal = 0.0;
   for(int i=0; i<N; i++)
     {
      // We assume inputs are already Abs(), but safety first
      double v = MathAbs(values[i]);
      if(v > maxVal)
         maxVal = v;
     }

// CRITICAL: If the strongest move is weaker than our baseline noise,
// force the range so everything falls into Bin 0 (Left).
   if(maxVal < minThresh)
      maxVal = minThresh;

   int counts[];
   ArrayResize(counts, bins);
   ArrayInitialize(counts, 0);

// Map 0.0 to maxVal across 'bins'
   double step = maxVal / bins;
   if(step == 0)
      return 0; // All zero

   for(int i=0; i<N; i++)
     {
      double val = MathAbs(values[i]);
      int binIdx = (int)(val / step);

      if(binIdx >= bins)
         binIdx = bins - 1;

      counts[binIdx]++;
     }

   int maxCount = 0;
   int domBin = -1;

// Find dominant bin
   for(int b=0; b<bins; b++)
     {
      if(counts[b] > maxCount)
        {
         maxCount = counts[b];
         domBin = b;
        }
     }

// Require dominance (clustering)
   if(maxCount < N * 0.4)
      return -1;

   return domBin;
  }

//+------------------------------------------------------------------+
//| Scatter plot formula:   m = Σ(xi - xmean)(yi - ymean) / Σ(xi - xmean)²
//  m =(n Σ(xiyi)-ΣxiΣyi)/(nΣxi^2-(Σxi)^2)                                             |
//+------------------------------------------------------------------+

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
////DataTransport Stats::scatterPlotSlope(const double &y[], const double &x[],int n=0,int shift=0)
//DataTransport Stats::scatterPlotSlope(const double &y[], int n=0,int shift=0) {
//   DataTransport d;
//   double slope = EMPTY_VALUE;
//   double intercpt = EMPTY_VALUE;
//   int N = EMPTY_VALUE;
//
//
//
////int N = (n<=0)?(ArraySize(x)-shift):(n-shift);
//   if(n<=0) {
//      N = (ArraySize(y)-shift);
//   } else if((n>0)&&((n-shift)>0)) {
//      N = (n-shift);
//   } else {
//      return d;
//   }
//
//
//// ##################################################
//   int xx;
//   int yy;
//   double xxx[];
//   double yyy[];
//
//   ArrayResize(xxx,N);
//   ArrayResize(yyy,N);
//
//   for(int m=0; m<N; m++) {
//      ChartTimePriceToXY(0,0,iTime(_Symbol,PERIOD_CURRENT,m), y[m], xx, yy);
//      //Print("xx: "+xx+" yy: "+yy);
//      xxx[m] = xx;
//      yyy[m] = yy;
//   }
//
//// ##################################################
//
//
//   double sxy =0;
//   double sx =0;
//   double sy =0;
//   double sxsq =0;
//
//   double num = 0;
//   double denom = 0;
//
//   for(int i=shift; i<N; i++) {
//      sxy +=xxx[i]*yyy[i];
//      sx +=xxx[i];
//      sy +=yyy[i];
//      sxsq += xxx[i]*xxx[i];
//   }
//   num = (N*sxy-sx*sy);
//   denom = N*sxsq-(sx*sx);
//   slope = (-1)*num/denom; // 0 is current bar and slopes are measured in reverse. It is easier to multiply by -1 to correct it.
////   slope = num/denom;
//
//   intercpt = (sy-slope*sx)/N;
//// Print("Num: "+num+" Denom: "+denom+"Slope: "+slope+" Intercept: "+intercpt);
//
//   double xmean = mean(xxx);
//   double ymean = mean(yyy);
//   double slope2 = 0;
//   double slopenum = 0;
//   double slopedenom = 0;
//   for(int i=shift; i<N; i++) {
//      slopenum+=(xxx[i]-xmean)*(yyy[i]-ymean);
//      slopedenom+=(xxx[i]-xmean)*(xxx[i]-xmean);
//   }
//
//   slope2 = (-1)*(slopenum/slopedenom);  // 0 is current bar and slopes are measured in reverse. It is easier to multiply by -1 to correct it.
////   slope2 = (slopenum/slopedenom);
//
//
//
//   double sumxy=0;
//   double sumx=0;
//   double sumy=0;
//   double sumsqx=0;
//   double slopeNew = NULL;
//   double interceptNew = NULL;
//
//   for(int i=shift,j=(N-1); i<N; i++,j--) {
//      sumxy += y[j]*i;
//      sumy += y[j];
//      sumx += i;
//      sumsqx += i*i;
//   }
//   slopeNew = (N*sumxy-(sumy*sumx))/(N*sumsqx-(sumx*sumx));
//   interceptNew = (sumy-slopeNew*sumx)/N;
//
//
////  Print("Slope New: "+ slopeNew+" slope: "+ slope+" slope2: "+ slope2);
//
//   d.matrixD[0] = slope;
//   d.matrixD[1] = intercpt;
//   d.matrixD[2] = slope2;
//   d.matrixD[3] = (ymean-slope2*xmean);
//   d.matrixD[4] = slopeNew;
//   d.matrixD[5] = interceptNew;
//
//   return d;
//}

//+------------------------------------------------------------------+
//| Scatter plot formula:   m = Σ(xi - xmean)(yi - ymean) / Σ(xi - xmean)²
//  m =(n Σ(xiyi)-ΣxiΣyi)/(nΣxi^2-(Σxi)^2)                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SLOPETYPE Stats::scatterPlot(const double& sig[], int SIZE = 21, int SHIFT = 1)
  {
//DataTransport dt;
   SLOPETYPE st;
   double xy = 0;
   double sumx = 0;
   double sumy = 0;
   double num = 0;
   double denom = 0;
   double sumxsq = 0;
   int N = (SIZE - SHIFT);
//double slope = EMPTY_VALUE;
//double intercept = EMPTY_VALUE;
//  double pipValue = ut.getPipValue(_Symbol);
//   for(int i=SHIFT, j=N; i<SIZE; i++,j--) { // This maintains the slope value
   for(int i = SHIFT, j = 0; i < SIZE; i++, j++)   // This flips slope value
     {
      xy += sig[i] * j;
      sumx += j;
      sumy += sig[i];
      sumxsq += j * j;
     }
   num = N * xy - (sumx * sumy);
   denom = N * sumxsq - (sumx * sumx);
   if(num == 0)
      num = num + 0.000001;
   if(denom == 0)
      denom = denom + 0.000001;
//slope = -1*(num/denom);
//intercept = ((sumy-slope*sumx)/N);
//dt.matrixD[0]=slope;
//dt.matrixD[1]=intercept;
   st.slope = -1 * (num / denom);
   st.intercept = ((sumy - st.slope * sumx) / N);
   return st;
  }
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
////DataTransport   Stats::slopeVal(
//DTYPE   Stats::slopeVal(
//   const double &sig[],
//   const int SLOPEDENOM = 3,
//   const int SLOPEDENOM_WIDE = 5,
//   const int shift = 1
//) {
////   DataTransport dt;
//   DTYPE dt;
//// double tPoint = ut.getPipValue(_Symbol);
//   double tPoint = Point;
//   //dt.matrixD[0] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
//   //dt.matrixD[1] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM_WIDE])/(SLOPEDENOM_WIDE*tPoint)),3);
//   //return dt;
//   dt.val1 = NormalizeDouble(((sig[shift] - sig[SLOPEDENOM]) / (SLOPEDENOM * tPoint)), 3);
//   dt.val2 = NormalizeDouble(((sig[shift] - sig[SLOPEDENOM_WIDE]) / (SLOPEDENOM_WIDE * tPoint)), 3);
//   return dt;
//}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE Stats::slopeVal(
   const double &sig[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
   DTYPE dt;
   double pipValue = util.getPipValue(_Symbol);  // ← TRUE pip normalization
   if(pipValue <= 0)
      pipValue = Point;           // safety fallback

   dt.val1 = NormalizeDouble(
                (sig[shift] - sig[shift + SLOPEDENOM]) / (SLOPEDENOM * pipValue), 4);

   dt.val2 = NormalizeDouble(
                (sig[shift] - sig[shift + SLOPEDENOM_WIDE]) / (SLOPEDENOM_WIDE * pipValue), 4);

// Bonus: acceleration
   dt.val3 = dt.val1 - dt.val2;

   return dt;
  }



////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
////+------------------------------------------------------------------+
////| |
////+------------------------------------------------------------------+
//D20TYPE Stats::slopeRange(
//   const double &sig[],
//   const int SLOPEDENOM = 3,
//   const int range = 15,
//   const int shift = 1
//) {
//   D20TYPE dt;
//   if(range < 1 || shift < 0 || (shift + range + SLOPEDENOM) > ArraySize(sig)) return dt;  // Safety
//
//   double pipValue = util.getPipValue(_Symbol);
//   if(pipValue <= 0) pipValue = Point;
//
//   ArrayResize(dt.val, range);  // Dynamic sizing
//
//   for(int i = shift; i < shift + range; i++) {
//      dt.val[i - shift] = NormalizeDouble(
//                             (sig[i] - sig[i + SLOPEDENOM]) / (SLOPEDENOM * pipValue), 4);
//   }
//   return dt;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
D20TYPE Stats::slopeRange(
   const double &sig[],
   const int SLOPEDENOM = 3,
   const int range = 15,
   const int shift = 1
)
  {
   D20TYPE dt; // Created on stack, initialized to EMPTY_VALUE

// SAFETY CHECK 1: Input Validation
   if(range < 1 || shift < 0 || (shift + range + SLOPEDENOM) > ArraySize(sig))
      return dt;

// SAFETY CHECK 2: Max Limit Enforcement
// If you ask for 70 items, we cap it at 60 to prevent array out of range
   int safeRange = range;
   if(safeRange > 60)
     {
      Print("Error: Range exceeds fixed struct limit of 60");
      safeRange = 60;
     }

   double pipValue = util.getPipValue(_Symbol);
   if(pipValue <= 0)
      pipValue = Point;

// No ArrayResize needed (it's always 60)

   for(int i = shift; i < shift + safeRange; i++)
     {
      // We must map 'i' back to 0-based index for the struct
      int structIdx = i - shift;

      dt.val[structIdx] = NormalizeDouble(
                             (sig[i] - sig[i + SLOPEDENOM]) / (SLOPEDENOM * pipValue), 4);
     }

   return dt; // Returns a COPY of the struct
  }

// Change return type to bool for error checking
bool Stats::slopeRange_v2(const double &sig[], double &outputArr[], int range=15, int slopeDenom=3, int shift=1)
  {

// Safety Check: Not enough data in source
   if(ArraySize(sig) < range + shift + slopeDenom)
      return false;

// Efficient Resizing
   if(ArraySize(outputArr) != range)
      ArrayResize(outputArr, range);

//// Optimization: Get PipValue once per call, not inside the loop
//double pipVal = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
//long digits = SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);

//// Adjust for 3/5 digit brokers
//if(digits == 3 || digits == 5) pipVal *= 10;
//if(pipVal == 0) pipVal = 0.0001;

   double pipValue = util.getPipValue(_Symbol);
   if(pipValue <= 0)
      pipValue = Point;

   for(int i = 0; i < range; i++)
     {
      int idx = shift + i;
      // Slope logic
      double rawVal = (sig[idx] - sig[idx + slopeDenom]) / (double)slopeDenom;
      outputArr[i] = rawVal / pipValue;
     }
   return true; // Success
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataTransport   Stats::slopeFastMediumSlow(
   const double &fast[],
   const double &medium[],
   const double &slow[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
)
  {
   DataTransport dt;
   double tPoint = Point;
   dt.matrixD[0] = NormalizeDouble(((fast[shift] - fast[SLOPEDENOM]) / (SLOPEDENOM * tPoint)), 3);
   dt.matrixD[1] = NormalizeDouble(((medium[shift] - medium[SLOPEDENOM]) / (SLOPEDENOM * tPoint)), 3);
   dt.matrixD[2] = NormalizeDouble(((slow[shift] - slow[SLOPEDENOM]) / (SLOPEDENOM * tPoint)), 3);
   dt.matrixD[3] = NormalizeDouble(((slow[shift] - slow[SLOPEDENOM_WIDE]) / (SLOPEDENOM_WIDE * tPoint)), 3);
   return dt;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stats::cov(const double &x[], const double &y[], int n = 0, int shift = 0)
  {
   double coeff = EMPTY_VALUE;
   double num = 0;
   double denomx = 0;
   double denomy = 0;
   double denom = 0;
   double xm = mean(x);
   double ym = mean(y);
   long SIZE = getDataSize(x);
//  for(int i=0; i<(SIZE-shift); i++)
   for(int i = shift; i < SIZE; i++)
     {
      num += ((x[i] - xm) * (y[i] - ym));
     }
//denom =sqrt(denomx)*sqrt(denomy);
   denom = (SIZE - 1);
   if(num == 0)
     {
      return 0;
     }
   if(denom == 0)
     {
      denom = denom + 0.00000000001;
     }
   coeff = num / denom;
//  Print("yi:0 "+y[0]+" :1: "+y[1]+" :2: "+y[2]+" :3 "+y[3]+" :4 "+ y[4]);
//   Print("Num: "+ num+" denomx: "+denomx+" denomy: "+denomy+" Denom: "+denom+" ym: "+ym+" xm: "+xm+" coeff: "+coeff);
   return coeff;
  }


////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
double Stats::pearsonCoeff(const double &x[], const double &y[], int n = 0, int shift = 0)
  {
// coeff value: 1
//Variable X: 10, 20, 30, 40, 50
// Variable Y: 20, 40, 60, 80, 100
// coeff value: -1
//Variable X: 10, 20, 30, 40, 50
//Variable Y: 50, 40, 30, 20, 10
   double coeff = EMPTY_VALUE;
   double num = 0;
   double denomx = 0;
   double denomy = 0;
   double denom = 0;
   double xm = mean(x);
   double ym = mean(y);
   long SIZE = getDataSize(x);
//  for(int i=0; i<(SIZE-shift); i++)
   for(int i = shift; i < SIZE; i++)
     {
      num += ((x[i] - xm) * (y[i] - ym));
      denomx += ((x[i] - xm) * (x[i] - xm));
      denomy += ((y[i] - ym) * (y[i] - ym));
     }
   denom = sqrt(denomx) * sqrt(denomy);
//if((num==0) || (denom==0))
//   return 1000000.314;
   if(num == 0)
     {
      return 0;
     }
   if(denom == 0)
     {
      denom = denom + 0.00000000001;
     }
   coeff = num / denom;
//  Print("yi:0 "+y[0]+" :1: "+y[1]+" :2: "+y[2]+" :3 "+y[3]+" :4 "+ y[4]);
//   Print("Num: "+ num+" denomx: "+denomx+" denomy: "+denomy+" Denom: "+denom+" ym: "+ym+" xm: "+xm+" coeff: "+coeff);
   return coeff;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANTREND Stats::convDivTest(const double &top[], const double &bottom[], int n = 0, int shift = 0)
  {
   DataTransport d;
   int SIZE = (n == 0) ? (ArraySize(top) - shift) : (n - shift);
   double topr = -1000000.314;
   double bottomr = -1000000.314;
   int updive = 0;
   int upconv = 0;
   int downdive = 0;
   int downconv = 0;
   int upperflatdive = 0;
   int upperflatconv = 0;
   int lowerflatdive = 0;
   int lowerflatconv = 0;
   int upflat = 0;
   int downflat = 0;
   int flatflat = 0;
   for(int i = shift, j = 0; (i + 1) < (SIZE); i++, j++)
     {
      topr = (top[i] / top[i + 1]);
      bottomr = (bottom[i] / bottom[i + 1]);
      // Print(" topr: "+topr+" bottomr: "+bottomr);
      if((topr > 1) && (bottomr > 1) && (topr > bottomr))
        {
         updive++;
         d.matrixD[0]++;
        }
      if((topr > 1) && (bottomr > 1) && (topr < bottomr))
        {
         upconv++;
         d.matrixD[1]++;
        }
      if((topr > 1) && (bottomr > 1) && (topr == bottomr))
        {
         upflat++;
         d.matrixD[2]++;
        }
      if((topr < 1) && (bottomr < 1) && (topr > bottomr))
        {
         downdive++;
         d.matrixD[3]++;
        }
      if((topr < 1) && (bottomr < 1) && (topr < bottomr))
        {
         downconv++;
         d.matrixD[4]++;
        }
      if((topr < 1) && (bottomr < 1) && (topr == bottomr))
        {
         downflat++;
         d.matrixD[5]++;
        }
      if((topr == 1) && (bottomr > 1))
        {
         upperflatconv++;
         d.matrixD[6]++;
        }
      if((topr == 1) && (bottomr < 1))
        {
         upperflatdive++;
         d.matrixD[7]++;
        }
      if((topr > 1) && (bottomr == 1))
        {
         lowerflatdive++;
         d.matrixD[8]++;
        }
      if((topr < 1) && (bottomr == 1))
        {
         lowerflatconv++;
         d.matrixD[9]++;
        }
      if((topr == 1) && (bottomr == 1))
        {
         flatflat++;
         d.matrixD[10]++;
        }
     }
   int firstVal = d.matrixD[ArrayMaximum(d.matrixD)];
   int first = ArrayMaximum(d.matrixD);
   int secondVal = -1000314;
   int second = -1000314;
   int thirdVal = -1000314;
   int third = -1000314;
   for(int i = 0; i < 12; i++)
     {
      if((i != first) && (second == -1000314))
        {
         secondVal = d.matrixD[i];
         second = i;
        }
      if((i != first) && (second != -1000314) && (d.matrixD[i] > secondVal))
        {
         secondVal = d.matrixD[i];
         second = i;
        }
      if((i != first) && (i != second) && (third == -1000314))
        {
         thirdVal = d.matrixD[i];
         third = i;
        }
      if((i != first) && (i != second) && (third != -1000314) && (d.matrixD[i] > thirdVal))
        {
         thirdVal = d.matrixD[i];
         third = i;
        }
     }
   if(first == 0)
     {
      return SANTREND::DIVUP;
     }
   if(first == 1)
     {
      return SANTREND::CONVUP;
     }
   if(first == 2)
     {
      return SANTREND::DIVDOWN;
     }
   if(first == 3)
     {
      return SANTREND::CONVDOWN;
     }
   if(first == 4)
     {
      return SANTREND::DIVFLAT;
     }
   if(first == 5)
     {
      return SANTREND::CONVFLAT;
     }
   if(first == 6)
     {
      return SANTREND::DIVFLAT;
     }
   if(first == 7)
     {
      return SANTREND::CONVFLAT;
     }
   if(first == 8)
     {
      return SANTREND::FLATUP;
     }
   if(first == 9)
     {
      return SANTREND::FLATDOWN;
     }
   if(first == 10)
     {
      return SANTREND::FLATFLAT;
     }
//   if((first==0)||(first==1)||(first==2)){ return SANTREND::UP; }
//   if((first==3)||(first==4)||(first==5)){ return SANTREND::DOWN; }
//   if((first==6)||(first==7)||(first==8)||(first==9)||(first==10)||(first==11)){ return SANTREND::FLAT; }
//
//   Print("Max array Val:"+ArrayMaximum(d.matrixD)+" first: "+first+" updive: "+updive+" upconv: "+upconv +" downdive: "+ downdive+" downconv: "+downconv+" upperflatconv: "+upperflatconv+" upperflatdive: "+upperflatdive+" lowerflatdive: "+lowerflatdive+" lowerflatconv: "+lowerflatconv+" flatflat: "+flatflat);
   return SANTREND::NOTREND;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double   Stats::zScore(double inpVal, double mean, double std)
  {
   return ((inpVal - mean) / (std + 0.000000001));
// Print("Std: "+std+" std+error: "+ (std+0.00001));
//if(std!=0)
//   return (inpVal - mean)/(std);
//if(std==0)
//   return 0;
//return 0;
  }

// Get element from a single-array matrix
double Stats::getElement(const double &matrix[], const int i, const int j, const int DIM, const int rowSize)
  {
   if(i < 0 || j < 0 || i >= DIM || j >= DIM)
      return EMPTY_VALUE;
   int elemPosition = (i * rowSize) + j;
   if(elemPosition >= ArraySize(matrix))
      return EMPTY_VALUE;
   if(!MathIsValidNumber(matrix[elemPosition]))
      return EMPTY_VALUE;
   return matrix[elemPosition];
  }

// Helper function to create a submatrix excluding specified row and column
void Stats::createSubmatrix(const double &matrix[], double &submatrix[], const int excludeRow, const int excludeCol, const int DIM, const int rowSize)
  {
   int subDim = DIM - 1;
   ArrayResize(submatrix, subDim * subDim);
   for(int i = 0, k = 0; i < DIM; i++)
     {
      if(i == excludeRow)
         continue;
      for(int j = 0; j < DIM; j++)
        {
         if(j == excludeCol)
            continue;
         submatrix[k++] = getElement(matrix, i, j, DIM, rowSize);
        }
     }
  }

// Calculate determinant of a square matrix
double Stats::det(const double &matrix[], const int DIM = 2)
  {
   if(DIM <= 0 || DIM > 5)
      return EMPTY_VALUE;
   if(ArraySize(matrix) != (DIM * DIM))
      return EMPTY_VALUE;
   for(int i = 0; i < ArraySize(matrix); i++)
     {
      if(!MathIsValidNumber(matrix[i]))
         return EMPTY_VALUE;
     }
   int rowSize = ArraySize(matrix) / DIM;
// 2x2 matrix determinant: ad - bc
   if(DIM == 2)
     {
      return matrix[0] * matrix[3] - matrix[1] * matrix[2];
     }
// 3x3 matrix determinant: a(ei - fh) - b(di - fg) + c(dh - eg)
   if(DIM == 3)
     {
      double coFactor1[4];
      double coFactor2[4];
      double coFactor3[4];
      createSubmatrix(matrix, coFactor1, 0, 0, 3, rowSize);
      createSubmatrix(matrix, coFactor2, 0, 1, 3, rowSize);
      createSubmatrix(matrix, coFactor3, 0, 2, 3, rowSize);
      double det1 = coFactor1[0] * coFactor1[3] - coFactor1[1] * coFactor1[2];
      double det2 = coFactor2[0] * coFactor2[3] - coFactor2[1] * coFactor2[2];
      double det3 = coFactor3[0] * coFactor3[3] - coFactor3[1] * coFactor3[2];
      return matrix[0] * det1 - matrix[1] * det2 + matrix[2] * det3;
     }
// 4x4 and 5x5: Use LU decomposition
   if(DIM == 4 || DIM == 5)
     {
      // Copy matrix to avoid modifying input
      double A[];
      ArrayCopy(A, matrix);
      int n = DIM;
      int permutations = 0; // Track row swaps for determinant sign
      // LU decomposition with partial pivoting
      for(int i = 0; i < n - 1; i++)
        {
         // Find pivot
         int pivotRow = i;
         double pivot = MathAbs(A[i * rowSize + i]);
         for(int k = i + 1; k < n; k++)
           {
            double value = MathAbs(A[k * rowSize + i]);
            if(value > pivot)
              {
               pivot = value;
               pivotRow = k;
              }
           }
         // Check for singular matrix
         if(pivot < 1e-10)
            return 0.0; // Near-zero pivot indicates singular matrix
         // Swap rows if needed
         if(pivotRow != i)
           {
            for(int j = 0; j < n; j++)
              {
               double temp = A[i * rowSize + j];
               A[i * rowSize + j] = A[pivotRow * rowSize + j];
               A[pivotRow * rowSize + j] = temp;
              }
            permutations++;
           }
         // Eliminate below pivot
         for(int k = i + 1; k < n; k++)
           {
            double factor = A[k * rowSize + i] / A[i * rowSize + i];
            for(int j = i; j < n; j++)
              {
               A[k * rowSize + j] -= factor * A[i * rowSize + j];
              }
            A[k * rowSize + i] = factor; // Store L factor
           }
        }
      // Compute determinant as product of U's diagonal elements
      double result = 1.0;
      for(int i = 0; i < n; i++)
        {
         result *= A[i * rowSize + i];
        }
      // Adjust sign based on number of row swaps
      return (permutations % 2 == 0 ? 1 : -1) * result;
     }
   return EMPTY_VALUE;
  }

// Custom tanh function in MQL4
double Stats::tanh(const double x)
  {
   if(x > 20.0)
      return 1.0;  // Asymptote for large positive x
   if(x < -20.0)
      return -1.0;  // Asymptote for large negative x
   return (2.0 / (1.0 + MathExp(-2.0 * x))) - 1.0;
  }

// Custom sigmoid function in MQL4
double Stats::sigmoid(const double x)
  {
   if(x > 20.0)
      return 1.0;  // Asymptote for large positive x
   return (1.0 / (1.0 + MathExp(-1.0 * x)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::swap(double &a, double &b)
  {
   double temp = a;
   a = b;
   b = temp;
  }
// Simplified 4x4 determinant using LU (add to your script)
double Stats::det4(double &mat[][4])
  {
   double A[4][4];
   for(int i = 0; i < 4; i++)
      for(int j = 0; j < 4; j++)
         A[i][j] = mat[i][j];
   int permutations = 0;
   for(int i = 0; i < 3; i++)
     {
      int pivotRow = i;
      double pivot = MathAbs(A[i][i]);
      for(int k = i + 1; k < 4; k++)
        {
         if(MathAbs(A[k][i]) > pivot)
           {
            pivot = MathAbs(A[k][i]);
            pivotRow = k;
           }
        }
      if(pivot < 1e-10)
         return 0.0;
      if(pivotRow != i)
        {
         for(int j = 0; j < 4; j++)
            swap(A[i][j], A[pivotRow][j]);
         permutations++;
        }
      for(int k = i + 1; k < 4; k++)
        {
         double factor = A[k][i] / A[i][i];
         for(int j = i; j < 4; j++)
            A[k][j] -= factor * A[i][j];
        }
     }
   double result = 1.0;
   for(int i = 0; i < 4; i++)
      result *= A[i][i];
   return (permutations % 2 == 0 ? 1 : -1) * result;
  }

// Simplified determinant using LU decomposition
double Stats::detLU(const double &matrix[], const int rowSize)
  {
   if(rowSize > 7)
      return EMPTY_VALUE;
   if(ArraySize(matrix) != (rowSize * rowSize))
      return EMPTY_VALUE; // Not 5x5
   if(ArraySize(matrix) < (rowSize * rowSize))
      return EMPTY_VALUE;
   for(int i = 0; i < (rowSize * rowSize); i++)
     {
      if(!MathIsValidNumber(matrix[i]))
         return EMPTY_VALUE;  // NaN/INF
     }
// Copy matrix to avoid modifying input
   double A[];
   ArrayResize(A, (rowSize * rowSize));
//ArrayCopy(A, matrix);
   ArrayCopy(A, matrix, 0, 0, (rowSize * rowSize));
   string str = "";
   for(int i = 0; i < ArraySize(A); i++)
     {
      str += A[i] + " :: ";
     }
   Print("ARRSIZE: " + ArraySize(A) + " Vals: " + str);
//int n = 5;
   int n = rowSize;
//int rowSize = 5;  // For row-major indexing
   int permutations = 0;  // Track row swaps for sign
// LU decomposition with partial pivoting
   for(int i = 0; i < n - 1; i++)
     {
      // Find pivot
      int pivotRow = i;
      double pivot = MathAbs(A[i * rowSize + i]);
      for(int k = i + 1; k < n; k++)
        {
         double value = MathAbs(A[k * rowSize + i]);
         if(value > pivot)
           {
            pivot = value;
            pivotRow = k;
           }
        }
      // Singular matrix check
      if(pivot < 1e-10)
         return 0.0;
      // Swap rows if needed
      if(pivotRow != i)
        {
         for(int j = 0; j < n; j++)
           {
            double temp = A[i * rowSize + j];
            A[i * rowSize + j] = A[pivotRow * rowSize + j];
            A[pivotRow * rowSize + j] = temp;
           }
         permutations++;
        }
      // Eliminate below pivot
      for(int k = i + 1; k < n; k++)
        {
         double factor = A[k * rowSize + i] / A[i * rowSize + i];
         for(int j = i; j < n; j++)
           {
            A[k * rowSize + j] -= factor * A[i * rowSize + j];
           }
         // Note: Factor stored in L (below diagonal), but not needed for det
        }
     }
// Determinant = product of U's diagonal elements, adjusted by permutations
   double result = 1.0;
   for(int i = 0; i < n; i++)
     {
      result *= A[i * rowSize + i];
     }
   return (permutations % 2 == 0 ? 1 : -1) * result;
  }


//+------------------------------------------------------------------+
//| Mean Detrending                                                  |
//+------------------------------------------------------------------+
void Stats::sigMeanDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21)
  {
   double pipVal = ut.getPipValue(_Symbol); // 0.01
   ArrayResize(outputSignal, SIZE);
   ut.transformAndCopyArraySlice(inputSig, outputSignal, 0, SIZE - 1, pipVal); // Output in pips
//
//   double sum = 0.0;
//   int count = 0;
//   for(int i = 0; i < SIZE; i++) {
//      if(outputSignal[i] != 0) {
//         sum += outputSignal[i];
//         count++;
//      }
//   }
//   double meanVal = (count > 0) ? sum / count : 0.0; // Mean over non-zero values
//
   double meanVal = mean(outputSignal);
//Print("[MEAN]: " + DoubleToString(meanVal, 6));
   for(int i = 0; i < SIZE; i++)
     {
      outputSignal[i] = (outputSignal[i] != 0) ? (outputSignal[i] - meanVal) : 0.0; // Zero-mean in pips
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::sigLinearDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21)
  {
   double pipVal = ut.getPipValue(_Symbol); // 0.01
   ArrayResize(outputSignal, SIZE);
   ut.copyArraySlice(inputSig, outputSignal, 0, SIZE - 1);
//ut.transformAndCopyArraySlice(inputSig, outputSignal, 0, SIZE-1, pipVal);
//DataTransport dt = scatterPlot(outputSignal, SIZE, 0);
//double slope = dt.matrixD[0];
//double intercept = dt.matrixD[1];
   SLOPETYPE st = scatterPlot(outputSignal, SIZE, 0);
   double slope = st.slope;
   double intercept = st.intercept;
   if(slope == EMPTY_VALUE || intercept == EMPTY_VALUE)
      return;
//  double pipVal = ut.getPipValue(_Symbol); // 0.01 for USDJPY
   for(int i = 0; i < SIZE; i++)
     {
      outputSignal[i] = (outputSignal[i] != 0) ? ((outputSignal[i] - (slope * i + intercept))) : 0.0;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RITYPE   Stats::dftFormula(const double timeSeriesVal, const int k, const int n, const int SIZE)
  {
   RITYPE ri;
   ri.r = 0.0;
   ri.i = 0.0;
   double angle = 2 * M_PI * k * n / SIZE;
   ri.r += timeSeriesVal * MathCos(angle);
   ri.i -= timeSeriesVal * MathSin(angle);
   return ri;
  }

//+------------------------------------------------------------------+
//| DFT (FFT Approximation) for USDJPY Signal Analysis                |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::dftTransform(const double &inputSig[], double &magnitude[], double &phase[], double &power[], int SIZE = 8)
  {
   double detrended[];
   sigMeanDeTrend(inputSig, detrended, SIZE);
   int N = (int)MathPow(2, MathCeil(MathLog(SIZE) / MathLog(2)));
   double paddedSig[];
   ArrayResize(paddedSig, N);
   ArrayCopy(paddedSig, detrended, 0, 0, SIZE);
   for(int i = SIZE; i < N; i++)
      paddedSig[i] = 0.0;
//string inp = "";
//for(int i = 0; i < SIZE; i++) inp += " :" + DoubleToString(inputSig[i], 6);
//Print("[INPSIG]: " + inp);
//string p = "";
//for(int i = 0; i < N; i++) p += " :" + DoubleToString(paddedSig[i], 6);
//Print("[DFT::PADDEDSIG]: " + p);
   ArrayResize(magnitude, N);
   ArrayResize(phase, N);
   ArrayResize(power, N);
   for(int k = 0; k < N; k++)
     {
      double real = 0.0;
      double imag = 0.0;
      for(int n = 0; n < N; n++)
        {
         double angle = 2 * M_PI * k * n / N;
         real += paddedSig[n] * MathCos(angle);
         imag -= paddedSig[n] * MathSin(angle);
        }
      magnitude[k] = sqrt(real * real + imag * imag); // No extra normalization
      phase[k] = Arctan2(imag, real);
      power[k] = (magnitude[k] * magnitude[k]) / N;
     }
  }



//+------------------------------------------------------------------+
//| Hilbert Transform for USDJPY Trading Signals                      |
//+------------------------------------------------------------------+
void Stats::hilbertTransform(const double &inputSig[], double &amplitude[], double &phase[], int SIZE = 8, int FILTER_LENGTH = 3)
  {
// Step 1: Detrend (returns pips)
   double detrended[];
   sigMeanDeTrend(inputSig, detrended, SIZE); // Outputs pips
   int N = (int)MathPow(2, MathCeil(MathLog(SIZE) / MathLog(2)));
   double paddedSig[];
   ArrayResize(paddedSig, N);
   ArrayCopy(paddedSig, detrended, 0, 0, SIZE);
   for(int i = SIZE; i < N; i++)
      paddedSig[i] = 0.0;
//string inp = "";
//for(int i = 0; i < SIZE; i++) inp += " "+i+":" + DoubleToString(inputSig[i], 6);
//Print("[HILLBERT: INPSIG]: " + inp);
//string p = "";
//for(int i = 0; i < N; i++) p += " "+i+":" + DoubleToString(paddedSig[i], 6);
//Print("[HILLBERT: PADDEDSIG]: " + p);
// Step 2: Resize output arrays
   ArrayResize(amplitude, N);
   ArrayResize(phase, N);
// Step 3: Define Hilbert FIR kernel
   double kernel[];
   int M = FILTER_LENGTH;
   ArrayResize(kernel, 2 * M + 1);
   for(int m = -M; m <= M; m++)
     {
      kernel[m + M] = (m != 0 && m % 2 != 0) ? 2.0 / (M_PI * m) : 0.0;
     }
//string ker = "";
//for(int i = 0; i < (2*M + 1); i++) ker += " "+i+":" + DoubleToString(kernel[i], 6)+(((SIZE%8)==0)?'\n':"");
//Print("[KERNEL]: " + ker);
// Step 4: Compute Hilbert transform
   double hat_x[];
   ArrayResize(hat_x, N);
//string ssp="";
//string kkp="";
//string ppp="";
   for(int n = M; n < N - M; n++)
     {
      double sum = 0.0;
      for(int m = -M; m <= M; m++)
        {
         if(n - m >= 0 && n - m < N)
            sum += kernel[m + M] * paddedSig[n - m];
         //ssp+=" "+m+":"+sum;
         //kkp+=" "+m+":"+kernel[m + M];
         //ppp+=" "+m+":"+paddedSig[n - m];
        }
      hat_x[n] = sum;
     }
//Print("[KERNEL]: "+kkp);
//Print("[PADDEDSIG]: "+ppp);
//Print("[SUM]: "+ssp);
//string hatx = "";
//for(int i = 0; i < N; i++) hatx += " "+i+":" + DoubleToString(hat_x[i], 6);
//Print("[HAT_X]: " + hatx);
// Step 5: Compute amplitude and phase
   for(int i = 0; i < N; i++)
     {
      if(i < M || i >= N - M)
        {
         amplitude[i] = 0.0;
         phase[i] = 0.0;
        }
      else
        {
         amplitude[i] = MathSqrt(paddedSig[i] * paddedSig[i] + hat_x[i] * hat_x[i]); // Pips, no normalization
         phase[i] = Arctan2(hat_x[i], paddedSig[i]);
        }
     }
  }

//+------------------------------------------------------------------+
//| Max Value Template                                               |
//+------------------------------------------------------------------+
template<typename T>
T Stats::maxVal(const T v1, const T v2)
  {
   if(v1 > v2)
      return v1;
   if(v2 > v1)
      return v2;
   return v1; // If equal
  }

//+------------------------------------------------------------------+
//| Extract Hilbert Amp and Phase                                    |
//+------------------------------------------------------------------+
DTYPE Stats::extractHilbertAmpNPhase(const double &hilbertAmp[], const double &hilbertPhase[], double cutOff)
  {
   DTYPE dt;
   int SIZE = ArraySize(hilbertAmp);
   dt.val1 = EMPTY; // Index
   dt.val2 = EMPTY_VALUE; // Amp
   dt.val3 = EMPTY_VALUE; // Phase
   for(int i = 0; i < SIZE; i++)
     {
      if(hilbertAmp[i] > cutOff)
        {
         dt.val1 = i;
         dt.val2 = hilbertAmp[i];
         dt.val3 = hilbertPhase[i];
         break; // Most recent (smallest i) above cutoff
        }
     }
   return dt;
  }

//+------------------------------------------------------------------+
//| Extract DFT Power and Phase                                      |
//+------------------------------------------------------------------+
DTYPE Stats::extractDftPowerNPhase(const double &dftMag[], const double &dftPhase[], const double &dftPower[])
  {
   DTYPE dt;
   int max_power_k = 1;
   double max_power = dftPower[1];
   int SIZE = ArraySize(dftMag) / 2; // k=1 to SIZE/2
   for(int k = 2; k <= (SIZE / 2); k++)   // Limit to 4 for stability
     {
      if(dftPower[k] > max_power)
        {
         max_power = dftPower[k];
         max_power_k = k;
        }
     }
   dt.val1 = max_power_k;
   dt.val2 = dftMag[max_power_k];
   dt.val3 = dftPhase[max_power_k];
   dt.val4 = max_power;
   return dt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  Stats::dotProd(const double &series1[], const double &series2[], const int SIZE = 10, const int interval = 0, int SHIFT = 1)
  {
   double dp = EMPTY_VALUE;
   for(int i = SHIFT; i < SIZE; i = (i + interval))
     {
      if(dp == EMPTY_VALUE)
         dp = 0;
      dp += series1[i] * series2[i];
     }
   return dp;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  Stats::arraySum(const double &arr[], const int SIZE = 10, int SHIFT = 0)
  {
   double sum = EMPTY_VALUE;
   for(int i = SHIFT; i < SIZE; i = i++)
     {
      if(sum == EMPTY_VALUE)
         sum = 0;
      sum += arr[i];
     }
   return sum;
  }

//+------------------------------------------------------------------+
//| vWCM_Score - Volume-Weighted Candle Momentum                     |
//+------------------------------------------------------------------+
double Stats::vWCM_Score(const double &open[], const double &close[],
                         const double &volume[], int N = 10, const int interval = 0, int SHIFT = 1)
  {
   double total_vol = 0.0;
   for(int i = 0; i < N; i++)
      total_vol += volume[i];

   if(total_vol <= 0)
      return 0.0;

   double score = 0.0;
   for(int i = SHIFT; i < N; i = (i + interval))   // ← skip incomplete bars
     {
      double body_pips = (close[i] - open[i]) / util.getPipValue(_Symbol);
      double vol_weight = volume[i] / total_vol;
      score += body_pips * vol_weight;
     }
   return score;
  }

//+------------------------------------------------------------------+
//| vWCM_Score v2 - Normalized & Safe                                |
//+------------------------------------------------------------------+
double Stats::vWCM_Score_v2(const double &open[], const double &close[],
                            const double &volume[], int N = 10, int SHIFT = 1)
  {
   double sum_force = 0.0;
   double total_vol = 0.0;

// Single Loop: Safer and more efficient
   for(int i = SHIFT; i < (N + SHIFT); i++)
     {
      double vol = volume[i];
      double body_pips = (close[i] - open[i]) / util.getPipValue(_Symbol);

      // Force = Direction * Volume
      sum_force += (body_pips * vol);
      total_vol += vol;
     }

   if(total_vol <= 0)
      return 0.0;

// Result is "Weighted Average Pips per Candle"
// This makes it comparable to ATR or average candle size.
   return sum_force / total_vol;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE Stats::getDecimalVal(const double num, const double denom)
  {
   DTYPE dt;
   if((int)num == (int)denom)
     {
      dt.val1 = (num - (int)num);
      dt.val2 = (denom - (int)denom);
     }
   else
      if((int)num < (int)denom)
        {
         dt.val1 = (num - (int)num);
         dt.val2 = (denom - (int)num);
        }
      else
         if((int)num > (int)denom)
           {
            dt.val1 = (num - (int)denom);
            dt.val2 = (denom - (int)denom);
           }
   return dt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats stats(util);
//Stats stats;
//+------------------------------------------------------------------+

////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//class MomentumStrength
//  {
//private:
//   SanUtils          util; // assume your util for pipValue
//   Stats             stats; // Statistical library instance
//public:
//                     MomentumStrength() { /* init if needed */ }
//                     MomentumStrength(SanUtils& ut) {util = ut;}
//                     MomentumStrength(SanUtils& ut,Stats& st)
//     {
//      util = ut;
//      stats =st;
//     }
//   // 1. ATR Normalization (Volatility Proxy, 0-1 with TF scaling)
//   double            atrStrength(const double atr)
//     {
//      double pipValue = util.getPipValue(_Symbol);
//      double atrPips = (pipValue > 0) ? atr / pipValue : 0.0; // Safety div
//      // Dynamic scaling based on timeframe (Logarithmic scale)
//      double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;
//      double atrCeiling = MathCeil(12.0 * tfScale); // Your recommended multiplier
//      double atrNorm = MathMin(MathMax(atrPips / atrCeiling, 0.0), 1.0);
//      return (atrNorm*atrNorm); // 0-1: low = quiet/weak, high = wild/strong
//      //return (atrNorm); // 0-1: low = quiet/weak, high = wild/strong
//     }
//   // 2. ADX Normalization (Trend Strength, 0-1)
//   double            adxStrength(const double scale=50.0, int period = 10, int shift = 1)
//     {
//      double adx = iADX(NULL, 0, period, PRICE_CLOSE, MODE_MAIN, shift);
//      double normAdx = MathMin(adx / scale, 1.0);
//      return (normAdx*normAdx); // 0-1 scale (>1 rare, cap at 1)
//      //return (normAdx); // 0-1: low = quiet/weak, high = wild/strong
//     }
//   // 3. Kaufman's Efficiency Ratio (Directional Efficiency, 0-1)
//   double            efficiencyRatio(const double &price[], int period = 14, int shift = 0)
//     {
//      double net = MathAbs(price[shift] - price[shift + period]);
//      double sumAbs = 0.0;
//      for(int i = shift; i < shift + period; i++)
//         sumAbs += MathAbs(price[i] - price[i+1]);
//      return (sumAbs > 0) ? net / sumAbs : 0.0;
//     }
//   // 3. vWCM (Volume-Weighted Candle Momentum, -1 to 1 normalized)
//   double            vWCM(const double &open[], const double &close[], const double &volume[], int N = 10, int SHIFT = 1)
//     {
//      double sum_force = 0.0;
//      double total_vol = 0.0;
//      for(int i = SHIFT; i < N + SHIFT; i++)
//        {
//         double body_pips = (close[i] - open[i]) / util.getPipValue(_Symbol);
//         sum_force += body_pips * volume[i];
//         total_vol += volume[i];
//        }
//      if(total_vol <= 0)
//         return 0.0;
//      double raw = sum_force / total_vol;
//      return stats.tanh(raw / 10.0); // normalize -1 to 1 with tanh for bounded output
//     }
//
//   //+------------------------------------------------------------------+
//   //| FUNCTION: layeredMomentumFilter                                  |
//   //| PURPOSE:  Identifies High-Quality, Sustainable Trends            |
//   //| RETURNS:  1 (Buy), -1 (Sell), 0 (Neutral/No Signal)              |
//   //+------------------------------------------------------------------+
//   //| ALGORITHM LOGIC:                                                 |
//   //| 1. Directional Consensus (The "80% Rule"):                       |
//   //|    - Calculates slopes for the last N bars.                      |
//   //|    - Requires 80% of slopes to agree on direction (Buy/Sell).    |
//   //|                                                                  |
//   //| 2. Volatility Gate (ADX):                                        |
//   //|    - Rejects low volatility (ADX < 20) to avoid ranging markets. |
//   //|                                                                  |
//   //| 3. Strength Gate (Histogram Magnitude):                          |
//   //|    - Maps slope strengths into 5 bins (0=Weak to 4=Strong).      |
//   //|    - Requires the dominant bin to be > 2 (Top 40% strength).     |
//   //|    - Filters out "lazy" trends that lack conviction.             |
//   //|                                                                  |
//   //| 4. Quality Gate (Statistical Stability):                         |
//   //|    - Kurtosis < 2.0: Rejects "Spikes" (News events/Wicks).       |
//   //|    - Skewness < 0.5: Rejects "Parabolic" moves (Bubbles).        |
//   //|    - RESULT: Accepts only linear, steady, sustainable trends.    |
//   //+------------------------------------------------------------------+
//   double            layeredMomentumFilter(const double &values[], int N = 20)
//     {
//      // --- Step 1: Get Smoothed Slopes (in PIPS) ---
//      double slopes[];
//      //Print("STAGE-1");
//      // Denominator 3 smooths noise. Shift 1 to avoid open candle.
//      if(!stats.slopeRange_v2(values, slopes, N, 3, 1))
//         return 0;
//      //Print("STAGE-2");
//      int SIZE = ArraySize(slopes);
//      if(SIZE < N)
//         return 0; // Safety
//      //Print("STAGE-3");
//      // --- Step 2: Directional Consensus (The 80% Rule) ---
//      int slopeBuy = 0;
//      int slopeSell = 0;
//      for(int i=0; i<SIZE; i++)
//        {
//         if(slopes[i] > 0)
//            slopeBuy++;
//         if(slopes[i] < 0)
//            slopeSell++;
//        }
//
//      SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
//
//      // Logic: 80% of bars must agree on direction
//      // Use >= to capture 80% or more (e.g. 16/20, 17/20...)
//      if((double)slopeBuy >= 0.8 * SIZE)
//         sig = SAN_SIGNAL::BUY;
//      else
//         if((double)slopeSell >= 0.8 * SIZE)
//            sig = SAN_SIGNAL::SELL;
//
//      // If mixed direction (choppy), exit immediately
//      if(sig == SAN_SIGNAL::NOSIG)
//         return 0;
//      //Print("STAGE-4");
//      // --- Step 3: ADX Gate (Market Awake?) ---
//
//      //double adx = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 1);
//      ////Print("STAGE-4.1: ADX: "+adx);
//      //if(adx < 20.0)
//      //   return 0;
//
//      //###############################################
//      // --- Step 3: Dynamic ADX Gate ---
//      double adx = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 1);
//      // 1. Determine Baseline (15 for Scalping, 20 for Swing)
//      double baseline = (Period() < PERIOD_H1) ? 15.0 : 20.0;
//      // 2. Check
//      if(adx < baseline)
//         return 0;
//     //###############################################
//
//
//      //Print("STAGE-5");
//      // --- Step 4: Histogram Gate (Momentum Conviction) ---
//      // Threshold = 1.0 Pip.
//      // If max slope < 1.0 pip, it is forced into lower bins (Weak).
//      // This effectively filters out "drifting" markets.
//
//      //double atr = iATR(NULL, 0, 14, 1);
//      //double pipUnit = util.getPipValue(_Symbol);
//      //if(pipUnit == 0)
//      //   pipUnit = Point;
//      //double thresh = (atr / pipUnit) * 0.10; // 10% of ATR is the noise floor
//
//      int domBin = stats.histogram_Magnitude(slopes, N, 5, 0.2);
//
//      //int domBin = stats.histogram_Magnitude(slopes, 5, 1.0);
//      //Print("STAGE-5.1: "+domBin);
//      if(domBin == -1)
//         return 0; // No clustering (flat distribution)
//      //Print("STAGE-6");
//      //if(domBin < 3)
//      if(domBin < 2)
//         return 0;   // Cluster is in Left/Middle (Weak) bins
//      //Print("STAGE-7");
//      // --- Step 5: Quality Gate (Statistical Stability) ---
//
//      double skew = stats.skewness(slopes, N);
//      double kurt = stats.kurtosis_v3(slopes, N);
//      //Print("STAGE-7.1: skew: "+skew+" kurt: "+kurt);
//
//      // Reject Parabolic Bubbles (High Skew > 0.5)
//      // We want steady trends, not explosions that might reverse.
//      if(MathAbs(skew) > 0.5)
//         return 0;
//      //Print("STAGE-8");
//      // Reject News Spikes (High Kurtosis > 2.0)
//      if(kurt > 2.0)
//         return 0;
//      //Print("STAGE-9");
//
//      //Print("domBin: "+ domBin+ " kurt: "+kurt+ " skewn: "+skew);
//      // --- Final Signal Trigger ---
//      if(sig == SAN_SIGNAL::BUY)
//         return 1.0;
//      if(sig == SAN_SIGNAL::SELL)
//         return -1.0;
//      //Print("STAGE-10");
//      return 0.0;
//     }
//
//   // =================================================================
//   // GROUP: DECAY & RETENTION STRATEGIES
//   // Purpose: Calculate multiplier (0.0-1.0) to lower exit thresholds
//   // =================================================================
//
//   // 1. TIME DECAY (Linear)
//   // Use Case: Reduce strictness simply because time has passed.
//   // Example: getLinearTimeRetention(barsHeld, 0.05, 0.60);
//   double            getLinearTimeRetention(int barsHeld, double decayRate = 0.05, double floor = 0.60)
//     {
//      double retention = 1.0 - (barsHeld * decayRate);
//      return MathMax(retention, floor);
//     }
//
//   // 2. VOLATILITY DECAY (Adaptive Trend Following)
//   // Use Case: "Tight Leash" in Calm, "Loose Leash" in Turbulent.
//   // Returns: High value (0.98) in Calm, Lower value (0.82) in Volatility.
//   double            getVolAdaptiveRetention(double atr)
//     {
//      // 1. Get Normalized Volatility (0.0 to 1.0)
//      // Note: We use the raw linear norm here (no power curve) for proportional adaptation.
//      double volScore = atrStrength(atr);
//
//      // 2. Trend Following Logic
//      // Calm (0.0) -> 0.98 Retention (Strict)
//      // Wild (1.0) -> 0.82 Retention (Loose)
//      // Sqrt makes it loosen quickly as soon as volatility starts.
//      double retention = 0.98 - (0.16 * MathSqrt(volScore));
//
//      // Safety Clamp: Never loosen below 70%
//      return MathMax(retention, 0.70);
//     }
//
//   // 3. HYBRID DECAY (Time + Volatility)
//   // Use Case: The longer we hold AND the crazier the market, the looser we get.
//   // Or: We hold tight in calm markets but relax as time passes.
//   double            getHybridRetention(int barsHeld, double atr)
//     {
//      double timeRet = getLinearTimeRetention(barsHeld, 0.02, 0.80); // Slow time decay
//      double volRet  = getVolAdaptiveRetention(atr);                 // Adaptive vol decay
//
//      // Combine them: (e.g., 0.95 * 0.90 = 0.855)
//      return (timeRet * volRet);
//     }
//  };


////+------------------------------------------------------------------+
////| CLASS: MarketMetrics                                          |
////| Purpose: Centralized library for Market Physics metrics.         |
////| Contains: ATR (Vol), ADX (Trend), ER (Efficiency), vWCM (Force)  |
////+------------------------------------------------------------------+
//class MarketMetrics
//
//  {
//private:
//   SanUtils          util;
//   Stats             stats;
//
//public:
//                     MarketMetrics() { }
//                     MarketMetrics(SanUtils& ut) {util = ut;}
//                     MarketMetrics(SanUtils& ut,Stats& st) { util = ut; stats = st; }
//
//   // =================================================================
//   // GROUP 1: BASE METRICS (The Physics)
//   // =================================================================
//
//
//   // =================================================================
//   // GROUP 1: THE ADX PHYSICS ENGINE (The Trinity)
//   // =================================================================
//
//   // 1. adxPotential (Formerly getTrendPower)
//   // CONCEPT: Potential Energy / Market State
//   // PURPOSE: Context. "Is the environment charged?"
//   // RETURNS: Open-ended Ratio (e.g., 1.5 = 1.5x Baseline).
//   //          < 0.75 is Dead. > 1.5 is Runaway.
//   double            adxPotential(int period = 14, int shift = 1)
//     {
//      double adx = iADX(NULL, 0, period, PRICE_CLOSE, MODE_MAIN, shift);
//      // Baseline is ADX 20.
//      return (adx / 20.0);
//     }
//
//   // 2. adxKinetic (Formerly adxStrength)
//   // CONCEPT: Kinetic Energy / Intensity
//   // PURPOSE: Weighting. "How much force is in this specific move?"
//   // RETURNS: 0.0 to 1.0 (Squared curve to suppress noise)
//   double            adxKinetic(const double scale=50.0, int period = 10, int shift = 1)
//     {
//      double adx = iADX(NULL, 0, period, PRICE_CLOSE, MODE_MAIN, shift);
//      double normAdx = MathMin(adx / scale, 1.0);
//      return (normAdx*normAdx);
//     }
//
//   // 3. adxVector (Formerly adxAdvancedStrength)
//   // CONCEPT: Vector / Velocity
//   // PURPOSE: Signal. "Which direction and with what conviction?"
//   // RETURNS: -1.0 (Bearish) to +1.0 (Bullish)
//   double            adxVector(const double main, const double plus, const double minus)
//     {
//      double direction = plus - minus;
//      double spread = MathMax(fabs(main - plus), fabs(main - minus));
//
//      // Weight by potential energy (main ADX)
//      // If ADX < 20, we dampen the vector (Low Potential).
//      double trendWeight = (main < 20) ? (main / 20.0) * 0.5 : (main / 20.0);
//
//      double rawSignal = direction * trendWeight * (spread * 0.01);
//      return stats.tanh(rawSignal);
//     }
//
//   // =================================================================
//   // GROUP 2: VOLATILITY METRICS
//   // =================================================================
//
//   // 4. atrStrength (Kinetic Volatility)
//   // Returns 0-1 based on how "loud" the current candle is vs expectation.
//   double            atrKinetic(const double atr)
//     {
//      double pipValue = util.getPipValue(_Symbol);
//      double atrPips = (pipValue > 0) ? atr / pipValue : 0.0;
//      double tfScale = (_Period > 1) ? MathLog(_Period) : 1.0;
//      double atrCeiling = MathCeil(12.0 * tfScale);
//      double atrNorm = MathMin(MathMax(atrPips / atrCeiling, 0.0), 1.0);
//      return (atrNorm*atrNorm);
//     }
//
//   // 5. volatilityEfficiency (VE)
//   // Logic: Measures if current volatility expansion is "Holding" (Structure)
//   //        and "Moving" (Momentum).
//   // Returns: -1.0 (Sell Vol) to 1.0 (Buy Vol)
//
//   double            volatilityEfficiency(const double stdOpen, const double stdCp,
//                                          const double slopeOP, const double slopeCP)
//     {
//      // A. Structure & Momentum
//      double denominator = (stdOpen < 0.00005) ? 0.00005 : stdOpen;
//      double structureRatio = stdCp / denominator;
//
//      double slopeDenom = (MathAbs(slopeOP) < 0.00005) ? 0.00005 : MathAbs(slopeOP);
//      double momentumRatio = MathAbs(slopeCP) / slopeDenom;
//
//      // C. Convergence
//      // Positive = Expansion. Negative = Contraction.
//      double rawScore = (structureRatio - 1.0) + (momentumRatio - 1.0);
//
//      // *** THE FIX ***
//      // If volatility is contracting (rawScore < 0), there is NO breakout energy.
//      // We clamp it to 0.0 to prevent "Double Negative" false signals.
//      if(rawScore <= 0)
//         return 0.0;
//
//      // D. Direction & Normalize
//      int direction = (slopeCP >= 0) ? 1 : -1;
//      return stats.tanh(rawScore * direction * 2.0);
//     }
//
//   // 6. volatilityAnomaly (Relative Volatility)
//   // CONCEPT: Climate Check
//   // PURPOSE: Context. "Is today unusually quiet or unusually loud?"
//   // RETURNS: Ratio (1.0 = Normal).
//   //          > 1.5 = Stormy (High Vol). < 0.7 = Quiet (Low Vol).
//   double   volatilityAnomaly(string symbol, int tf, int period)
//     {
//      // 1. Get History
//      int bufferSize = period * 2;
//      double std_buffer[];
//      ArrayResize(std_buffer, bufferSize);
//      // ... fill buffer loop (same as GetStrength) ...
//      for(int i = 0; i < bufferSize; i++)
//        {
//         std_buffer[i] = iStdDev(symbol, tf, period, 0, MODE_SMA, PRICE_CLOSE, i + 1);
//        }
//
//      // 2. Compare Current vs Average
//      double stdCurrent = std_buffer[0];
//      double avgStd = iMAOnArray(std_buffer, 0, bufferSize, 0, MODE_SMA, 0);
//
//      return (avgStd > 0) ? (stdCurrent / avgStd) : 1.0;
//     }
//   // 3. Kaufman's Efficiency Ratio (Directional Efficiency, 0-1)
//   // 1.0 = Straight Line (Perfect Efficiency)
//   // 0.0 = Random Chop (Zero Efficiency)
//   double            efficiencyRatio(const double &price[], int period = 14, int shift = 0)
//     {
//      double net = MathAbs(price[shift] - price[shift + period]);
//      double sumAbs = 0.0;
//      for(int i = shift; i < shift + period; i++)
//         sumAbs += MathAbs(price[i] - price[i+1]);
//      return (sumAbs > 0) ? net / sumAbs : 0.0;
//     }
//
//   // 4. vWCM (Volume-Weighted Candle Momentum, -1 to 1 normalized)
//   double            vWCM(const double &open[], const double &close[], const double &volume[], int N = 10, int SHIFT = 1)
//     {
//      double sum_force = 0.0;
//      double total_vol = 0.0;
//      for(int i = SHIFT; i < N + SHIFT; i++)
//        {
//         double body_pips = (close[i] - open[i]) / util.getPipValue(_Symbol);
//         sum_force += body_pips * volume[i];
//         total_vol += volume[i];
//        }
//      if(total_vol <= 0)
//         return 0.0;
//
//      double raw = sum_force / total_vol;
//      return stats.tanh(raw / 10.0);
//     }
//
//   //+------------------------------------------------------------------+
//   //| Function: Calculate MA Acceleration                              |
//   //| Returns:  True if acceleration is positive (gaining strength)    |
//   //+------------------------------------------------------------------+
//   //bool              isTrendAccelerating(string symbol, int timeframe, int ma_period)
//   bool              isTrendAccelerating(const double &sig[], int shift=1)
//
//     {
//      // 1. Get the MA values for the last 3 completed bars
//      //double ma0 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 1);
//      //double ma1 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 2);
//      //double ma2 = iMA(symbol, timeframe, ma_period, 0, MODE_SMA, PRICE_CLOSE, 3);
//
//      double ma0 = sig[shift];
//      double ma1 = sig[shift+1];
//      double ma2 = sig[shift+2];;
//
//
//      // 2. First Derivative: Velocity (Slope)
//      // How much did the MA change between bars?
//      double velocity_now  = ma0 - ma1; // Current slope
//      double velocity_prev = ma1 - ma2; // Previous slope
//
//      // 3. Second Derivative: Acceleration
//      // Is the slope getting steeper?
//      double acceleration = velocity_now - velocity_prev;
//
//      // Logic: If velocity is positive AND acceleration is positive,
//      // the bullish trend is gaining strength.
//      if(velocity_now > 0 && acceleration > 0)
//         return(true);
//
//      // Logic: If velocity is negative AND acceleration is negative,
//      // the bearish trend is gaining strength.
//      if(velocity_now < 0 && acceleration < 0)
//         return(true);
//
//      return(false);
//     }
//
//   double            trendAccelStrength(const double &sig[], int shift=1)
//     {
//      double v0 = sig[shift];
//      double v1 = sig[shift+1];
//      double v2 = sig[shift+2];
//
//      // 1. Calculate raw change in price units
//      double velocity_now  = v0 - v1;
//      double velocity_prev = v1 - v2;
//      double raw_accel     = velocity_now - velocity_prev;
//
//      // 2. Normalize using Point to get a "Sensitivity" score
//      // We convert the tiny decimal into "Points"
//      double accel_in_points = raw_accel / Point;
//
//      // 3. Sensitivity Adjustment
//      // Adjust this 'k' factor to decide how "twitchy" the signal is.
//      // k = 0.1 means it takes 10 points of acceleration to hit a strong signal.
//      double k = 0.1;
//
//      return stats.tanh(accel_in_points * k);
//     }
//
//
////
////   double            GetStrength(string symbol, int tf, int period)
////     {
////      // 1. Statistical Volatility (Standard Deviation)
////      // We need a small buffer to calculate the average of the StdDev
////      int bufferSize = period * 2;
////      double std_buffer[];
////      ArrayResize(std_buffer, bufferSize);
////      ArraySetAsSeries(std_buffer, true);
////
////      // Fill the buffer with historical StdDev values
////      for(int i = 0; i < bufferSize; i++)
////        {
////         std_buffer[i] = iStdDev(symbol, tf, period, 0, MODE_SMA, PRICE_CLOSE, i + 1);
////        }
////
////      double stdCurrent = std_buffer[0];
////      // Calculate Average StdDev (The "Baseline" Volatility)
////      double avgStd = iMAOnArray(std_buffer, 0, bufferSize, 0, MODE_SMA, 0);
////
////      // 2. Trend Strength (ADX)
////      double adx     = iADX(symbol, tf, period, PRICE_CLOSE, MODE_MAIN, 1);
////      double plusDI  = iADX(symbol, tf, period, PRICE_CLOSE, MODE_PLUSDI, 1);
////      double minusDI = iADX(symbol, tf, period, PRICE_CLOSE, MODE_MINUSDI, 1);
////
////      // 3. Normalize the raw force
////      // Difference in DI scaled by the ADX magnitude (structural permission)
////      double rawForce = (plusDI - minusDI) * (adx / 100.0);
////
////      // 4. Apply Volatility Weighting (The "Fuel" Check)
////      // If current std is twice the average, volWeight = 2.0 (Amplify)
////      // If current std is half the average, volWeight = 0.5 (Dampen)
////      double volWeight = (avgStd > 0) ? (stdCurrent / avgStd) : 1.0;
////      double finalSignal = rawForce * volWeight;
////
////      // 5. Squash with Tanh
////      // Scaling factor 0.1 adjusted for standard currency volatility
////      return stats.tanh(finalSignal * 0.1);
////     }
//
//   // =================================================================
//   // GROUP 2: FILTERS & SIGNALS
//   // =================================================================
//
//   //+------------------------------------------------------------------+
//   //| FUNCTION: layeredMomentumFilter                                  |
//   //| REFACTORED: Now uses Universal Trend Power (No Timeframe Hacks)  |
//   //+------------------------------------------------------------------+
//   double            layeredMomentumFilter(const double &values[], int N = 20)
//     {
//      // --- Step 1: Get Smoothed Slopes ---
//      double slopes[];
//      if(!stats.slopeRange_v2(values, slopes, N, 3, 1))
//         return 0;
//
//      int SIZE = ArraySize(slopes);
//      if(SIZE < N)
//         return 0;
//
//      // --- Step 2: Directional Consensus (The 80% Rule) ---
//      int slopeBuy = 0;
//      int slopeSell = 0;
//      for(int i=0; i<SIZE; i++)
//        {
//         if(slopes[i] > 0)
//            slopeBuy++;
//         if(slopes[i] < 0)
//            slopeSell++;
//        }
//
//      SAN_SIGNAL sig = SAN_SIGNAL::NOSIG;
//      if((double)slopeBuy >= 0.8 * SIZE)
//         sig = SAN_SIGNAL::BUY;
//      else
//         if((double)slopeSell >= 0.8 * SIZE)
//            sig = SAN_SIGNAL::SELL;
//
//      if(sig == SAN_SIGNAL::NOSIG)
//         return 0;
//
//      // --- Step 3: DYNAMIC ADX GATE (Unified Trend Power) ---
//      // We reject anything below "Trend Power 0.75" (ADX 15).
//      // This allows M15 scalps AND early H1 entries, but kills dead markets.
//      double power = adxPotential(14, 1);
//
//      if(power < 0.75)
//         return 0;
//
//      // --- Step 4: Histogram Gate (Momentum Conviction) ---
//      int domBin = stats.histogram_Magnitude(slopes, N, 5, 0.2);
//      if(domBin == -1)
//         return 0;
//      if(domBin < 2)
//         return 0;
//
//      // --- Step 5: Quality Gate (Statistical Stability) ---
//      double skew = stats.skewness(slopes, N);
//      double kurt = stats.kurtosis_v3(slopes, N);
//
//      // Reject Parabolic Bubbles (High Skew > 0.5)
//      if(MathAbs(skew) > 0.5)
//         return 0;
//      // Reject News Spikes (High Kurtosis > 2.0)
//      if(kurt > 2.0)
//         return 0;
//
//      // --- Final Signal Trigger ---
//      if(sig == SAN_SIGNAL::BUY)
//         return 1.0;
//      if(sig == SAN_SIGNAL::SELL)
//         return -1.0;
//      return 0.0;
//     }
//
//   // =================================================================
//   // GROUP 3: DECAY & RETENTION STRATEGIES
//   // =================================================================
//
//   // 1. TIME DECAY (Linear)
//   double            getLinearTimeRetention(int barsHeld, double decayRate = 0.05, double floor = 0.60)
//     {
//      double retention = 1.0 - (barsHeld * decayRate);
//      return MathMax(retention, floor);
//     }
//
//   // 2. VOLATILITY DECAY (Adaptive Trend Following)
//   double            getVolAdaptiveRetention(double atr)
//     {
//      // 1. Get Normalized Volatility (0.0 to 1.0)
//      //double volScore = atrStrength(atr);
//      double volScore = atrKinetic(atr);
//
//      // 2. Trend Following Logic
//      // Sqrt makes it loosen quickly as soon as volatility starts.
//      double retention = 0.98 - (0.16 * MathSqrt(volScore));
//
//      return MathMax(retention, 0.70);
//     }
//
//   // 3. HYBRID DECAY (Time + Volatility)
//   double  getHybridRetention(int barsHeld, double atr)
//     {
//      double timeRet = getLinearTimeRetention(barsHeld, 0.02, 0.80);
//      double volRet  = getVolAdaptiveRetention(atr);
//      return (timeRet * volRet);
//     }
//  };
//
////+------------------------------------------------------------------+
////|                                                                  |
////+------------------------------------------------------------------+
//MarketMetrics ms(util,stats);
////+------------------------------------------------------------------+
