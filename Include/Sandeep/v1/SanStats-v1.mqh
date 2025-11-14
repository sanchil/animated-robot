//+------------------------------------------------------------------+
//|                                                     SanStats.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

//#include <Sandeep/v1/SanTypes-v1.mqh>
#include <Sandeep/v1/SanUtils-v1.mqh>

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
class Stats {
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
   double            dotProd(const double &series1[], const double &series2[], const int SIZE = 10, const int interval = 1, int SHIFT = 1);
   DTYPE             getDecimalVal(const double num, const double denom);

   DTYPE     slopeVal(
      const double &sig[],
      const int SLOPEDENOM = 3,
      const int SLOPEDENOM_WIDE = 5,
      const int shift = 1
   );

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
   DTYPE            extractHilbertAmpNPhase(const double &hilbertAmp[], const double &hilbertPhase[], double cutOff); //,const double &dftMag[],const double &dftPhase[],const double &dftPower[]);
   DTYPE            extractDftPowerNPhase(const double &dftMag[], const double &dftPhase[], const double &dftPower[]);

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
Stats::Stats(SanUtils& util) {
   ut = util;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Stats::~Stats() {
// delete util;
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::sayMesg1() {
   Print("Message from stats is : " + mesg);
};
//------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Stats::getDataSize(const double &data[], int n = 0, int shift = 0) {
   long SIZE = EMPTY_VALUE;
   if(n <= 0) {
      SIZE = (ArraySize(data) - shift);
   } else if(((n - shift) > 0) && ((n - shift) < ArraySize(data))) {
      SIZE = (n - shift);
   } else if((n - shift) >= ArraySize(data)) {
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
double  Stats::mean(const double &data[], int n = 0, double shift = 0) {
   double sum = 0.0;
   double mean = EMPTY_VALUE;
   long SIZE = getDataSize(data, n, shift);
   int count = 0;
   for(int i = 0; i < SIZE; i++) {
      if(data[i] != 0) {
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
double Stats::Arctan2(double y, double x) {
   if(x > 0) return MathArctan(y / x);
   if(x < 0) {
      if(y >= 0) return MathArctan(y / x) + M_PI;
      return MathArctan(y / x) - M_PI;
   }
   if(y > 0) return M_PI / 2;
   if(y < 0) return -M_PI / 2;
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
double  Stats::acf(const double &data[], int n = 0, int lag = 1) {
   long SIZE = getDataSize(data, n);
   double yk = 0;
   double y0 = 0;
   double mn = mean(data, n);
   double yn;
   double yn1;
// Print("ACF Mean: "+mn+" SIZE: "+SIZE);
   for(int i = 0; i < (SIZE - lag); ++i) {
      yk += (data[i] - mn) * (data[i + lag] - mn);
   }
   for(int i = 0; i < (SIZE); ++i) {
      //yd[i] = (data[i]-mn)*(data[i]-mn);
      y0 += (data[i] - mn) * (data[i] - mn);
   }
//yk=yk/(SIZE-lag);
//y0=y0/SIZE;
//   Print("Arraysize: "+SIZE+"yk: "+yk+" y0: "+y0);
   if(y0 == 0) {
      return 0;
   }
   if(yk == 0) {
      return 0;
   }
   if((yk != 0) && (y0 != 0)) {
      return yk / y0;
   }
   return EMPTY_VALUE;
};

//+------------------------------------------------------------------+
//|             σ = √(Σ(xi - μ)² / N)
//      if type is 0 it is calculated for sample else for population. default is for sample
// double x[] =  { 10, 20, 30, 40, 50}; std value = 15.81                                               |
//+------------------------------------------------------------------+
double     Stats::stdDev(const double &data[], int type = 0, int n = 0, int shift = 0) {
   double summation = 0;
   double mn = mean(data, n);
   long SIZE = getDataSize(data, n, shift);
   for(int i = shift; i < SIZE; i++) {
      summation += (data[i] - mn) * (data[i] - mn);
   }
//  Print("Summation: "+summation+" Denominator:  "+SIZE);
   if(type == 0) {
      return sqrt(summation / (SIZE - 1));
   }
   if(type == 1) {
      return sqrt(summation / SIZE);
   }
   if(type == 2) {
      return sqrt(summation / sqrt(SIZE));
   }
   return EMPTY_VALUE;
};


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
SLOPETYPE Stats::scatterPlot(const double& sig[], int SIZE = 21, int SHIFT = 1) {
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
   for(int i = SHIFT, j = 0; i < SIZE; i++, j++) { // This flips slope value
      xy += sig[i] * j;
      sumx += j;
      sumy += sig[i];
      sumxsq += j * j;
   }
   num = N * xy - (sumx * sumy);
   denom = N * sumxsq -  (sumx * sumx);
   if(num == 0)num = num + 0.000001;
   if(denom == 0)denom = denom + 0.000001;
//slope = -1*(num/denom);
//intercept = ((sumy-slope*sumx)/N);
//dt.matrixD[0]=slope;
//dt.matrixD[1]=intercept;
   st.slope = -1 * (num / denom);
   st.intercept = ((sumy - st.slope * sumx) / N);
   return st;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//DataTransport   Stats::slopeVal(
DTYPE   Stats::slopeVal(
   const double &sig[],
   const int SLOPEDENOM = 3,
   const int SLOPEDENOM_WIDE = 5,
   const int shift = 1
) {
//   DataTransport dt;
   DTYPE dt;
// double tPoint = ut.getPipValue(_Symbol);
   double tPoint = Point;
   //dt.matrixD[0] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM])/(SLOPEDENOM*tPoint)),3);
   //dt.matrixD[1] = NormalizeDouble(((sig[shift]-sig[SLOPEDENOM_WIDE])/(SLOPEDENOM_WIDE*tPoint)),3);
   //return dt;
   dt.val1 = NormalizeDouble(((sig[shift] - sig[SLOPEDENOM]) / (SLOPEDENOM * tPoint)), 3);
   dt.val2 = NormalizeDouble(((sig[shift] - sig[SLOPEDENOM_WIDE]) / (SLOPEDENOM_WIDE * tPoint)), 3);
   return dt;
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
) {
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
double Stats::cov(const double &x[], const double &y[], int n = 0, int shift = 0) {
   double coeff = EMPTY_VALUE;
   double num = 0;
   double denomx = 0;
   double denomy = 0;
   double denom = 0;
   double xm = mean(x);
   double ym = mean(y);
   long SIZE = getDataSize(x);
//  for(int i=0; i<(SIZE-shift); i++)
   for(int i = shift; i < SIZE; i++) {
      num += ((x[i] - xm) * (y[i] - ym));
   }
//denom =sqrt(denomx)*sqrt(denomy);
   denom = (SIZE - 1);
   if(num == 0) {
      return 0;
   }
   if(denom == 0) {
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
double Stats::pearsonCoeff(const double &x[], const double &y[], int n = 0, int shift = 0) {
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
   for(int i = shift; i < SIZE; i++) {
      num += ((x[i] - xm) * (y[i] - ym));
      denomx += ((x[i] - xm) * (x[i] - xm));
      denomy += ((y[i] - ym) * (y[i] - ym));
   }
   denom = sqrt(denomx) * sqrt(denomy);
//if((num==0) || (denom==0))
//   return 1000000.314;
   if(num == 0) {
      return 0;
   }
   if(denom == 0) {
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
SANTREND Stats::convDivTest(const double &top[], const double &bottom[], int n = 0, int shift = 0) {
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
   for(int i = shift, j = 0; (i + 1) < (SIZE); i++, j++) {
      topr = (top[i] / top[i + 1]);
      bottomr = (bottom[i] / bottom[i + 1]);
      // Print(" topr: "+topr+" bottomr: "+bottomr);
      if((topr > 1) && (bottomr > 1) && (topr > bottomr)) {
         updive++;
         d.matrixD[0]++;
      }
      if((topr > 1) && (bottomr > 1) && (topr < bottomr)) {
         upconv++;
         d.matrixD[1]++;
      }
      if((topr > 1) && (bottomr > 1) && (topr == bottomr)) {
         upflat++;
         d.matrixD[2]++;
      }
      if((topr < 1) && (bottomr < 1) && (topr > bottomr)) {
         downdive++;
         d.matrixD[3]++;
      }
      if((topr < 1) && (bottomr < 1) && (topr < bottomr)) {
         downconv++;
         d.matrixD[4]++;
      }
      if((topr < 1) && (bottomr < 1) && (topr == bottomr)) {
         downflat++;
         d.matrixD[5]++;
      }
      if((topr == 1) && (bottomr > 1)) {
         upperflatconv++;
         d.matrixD[6]++;
      }
      if((topr == 1) && (bottomr < 1)) {
         upperflatdive++;
         d.matrixD[7]++;
      }
      if((topr > 1) && (bottomr == 1)) {
         lowerflatdive++;
         d.matrixD[8]++;
      }
      if((topr < 1) && (bottomr == 1)) {
         lowerflatconv++;
         d.matrixD[9]++;
      }
      if((topr == 1) && (bottomr == 1)) {
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
   for(int i = 0; i < 12; i++) {
      if((i != first) && (second == -1000314)) {
         secondVal = d.matrixD[i];
         second = i;
      }
      if((i != first) && (second != -1000314) && (d.matrixD[i] > secondVal)) {
         secondVal = d.matrixD[i];
         second = i;
      }
      if((i != first) && (i != second) && (third == -1000314)) {
         thirdVal = d.matrixD[i];
         third = i;
      }
      if((i != first) && (i != second) && (third != -1000314) && (d.matrixD[i] > thirdVal)) {
         thirdVal = d.matrixD[i];
         third = i;
      }
   }
   if(first == 0) {
      return SANTREND::DIVUP;
   }
   if(first == 1) {
      return SANTREND::CONVUP;
   }
   if(first == 2) {
      return SANTREND::DIVDOWN;
   }
   if(first == 3) {
      return SANTREND::CONVDOWN;
   }
   if(first == 4) {
      return SANTREND::DIVFLAT;
   }
   if(first == 5) {
      return SANTREND::CONVFLAT;
   }
   if(first == 6) {
      return SANTREND::DIVFLAT;
   }
   if(first == 7) {
      return SANTREND::CONVFLAT;
   }
   if(first == 8) {
      return SANTREND::FLATUP;
   }
   if(first == 9) {
      return SANTREND::FLATDOWN;
   }
   if(first == 10) {
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
double   Stats::zScore(double inpVal, double mean, double std) {
   return ((inpVal - mean) / (std + 0.000000001));
// Print("Std: "+std+" std+error: "+ (std+0.00001));
//if(std!=0)
//   return (inpVal - mean)/(std);
//if(std==0)
//   return 0;
//return 0;
}

// Get element from a single-array matrix
double Stats::getElement(const double &matrix[], const int i, const int j, const int DIM, const int rowSize) {
   if(i < 0 || j < 0 || i >= DIM || j >= DIM) return EMPTY_VALUE;
   int elemPosition = (i * rowSize) + j;
   if(elemPosition >= ArraySize(matrix)) return EMPTY_VALUE;
   if(!MathIsValidNumber(matrix[elemPosition])) return EMPTY_VALUE;
   return matrix[elemPosition];
}

// Helper function to create a submatrix excluding specified row and column
void Stats::createSubmatrix(const double &matrix[], double &submatrix[], const int excludeRow, const int excludeCol, const int DIM, const int rowSize) {
   int subDim = DIM - 1;
   ArrayResize(submatrix, subDim * subDim);
   for(int i = 0, k = 0; i < DIM; i++) {
      if(i == excludeRow) continue;
      for(int j = 0; j < DIM; j++) {
         if(j == excludeCol) continue;
         submatrix[k++] = getElement(matrix, i, j, DIM, rowSize);
      }
   }
}

// Calculate determinant of a square matrix
double Stats::det(const double &matrix[], const int DIM = 2) {
   if(DIM <= 0 || DIM > 5) return EMPTY_VALUE;
   if(ArraySize(matrix) != (DIM * DIM)) return EMPTY_VALUE;
   for(int i = 0; i < ArraySize(matrix); i++) {
      if(!MathIsValidNumber(matrix[i])) return EMPTY_VALUE;
   }
   int rowSize = ArraySize(matrix) / DIM;
// 2x2 matrix determinant: ad - bc
   if(DIM == 2) {
      return matrix[0] * matrix[3] - matrix[1] * matrix[2];
   }
// 3x3 matrix determinant: a(ei - fh) - b(di - fg) + c(dh - eg)
   if(DIM == 3) {
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
   if(DIM == 4 || DIM == 5) {
      // Copy matrix to avoid modifying input
      double A[];
      ArrayCopy(A, matrix);
      int n = DIM;
      int permutations = 0; // Track row swaps for determinant sign
      // LU decomposition with partial pivoting
      for(int i = 0; i < n - 1; i++) {
         // Find pivot
         int pivotRow = i;
         double pivot = MathAbs(A[i * rowSize + i]);
         for(int k = i + 1; k < n; k++) {
            double value = MathAbs(A[k * rowSize + i]);
            if(value > pivot) {
               pivot = value;
               pivotRow = k;
            }
         }
         // Check for singular matrix
         if(pivot < 1e-10) return 0.0; // Near-zero pivot indicates singular matrix
         // Swap rows if needed
         if(pivotRow != i) {
            for(int j = 0; j < n; j++) {
               double temp = A[i * rowSize + j];
               A[i * rowSize + j] = A[pivotRow * rowSize + j];
               A[pivotRow * rowSize + j] = temp;
            }
            permutations++;
         }
         // Eliminate below pivot
         for(int k = i + 1; k < n; k++) {
            double factor = A[k * rowSize + i] / A[i * rowSize + i];
            for(int j = i; j < n; j++) {
               A[k * rowSize + j] -= factor * A[i * rowSize + j];
            }
            A[k * rowSize + i] = factor; // Store L factor
         }
      }
      // Compute determinant as product of U's diagonal elements
      double result = 1.0;
      for(int i = 0; i < n; i++) {
         result *= A[i * rowSize + i];
      }
      // Adjust sign based on number of row swaps
      return (permutations % 2 == 0 ? 1 : -1) * result;
   }
   return EMPTY_VALUE;
}

// Custom tanh function in MQL4
double Stats::tanh(const double x) {
   if (x > 20.0) return 1.0;  // Asymptote for large positive x
   if (x < -20.0) return -1.0;  // Asymptote for large negative x
   return (2.0 / (1.0 + MathExp(-2.0 * x))) - 1.0;
}

// Custom sigmoid function in MQL4
double Stats::sigmoid(const double x) {
   if (x > 20.0) return 1.0;  // Asymptote for large positive x
   return (1.0 / (1.0 + MathExp(-1.0 * x)));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::swap(double &a, double &b) {
   double temp = a;
   a = b;
   b = temp;
}
// Simplified 4x4 determinant using LU (add to your script)
double Stats::det4(double &mat[][4]) {
   double A[4][4];
   for(int i = 0; i < 4; i++)
      for(int j = 0; j < 4; j++)
         A[i][j] = mat[i][j];
   int permutations = 0;
   for(int i = 0; i < 3; i++) {
      int pivotRow = i;
      double pivot = MathAbs(A[i][i]);
      for(int k = i + 1; k < 4; k++) {
         if(MathAbs(A[k][i]) > pivot) {
            pivot = MathAbs(A[k][i]);
            pivotRow = k;
         }
      }
      if(pivot < 1e-10) return 0.0;
      if(pivotRow != i) {
         for(int j = 0; j < 4; j++) swap(A[i][j], A[pivotRow][j]);
         permutations++;
      }
      for(int k = i + 1; k < 4; k++) {
         double factor = A[k][i] / A[i][i];
         for(int j = i; j < 4; j++) A[k][j] -= factor * A[i][j];
      }
   }
   double result = 1.0;
   for(int i = 0; i < 4; i++) result *= A[i][i];
   return (permutations % 2 == 0 ? 1 : -1) * result;
}

// Simplified determinant using LU decomposition
double Stats::detLU(const double &matrix[], const int rowSize) {
   if(rowSize > 7) return EMPTY_VALUE;
   if(ArraySize(matrix) != (rowSize * rowSize)) return EMPTY_VALUE; // Not 5x5
   if(ArraySize(matrix) < (rowSize * rowSize)) return EMPTY_VALUE;
   for(int i = 0; i < (rowSize * rowSize); i++) {
      if(!MathIsValidNumber(matrix[i])) return EMPTY_VALUE;  // NaN/INF
   }
// Copy matrix to avoid modifying input
   double A[];
   ArrayResize(A, (rowSize * rowSize));
//ArrayCopy(A, matrix);
   ArrayCopy(A, matrix, 0, 0, (rowSize * rowSize));
   string str = "";
   for(int i = 0; i < ArraySize(A); i++) {
      str += A[i] + " :: ";
   }
   Print("ARRSIZE: " + ArraySize(A) + " Vals: " + str);
//int n = 5;
   int n = rowSize;
//int rowSize = 5;  // For row-major indexing
   int permutations = 0;  // Track row swaps for sign
// LU decomposition with partial pivoting
   for(int i = 0; i < n - 1; i++) {
      // Find pivot
      int pivotRow = i;
      double pivot = MathAbs(A[i * rowSize + i]);
      for(int k = i + 1; k < n; k++) {
         double value = MathAbs(A[k * rowSize + i]);
         if(value > pivot) {
            pivot = value;
            pivotRow = k;
         }
      }
      // Singular matrix check
      if(pivot < 1e-10) return 0.0;
      // Swap rows if needed
      if(pivotRow != i) {
         for(int j = 0; j < n; j++) {
            double temp = A[i * rowSize + j];
            A[i * rowSize + j] = A[pivotRow * rowSize + j];
            A[pivotRow * rowSize + j] = temp;
         }
         permutations++;
      }
      // Eliminate below pivot
      for(int k = i + 1; k < n; k++) {
         double factor = A[k * rowSize + i] / A[i * rowSize + i];
         for(int j = i; j < n; j++) {
            A[k * rowSize + j] -= factor * A[i * rowSize + j];
         }
         // Note: Factor stored in L (below diagonal), but not needed for det
      }
   }
// Determinant = product of U's diagonal elements, adjusted by permutations
   double result = 1.0;
   for(int i = 0; i < n; i++) {
      result *= A[i * rowSize + i];
   }
   return (permutations % 2 == 0 ? 1 : -1) * result;
}


//+------------------------------------------------------------------+
//| Mean Detrending                                                  |
//+------------------------------------------------------------------+
void Stats::sigMeanDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21) {
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
   for(int i = 0; i < SIZE; i++) {
      outputSignal[i] = (outputSignal[i] != 0) ? (outputSignal[i] - meanVal) : 0.0; // Zero-mean in pips
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stats::sigLinearDeTrend(const double &inputSig[], double &outputSignal[], int SIZE = 21) {
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
   if(slope == EMPTY_VALUE || intercept == EMPTY_VALUE) return;
//  double pipVal = ut.getPipValue(_Symbol); // 0.01 for USDJPY
   for(int i = 0; i < SIZE; i++) {
      outputSignal[i] = (outputSignal[i] != 0) ? ((outputSignal[i] - (slope * i + intercept))) : 0.0;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RITYPE   Stats::dftFormula(const double timeSeriesVal, const int k, const int n, const int SIZE) {
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
void Stats::dftTransform(const double &inputSig[], double &magnitude[], double &phase[], double &power[], int SIZE = 8) {
   double detrended[];
   sigMeanDeTrend(inputSig, detrended, SIZE);
   int N = (int)MathPow(2, MathCeil(MathLog(SIZE) / MathLog(2)));
   double paddedSig[];
   ArrayResize(paddedSig, N);
   ArrayCopy(paddedSig, detrended, 0, 0, SIZE);
   for(int i = SIZE; i < N; i++) paddedSig[i] = 0.0;
//string inp = "";
//for(int i = 0; i < SIZE; i++) inp += " :" + DoubleToString(inputSig[i], 6);
//Print("[INPSIG]: " + inp);
   //string p = "";
   //for(int i = 0; i < N; i++) p += " :" + DoubleToString(paddedSig[i], 6);
   //Print("[DFT::PADDEDSIG]: " + p);
   ArrayResize(magnitude, N);
   ArrayResize(phase, N);
   ArrayResize(power, N);
   for(int k = 0; k < N; k++) {
      double real = 0.0;
      double imag = 0.0;
      for(int n = 0; n < N; n++) {
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
void Stats::hilbertTransform(const double &inputSig[], double &amplitude[], double &phase[], int SIZE = 8, int FILTER_LENGTH = 3) {
// Step 1: Detrend (returns pips)
   double detrended[];
   sigMeanDeTrend(inputSig, detrended, SIZE); // Outputs pips
   int N = (int)MathPow(2, MathCeil(MathLog(SIZE) / MathLog(2)));
   double paddedSig[];
   ArrayResize(paddedSig, N);
   ArrayCopy(paddedSig, detrended, 0, 0, SIZE);
   for(int i = SIZE; i < N; i++) paddedSig[i] = 0.0;
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
   for(int m = -M; m <= M; m++) {
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
   for(int n = M; n < N - M; n++) {
      double sum = 0.0;
      for(int m = -M; m <= M; m++) {
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
   for(int i = 0; i < N; i++) {
      if(i < M || i >= N - M) {
         amplitude[i] = 0.0;
         phase[i] = 0.0;
      } else {
         amplitude[i] = MathSqrt(paddedSig[i] * paddedSig[i] + hat_x[i] * hat_x[i]); // Pips, no normalization
         phase[i] = Arctan2(hat_x[i], paddedSig[i]);
      }
   }
}

//+------------------------------------------------------------------+
//| Max Value Template                                               |
//+------------------------------------------------------------------+
template<typename T>
T Stats::maxVal(const T v1, const T v2) {
   if(v1 > v2) return v1;
   if(v2 > v1) return v2;
   return v1; // If equal
}

//+------------------------------------------------------------------+
//| Extract Hilbert Amp and Phase                                    |
//+------------------------------------------------------------------+
DTYPE Stats::extractHilbertAmpNPhase(const double &hilbertAmp[], const double &hilbertPhase[], double cutOff) {
   DTYPE dt;
   int SIZE = ArraySize(hilbertAmp);
   dt.val1 = EMPTY; // Index
   dt.val2 = EMPTY_VALUE; // Amp
   dt.val3 = EMPTY_VALUE; // Phase
   for(int i = 0; i < SIZE; i++) {
      if(hilbertAmp[i] > cutOff) {
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
DTYPE Stats::extractDftPowerNPhase(const double &dftMag[], const double &dftPhase[], const double &dftPower[]) {
   DTYPE dt;
   int max_power_k = 1;
   double max_power = dftPower[1];
   int SIZE = ArraySize(dftMag) / 2; // k=1 to SIZE/2
   for(int k = 2; k <= (SIZE / 2); k++) { // Limit to 4 for stability
      if(dftPower[k] > max_power) {
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
double  Stats::dotProd(const double &series1[], const double &series2[], const int SIZE = 10, const int interval = 1, int SHIFT = 1) {
   double dp = EMPTY_VALUE;
   for (int i = SHIFT; i < SIZE; i = (i + interval)) {
      if(dp == EMPTY_VALUE)dp = 0;
      dp += series1[i] + series2[i];
   }
   return dp;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DTYPE Stats::getDecimalVal(const double num, const double denom) {
   DTYPE dt;
   if((int)num == (int)denom) {
      dt.val1 = (num - (int)num);
      dt.val2 = (denom - (int)denom);
   } else if((int)num < (int)denom) {
      dt.val1 = (num - (int)num);
      dt.val2 = (denom - (int)num);
   } else if((int)num > (int)denom) {
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

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
