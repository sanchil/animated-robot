//+------------------------------------------------------------------+
//|                                                     SanTypes.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
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

const double LARGE_VAL = 123456.654321;
//double TRADERATIO = 0.0;   // peak positive ratio

struct CandleCharacter {
   double            upperTail;
   double            lowerTail;
   bool              redCandle;
   bool              greenCandle;
   bool              noBodyTailCandle;
   bool              noBodyUpperTailCandle;
   bool              noBodyLowerTailCandle;
   bool              bodyUpperTailCandle;
   bool              bodyLowerTailCandle;
   bool              noBodyCandle;
   bool              fullBodyRedCandle;
   bool              fullBodyGreenCandle;
   bool              fullBodyCandle;
   double            body;
   double            candleRange;
   double            bodyRatio;
   bool              tailDominates;
   bool              bodyDominates;

   CandleCharacter() {
      upperTail = -1;
      lowerTail = -1;
      redCandle = -1;
      greenCandle =  -1;
      noBodyTailCandle =  -1;
      noBodyUpperTailCandle = -1;
      noBodyLowerTailCandle = -1;
      bodyUpperTailCandle = -1;
      bodyLowerTailCandle = -1;
      noBodyCandle =  -1 ;
      fullBodyRedCandle =  -1;
      fullBodyGreenCandle =  -1;
      fullBodyCandle =  -1;
      body =   -1;
      candleRange =   -1;
      bodyRatio =  -1;
      tailDominates =  -1;
      bodyDominates =  -1 ;
   }


   CandleCharacter(
      const double &open[],
      const double &high[],
      const double &low[],
      const double &close[],
      const double limit,
      const int shift = 1) {
      redCandle = (open[shift] > close[shift]);
      greenCandle = (open[shift] < close[shift]);
      noBodyCandle = ((open[shift] == close[shift]) && (low[shift] == high[shift])) ;
      noBodyTailCandle = ((open[shift] == close[shift]) && (low[shift] != high[shift]));
      if(!noBodyCandle && noBodyTailCandle && (fabs(open[shift] - low[shift]) > 0)) {
         noBodyUpperTailCandle = ((fabs(high[shift] - open[shift]) / fabs(open[shift] - low[shift])) > (1 - limit));
         noBodyLowerTailCandle = ((fabs(high[shift] - open[shift]) / fabs(open[shift] - low[shift])) <= limit) ;
      } else if(!noBodyCandle && noBodyTailCandle && (fabs(open[shift] - low[shift]) == 0)) {
         noBodyUpperTailCandle = ((fabs(high[shift] - open[shift])) > (1 - limit));
         noBodyLowerTailCandle = ((fabs(high[shift] - open[shift])) <= limit) ;
      }
      fullBodyRedCandle = (redCandle && (open[shift] == high[shift]) && (close[shift] == low[shift]));
      fullBodyGreenCandle = (greenCandle && (open[shift] == low[shift]) && (close[shift] == high[shift]));
      fullBodyCandle = (fullBodyRedCandle || fullBodyGreenCandle);
      body =  NormalizeDouble(fabs(open[shift] - close[shift]), _Digits);
      candleRange =  NormalizeDouble(fabs(high[shift] - low[shift]), _Digits);
      bodyRatio = (!noBodyTailCandle && !fullBodyCandle && !noBodyCandle && (body > 0) && (candleRange > 0)) ? NormalizeDouble((body / candleRange), 2) : NULL;
      tailDominates = (noBodyTailCandle || (bodyRatio <= limit));
      bodyDominates = (fullBodyCandle || (bodyRatio > limit)) ;
      if((redCandle || noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
         upperTail = (high[shift] - open[shift]);
         lowerTail = (close[shift] - low[shift]);
      } else if((greenCandle || noBodyTailCandle) && !fullBodyCandle && !noBodyCandle) {
         upperTail = (high[shift] - close[shift]);
         lowerTail = (open[shift] - low[shift]);
      }
      bodyUpperTailCandle = (tailDominates && (((upperTail == 0) && (lowerTail > 0)) || ((upperTail != 0) && (lowerTail != 0) && (NormalizeDouble((fabs(upperTail) / fabs(lowerTail)), 2) <= limit))));
      bodyLowerTailCandle = (tailDominates && (((lowerTail == 0) && (upperTail > 0)) || ((upperTail != 0) && (lowerTail != 0) && (NormalizeDouble((fabs(lowerTail) / fabs(upperTail)), 2) <= limit))));
   }
   ~CandleCharacter() {
      redCandle = NULL;
      greenCandle = NULL;
      noBodyTailCandle = NULL;
      noBodyCandle = NULL;
      fullBodyRedCandle = NULL;
      fullBodyGreenCandle = NULL;
      fullBodyCandle = NULL;
      body =  NULL;
      candleRange = NULL;
      bodyRatio = NULL;
      tailDominates = NULL;
      bodyDominates = NULL ;
   }

};


struct RITYPE {
   double            r;
   double            i;
   void initRITYPE() {
      r = EMPTY_VALUE;
      i = EMPTY_VALUE;
   }
   RITYPE() {
      initRITYPE();
   }
   ~RITYPE() {
      initRITYPE();
   }
};

struct SLOPETYPE {
   double            slope;
   double            intercept;
   void initSLOPETYPE() {
      slope = EMPTY_VALUE;
      intercept = EMPTY_VALUE;
   }
   SLOPETYPE() {
      initSLOPETYPE();
   }
   ~SLOPETYPE() {
      initSLOPETYPE();
   }
};

struct TRADEBOOLS {
   bool              openTradeBool;
   bool              closeTradeBool;

   bool              noTradeBool;
   bool              tradeBool;
   bool              flatMktBool;
   bool              flatBool;
   bool              closeFlatTradeBool;
   bool              closeSigTrReversalBool;
   bool              closeSigTrCloseSigReversalBool;
   bool              closeSlopeVarBool;
   bool              closeSlopeRatios;
   bool              closeOBVStdBool;
   bool              closeClusterStdBool;
   bool              closeRsiBool;
   bool              closeSigBool;
   bool              volTradeBool;
};

struct DTYPE {
   double            val1;
   double            val2;
   double            val3;
   double            val4;
   double            val5;
   void initDTYPE() {
      val1 = EMPTY_VALUE;
      val2 = EMPTY_VALUE;
      val3 = EMPTY_VALUE;
      val4 = EMPTY_VALUE;
      val5 = EMPTY_VALUE;
   }
   DTYPE() {
      initDTYPE();
   }
   ~DTYPE() {
      initDTYPE();
   }
};

struct D20TYPE {
   double            val[20];

   void              freeData() {
      ArrayFree(val);
   }
   D20TYPE() {
      ArrayInitialize(val, EMPTY_VALUE);
   }
   ~D20TYPE() {
      freeData();
   }
};



struct TRADELIMITS {
   int               spreadLimit;
   double            stdDevLimit;
   int               mfiLowerLimit;
   int               mfiUpperLimit;
   int               adxMainLimit;
   double            acfLimit;
   double            acfSpikeLimit;
   double            cpStdDevLowerLimit;
   double            cpStdDevUpperLimit;
   double            zScoreUpLimit;
   double            zScoreDownLimit;
   double            candlePipSpeedLimit;
   TRADELIMITS() {
      if(_Period < PERIOD_M15) {
         spreadLimit = 20;
         candlePipSpeedLimit = 30;
      } else if(_Period <= PERIOD_M30) {
         spreadLimit = 40;
         candlePipSpeedLimit = 30;
      } else if(_Period <= PERIOD_H1) {
         spreadLimit = 60;
         candlePipSpeedLimit = 30;
      } else if(_Period <= PERIOD_D1) {
         spreadLimit = 80;
         candlePipSpeedLimit = 30;
      }
      //     spreadLimit = 20;
      //      stdDevLimit = 0.3;
      stdDevLimit = 0.09;
      mfiLowerLimit = 20;
      mfiUpperLimit = 80;
      adxMainLimit = 20;
      // acfLimit = 0.5;
      acfLimit = 0.3;
      acfSpikeLimit = 0.4; // acf is low when the std for closing price spikes.
      //This limit ensures that acf does not go very low and trades are picked up at sufficiently high acf values which is safer.
      cpStdDevLowerLimit = 6.0;
      cpStdDevUpperLimit = 10.0;
      zScoreUpLimit = 1;
      zScoreDownLimit = -1;
   };
   ~TRADELIMITS() {};
};

const TRADELIMITS tl;


struct DataTransport {
   double            matrixD[20];
   double            matrixD1[20];
   double            matrixD2[20];
   int               matrixI[20];
   int               matrixI1[20];
   int               matrixI2[20];
   bool              matrixBool[20];
   DataTransport() {
      ArrayInitialize(matrixD, EMPTY_VALUE);
      ArrayInitialize(matrixD1, EMPTY_VALUE);
      ArrayInitialize(matrixD2, EMPTY_VALUE);
      ArrayInitialize(matrixI, EMPTY);
      ArrayInitialize(matrixI1, EMPTY);
      ArrayInitialize(matrixI2, EMPTY);
      ArrayInitialize(matrixBool, EMPTY);
   }
   void              freeData() {
      ArrayFree(matrixD);
      ArrayFree(matrixI);
      ArrayFree(matrixD1);
      ArrayFree(matrixI1);
      ArrayFree(matrixD2);
      ArrayFree(matrixI2);
      ArrayFree(matrixBool);
   }
   ~DataTransport() {
      freeData();
   }
};

enum SAN_SIGNAL {
   BUY = 1000,
   SELL = 2000,
   HOLD = 3000,
   OPEN = 4000,
   CLOSE = 5000,
   CLOSEBUY = 5001,
   CLOSESELL = 5002,
   TRADE = 6000,
   TRADEBUY = 6001,
   TRADESELL = 6002,
   NOTRADE = 7000,
   REVERSETRADE = 8000,
   SIDEWAYS = 9000,
   NOSIG = -1000314,
//NOSIG=EMPTY,
};

//enum SAN_SIGNAL
//  {
//   BUY=0,
//   SELL=1,
//   HOLD=2,
//   OPEN=3,
//   CLOSE=4,
//   TRADE=5,
//   NOTRADE=6,
//   REVERSETRADE=7,
//   SIDEWAYS=8,
//   NOSIG=-1000314,
//   //NOSIG=EMPTY,
//  };

//SAN_SIGNAL TRADEPOSITION = SAN_SIGNAL::NOSIG;

struct ORDERPARAMS {
   bool              NEWCANDLE;
   bool              TRADED;
   bool              OPENTRADE;
   bool              CLOSETRADE;
   int               TOTALORDERS;
   SAN_SIGNAL        TRADEPOSITION;
   double            TRADEPROFIT;
   double            MAXTRADEPROFIT;
   double            STOPLOSS;
   double            TAKEPROFIT;
   int               MICROLOTS;
   double            SAN_TRADE_VOL;
   int               SPREADFACTOR;
   double            SLTPFACTOR; // (stoploss/takeprofit)
   //  uint              TICKSTART;
   long              TICKCOUNT;
   double            CPINPIPS;
   double            MAXPIPS;


   bool              isNewBar() {
      static long opBars = Bars(_Symbol, PERIOD_CURRENT);
      if(opBars == Bars(_Symbol, PERIOD_CURRENT)) {
         return false;
      }
      opBars = Bars(_Symbol, PERIOD_CURRENT);
      return true;
   }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double              pipsPerTick(const double candleSizePips) {
      double tPoint = Point();
      double pipsPerTick = 0;
      static long TICKSTART = 0;
      //    Print(" Candle size in Pips: "+candleSizePips);
      //if((NEWCANDLE!=EMPTY) && NEWCANDLE)
      //  Print("Candle pip size: "+candleSizePips+" TICKSTART: "+TICKSTART);
      if(isNewBar()) {
         TICKSTART = GetTickCount();
         TICKCOUNT = 1;
         return 0;
      } else if((TICKSTART > 0)) {
         TICKCOUNT = (GetTickCount() - TICKSTART);
         // Print("OLD Candle: TICKSTART: "+TICKSTART+" tickCount: "+TICKCOUNT+" candleSizePips: "+candleSizePips);
         // if((candleSizePips!=0)&&((TICKCOUNT/TICKSTART)<0.5))
         if((TICKCOUNT > 0) && ((TICKCOUNT / TICKSTART) < 0.5)) {
            pipsPerTick = (candleSizePips / (TICKCOUNT * tPoint));
            return pipsPerTick;
         }
      }
      return pipsPerTick;
   };




   ORDERPARAMS() {
      NEWCANDLE = false;
      //TICKSTART =  GetTickCount();
      TICKCOUNT = 0;
      CPINPIPS = 0;
      MAXPIPS = 0;
      SPREADFACTOR = 1;
      //      SLTPFACTOR = 0.75; // (stoploss/takeprofit)
      SLTPFACTOR = 0.525; // (stoploss/takeprofit)
      MICROLOTS = 1;
      SAN_TRADE_VOL = (MICROLOTS * 0.01);
      TOTALORDERS = OrdersTotal();
      TRADEPOSITION = SAN_SIGNAL::NOSIG;
      TRADEPROFIT = EMPTY_VALUE;
      MAXTRADEPROFIT = EMPTY_VALUE;
      //      ADJUSTED_MAXTRADEPROFIT = MAXTRADEPROFIT-((currspread+1)*tPoint);
   };
   ~ORDERPARAMS() {
      NEWCANDLE = EMPTY;
      //TICKSTART = EMPTY;
      TICKCOUNT = EMPTY;
      CPINPIPS = EMPTY_VALUE;
      MAXPIPS = EMPTY_VALUE;
      MICROLOTS = EMPTY;
      SAN_TRADE_VOL = EMPTY_VALUE;
      SPREADFACTOR = EMPTY;
      SLTPFACTOR = EMPTY_VALUE;
      TRADED = EMPTY;
      OPENTRADE = EMPTY;
      CLOSETRADE = EMPTY;
      TOTALORDERS = -1;
      TRADEPOSITION = SAN_SIGNAL::NOSIG;
      TRADEPROFIT = 0;
      MAXTRADEPROFIT = 0;
      STOPLOSS = 0;
      TAKEPROFIT = 0;
      //      ADJUSTED_MAXTRADEPROFIT = NULL;
   };

   double            getProfit(double defaultTP, double minLot = EMPTY, double tP = EMPTY_VALUE) {
      return ((tP != EMPTY_VALUE) && (minLot != EMPTY)) ? (tP * minLot) : (((tP != EMPTY_VALUE) && (minLot == EMPTY)) ? (tP * MICROLOTS) : (defaultTP * MICROLOTS));
   }

   double            getStopLoss(double tP = EMPTY_VALUE, double sL = EMPTY_VALUE, double slFactor = 0.6) {
      return ((sL != EMPTY_VALUE) ? sL : ((tP != EMPTY_VALUE) ? (tP * slFactor) : (TAKEPROFIT * slFactor)));
   }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              initTrade(double minLot = 1, double tP = EMPTY_VALUE, double sL = EMPTY_VALUE) {

      TOTALORDERS = OrdersTotal();

      MICROLOTS = minLot;
      SAN_TRADE_VOL = (MICROLOTS * 0.01);

      //      TAKEPROFIT= ((tP!=EMPTY_VALUE)&&(mL!=EMPTY))?(tP*mL):(((tP!=EMPTY_VALUE)&&(mL==EMPTY))?(tP*MICROLOTS):(0.1*MICROLOTS));
      TAKEPROFIT = getProfit(0.1, minLot, tP);
      if(_Period == PERIOD_M1) {
         //TAKEPROFIT= 7*MICROLOTS;
         // TAKEPROFIT= 3*MICROLOTS;
         // TAKEPROFIT= 2.5*MICROLOTS;
         // TAKEPROFIT= 2*MICROLOTS;
         // TAKEPROFIT= 1.2*MICROLOTS;
         TAKEPROFIT = getProfit(0.6, minLot, (tP * 1));
         // TAKEPROFIT= 0.30*MICROLOTS;
      }
      if(_Period == PERIOD_M5) {
         TAKEPROFIT = getProfit(1, minLot, (tP * 5));
      } else if(_Period == PERIOD_M15) {
         TAKEPROFIT = getProfit(2, minLot, (tP * 10));
      } else if(_Period == PERIOD_M30) {
         TAKEPROFIT = getProfit(3, minLot, (tP * 20));
      } else if(_Period == PERIOD_H1) {
         TAKEPROFIT = getProfit(4, minLot, (tP * 30));
      } else if(_Period == PERIOD_H4) {
         TAKEPROFIT = getProfit(5, minLot, (tP * 60));
      } else if(_Period == PERIOD_D1) {
         TAKEPROFIT = getProfit(6, minLot, (tP * 250));
      }
      STOPLOSS = getStopLoss(tP, sL, 2);
      if(TOTALORDERS == 0) {
         TOTALORDERS = 0;
         TRADEPOSITION = SAN_SIGNAL::NOSIG;
         TRADEPROFIT = 0;
         MAXTRADEPROFIT = 0;
      }
      if(TOTALORDERS > 0) {
         for(int i = 0; i < TOTALORDERS; i++) {
            if(OrderSelect(i, SELECT_BY_POS)) {
               TRADEPROFIT = OrderProfit();
               if((!MAXTRADEPROFIT) || (MAXTRADEPROFIT == NULL) || (MAXTRADEPROFIT == 0) || (MAXTRADEPROFIT == EMPTY_VALUE) || (MAXTRADEPROFIT == EMPTY)) {
                  MAXTRADEPROFIT = TRADEPROFIT;
               }
               if(((MAXTRADEPROFIT != NULL) && (MAXTRADEPROFIT != 0) && (MAXTRADEPROFIT != EMPTY_VALUE) && (MAXTRADEPROFIT != EMPTY)) && (TRADEPROFIT > MAXTRADEPROFIT)) {
                  MAXTRADEPROFIT = TRADEPROFIT;
               }
               if(OrderType() == OP_BUY) {
                  TRADEPOSITION = SAN_SIGNAL::BUY;
               }
               if(OrderType() == OP_SELL) {
                  TRADEPOSITION = SAN_SIGNAL::SELL;
               }
               if((OrderType() != OP_SELL) && (OrderType() != OP_BUY) && (OrderType() != OP_SELLLIMIT) && (OrderType() != OP_BUYLIMIT) && (OrderType() != OP_SELLSTOP) && (OrderType() != OP_BUYSTOP)) {
                  TRADEPOSITION = SAN_SIGNAL::NOSIG;
               }
            }
         }
      }
   };
};


enum SANTREND {
   UP = 90,
   DOWN = 100,
   FLAT = 110,
   TREND = 120,
   CONVUP = 130,
   CONVDOWN = 140,
   CONVFLAT = 150,
   DIVUP = 160,
   DIVDOWN = 170,
   DIVFLAT = 180,
   FLATUP = 190,
   FLATDOWN = 200,
   FLATFLAT = 210,
   NOTREND = -1000315
};

enum SANTRENDSTRENGTH {
   WEAK = 220,
   NORMAL = 230,
   HIGH = 240,
   SUPERHIGH = 250,
   POOR = -1000316
};


enum STRATEGYTYPE {
   STDMFIADX = 260,
   PA = 270,
   IMACLOSE = 280,
   FARMPROFITS = 290,
   CLOSEPOSITIONS = 300,
   NOSTRATEGY = -1000317
};

enum CROSSOVER {
   ABOVE = 400,
   BELOW = 410,
   BELOWTOABOVE = 420,
   ABOVETOBELOW = 430,
   MULTIPLE = 440,
   NOCROSS = -1000319
};


enum SIGMAVARIABILITY {
//   SIGMA_MEAN=310,
//
   SIGMA_HALF = 320,
   SIGMA_1 = 330,
   SIGMA_16 = 340,
   SIGMA_2 = 350,
   SIGMA_3 = 360,
   SIGMA_35 = 365,
   SIGMA_4 = 370,
   SIGMA_REST = 380,

   SIGMANEG_REST = 500,
   SIGMANEG_4 = 520,
   SIGMANEG_35 = 540,
   SIGMANEG_3 = 560,
   SIGMANEG_2 = 580,
   SIGMANEG_16 = 600,
   SIGMANEG_1 = 620,
   SIGMANEG_HALF = 640,
   SIGMANEG_MEAN = 660,
   SIGMA_MEAN = 700,
   SIGMAPOS_MEAN = 720,
   SIGMAPOS_HALF = 740,
   SIGMAPOS_1 = 760,
   SIGMAPOS_16 = 780,
   SIGMAPOS_2 = 800,
   SIGMAPOS_3 = 820,
   SIGMAPOS_35 = 840,
   SIGMAPOS_4 = 860,
   SIGMAPOS_REST = 880,

   SIGMA_NULL = -1000318
};


enum MKTTYP {
   MKTFLAT = 900,
   MKTTR = 920,
   MKTUP = 930,
   MKTDOWN = 940,
   MKTCLOSE = 950,
   NOMKT = -1000320
};

enum TRADE_STRATEGIES {
   FASTSIG = 11000,
   SIMPLESIG = 11100,
   SLOPESIG = 11200,
   SLOPERATIOSIG = 11300,
   SLOPESTD_CSIG = 11400,
   CPSLOPECANDLE120 = 11500,
   SLOPECANDLE120 = 11600,
   HTDFT = 11700,
   FASTSLOW = 11800,
   SLOPE = 11900,
   NOTRDSTGY = -10000340
};



struct TRENDSTRUCT {
   SANTREND          closeTrendSIG;
   SANTRENDSTRENGTH  trendStrengthSIG;
   TRENDSTRUCT() {
      closeTrendSIG = SANTREND::NOTREND;
      trendStrengthSIG = SANTRENDSTRENGTH::POOR;
   }
   ~TRENDSTRUCT() {}
};

struct TRADESSWITCH {
   SAN_SIGNAL        trade;
   SAN_SIGNAL        tradeSIG;
   TRADESSWITCH() {
      trade = SAN_SIGNAL::NOSIG;
      tradeSIG = SAN_SIGNAL::NOSIG;
   }
   ~TRADESSWITCH() {}
};

TRADESSWITCH tsw;

struct INDDATA {
   double            open[500];
   double            high[70];
   double            low[70];
   double            close[500];
   datetime          time[70];
   double            tick_volume[500];
   //   double            volume[70];
   double            std[70];
   double            stdOpen[70];
   //   double            mfi[70];
   double            obv[70];
   double            rsi[70];
   double            atr[70];
   //   double            adx[70];
   //   double            adxPlus[70];
   //   double            adxMinus[70];
   double            ima5[70];
   double            ima14[70];
   double            ima30[70];
   double            ima60[70];
   double            ima120[500];
   double            ima240[500];
   double            ima500[500];
   ulong             magicnumber;
   double            closeProfit; // Profit at which a trade is condsidered for closing. Also the same as take profit
   double            stopLoss; // Stop Loss
   double            currProfit; // The profit of the currently held trade
   double            maxProfit; // The current profit is adjusted by subtracting the spread and a margin added.
   int               tradePosition;
   int               currSpread;
   int               shift;
   double            microLots;


   void              freeData() {
      ArrayFree(open);
      ArrayFree(high);
      ArrayFree(low);
      ArrayFree(close);
      ArrayFree(time);
      ArrayFree(tick_volume);
      //      ArrayFree(volume);
      ArrayFree(std);
      ArrayFree(stdOpen);
      //     ArrayFree(mfi);
      ArrayFree(obv);
      ArrayFree(atr);
      //      ArrayFree(adx);
      //     ArrayFree(adxPlus);
      //     ArrayFree(adxMinus);
      ArrayFree(ima5);
      ArrayFree(ima14);
      ArrayFree(ima30);
      ArrayFree(ima60);
      ArrayFree(ima120);
      ArrayFree(ima240);
      ArrayFree(ima500);
      magicnumber = NULL;
      closeProfit = NULL;
      stopLoss = NULL;
      currProfit = NULL;
      maxProfit = NULL;
      shift = NULL;
      currSpread = EMPTY;
      tradePosition = EMPTY;
      double microLots = -1;
   }
   INDDATA() {}
   ~INDDATA() {
      freeData();
   }
};

struct SIGBUFF {
   double            buff1[5];
   double            buff2[5];
   double            buff3[5];
   double            buff4[5];
   double            buff5[5];
   double            buff6[5];
   SIGBUFF() {
      ArrayInitialize(buff1, EMPTY_VALUE);
      ArrayInitialize(buff2, EMPTY_VALUE);
      ArrayInitialize(buff3, EMPTY_VALUE);
      ArrayInitialize(buff4, EMPTY_VALUE);
      ArrayInitialize(buff5, EMPTY_VALUE);
      ArrayInitialize(buff6, EMPTY_VALUE);
   }
   ~SIGBUFF() {
      ArrayFree(buff1);
      ArrayFree(buff2);
      ArrayFree(buff3);
      ArrayFree(buff4);
      ArrayFree(buff5);
      ArrayFree(buff6);
   }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SANSIGNALS {
 public:
   SAN_SIGNAL        openSIG;
   SAN_SIGNAL        closeSIG;
   SAN_SIGNAL        priceActionSIG;
   SAN_SIGNAL        adxSIG;
   SAN_SIGNAL        atrSIG;
   SAN_SIGNAL        obvCPSIG;
   SAN_SIGNAL        mfiSIG;
   SAN_SIGNAL        rsiSIG;
   SAN_SIGNAL        adxCovDivSIG;
   SAN_SIGNAL        fastIma514SIG;
   SAN_SIGNAL        fastIma1430SIG;
   SAN_SIGNAL        fastIma30120SIG;
   SAN_SIGNAL        fastIma120240SIG;
   SAN_SIGNAL        fastIma240500SIG;
   SAN_SIGNAL        fastIma530SIG;
   SAN_SIGNAL        ima514SIG;
   SAN_SIGNAL        ima1430SIG;
   SAN_SIGNAL        ima30120SIG;
   SAN_SIGNAL        ima30240SIG;
   SAN_SIGNAL        ima120240SIG;
   SAN_SIGNAL        ima120500SIG;
   SAN_SIGNAL        ima240500SIG;
   SAN_SIGNAL        ima530SIG;
   SAN_SIGNAL        ima530_21SIG;
   SAN_SIGNAL        volSIG;
   SAN_SIGNAL        volSlopeSIG;
   SAN_SIGNAL        profitSIG;
   SAN_SIGNAL        profitPercentageSIG;
   SAN_SIGNAL        tradeSIG;
   SAN_SIGNAL        tradeVolVarSIG;
   SAN_SIGNAL        lossSIG;
   SANTREND          acfTrendSIG;
   SANTRENDSTRENGTH  acfStrengthSIG;
   SANTREND          trendRatioSIG;
   SANTREND          trendRatio5SIG;
   SANTREND          trendRatio14SIG;
   SANTREND          trendRatio30SIG;
   SANTREND          trendRatio120SIG;
   SANTREND          trendRatio240SIG;
   SANTREND          trendRatio500SIG;
   SANTREND          trendVolRatioSIG;
   SAN_SIGNAL        trendSumSig;
   SANTRENDSTRENGTH  trendVolRatioStrengthSIG;
   SAN_SIGNAL        slopeVarSIG;
   SANTREND          trendSlopeSIG;
   SANTREND          trendSlope5SIG;
   SANTREND          trendSlope14SIG;
   SANTREND          trendSlope30SIG;
   SANTREND          cpScatterSIG;
   SANTREND          cpScatter21SIG;
   SANTREND          trendScatterSIG;
   SANTREND          trendScatter5SIG;
   SANTREND          trendScatter14SIG;
   SANTREND          trendScatter30SIG;
   SAN_SIGNAL        fsig5;
   SAN_SIGNAL        fsig14;
   SAN_SIGNAL        fsig30;
   SAN_SIGNAL        fsig60;
   SAN_SIGNAL        fsig120;
   SAN_SIGNAL        fsig240;
   SAN_SIGNAL        fsig500;
   SAN_SIGNAL        sig5;
   SAN_SIGNAL        sig14;
   SAN_SIGNAL        sig30;
   SAN_SIGNAL        sig120;
   SAN_SIGNAL        sig240;
   SAN_SIGNAL        sig500;
   SAN_SIGNAL        candleImaSIG;
   SAN_SIGNAL        candleVolSIG;
   SAN_SIGNAL        candleVol120SIG;
   SAN_SIGNAL        candleVol120SIG_V2;
   SAN_SIGNAL        simpleSlope_14_SIG;
   SAN_SIGNAL        simpleSlope_30_SIG;
   SAN_SIGNAL        simpleSlope_120_SIG;
   SAN_SIGNAL        simpleSlope_240_SIG;
   SAN_SIGNAL        simpleSlope_500_SIG;
   SAN_SIGNAL        c_SIG;
   SAN_SIGNAL        tradeSlopeSIG;
   SAN_SIGNAL        volatilitySIG;
   SIGMAVARIABILITY        cpSDSIG;
   SIGMAVARIABILITY        ima5SDSIG;
   SIGMAVARIABILITY        ima14SDSIG;
   SIGMAVARIABILITY        ima30SDSIG;
   SIGMAVARIABILITY        ima120SDSIG;
   SIGMAVARIABILITY        ima240SDSIG;
   SIGMAVARIABILITY        ima500SDSIG;
   SAN_SIGNAL        candlePattStarSIG;
   D20TYPE      hilbertDftSIG;
   DTYPE        hilbertSIG;
   DTYPE        dftSIG;
   DataTransport     clusterData;
   DataTransport     slopeRatioData;
   DataTransport     varDt;

   //  DataTransport     imaSlopesData;
   DTYPE     atrVolData;
   DTYPE     candleVolData;
   DTYPE     imaSlope5Data;
   DTYPE     imaSlope14Data;
   DTYPE     imaSlope30Data;
   DTYPE     imaSlope120Data;
   DTYPE     baseSlopeData;
   DTYPE     imaSlope500Data;
   DTYPE     stdCPSlope;
   DTYPE     stdOPSlope;
   DTYPE     obvCPSlope;
   double            hilbertAmp[];
   double            hilbertPhase[];
   double            dftMag[];
   double            dftPhase[];
   double            dftPower[];

   SANSIGNALS();
   ~SANSIGNALS();
   void              initBase();

};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANSIGNALS::SANSIGNALS() {
   initBase();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SANSIGNALS::~SANSIGNALS() {
   hilbertDftSIG.freeData();
   dftSIG.initDTYPE();
   hilbertSIG.initDTYPE();
   clusterData.freeData();
//      imaSlopesData.freeData();
   varDt.freeData();
   slopeRatioData.freeData();
   atrVolData.initDTYPE();
   candleVolData.initDTYPE();
   baseSlopeData.initDTYPE();
   imaSlope5Data.initDTYPE();
   imaSlope14Data.initDTYPE();
   imaSlope30Data.initDTYPE();
   imaSlope120Data.initDTYPE();
   imaSlope500Data.initDTYPE();
   stdCPSlope.initDTYPE();
   stdOPSlope.initDTYPE();
   obvCPSlope.initDTYPE();
   ArrayFree(hilbertAmp);
   ArrayFree(hilbertPhase);
   ArrayFree(dftMag);
   ArrayFree(dftPhase);
   ArrayFree(dftPower);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SANSIGNALS::initBase() {
   openSIG = SAN_SIGNAL::NOSIG;
   closeSIG = SAN_SIGNAL::NOSIG;
   priceActionSIG = SAN_SIGNAL::NOSIG;
   candlePattStarSIG = SAN_SIGNAL::NOSIG;
   adxSIG = SAN_SIGNAL::NOSIG;
   atrSIG = SAN_SIGNAL::NOSIG;
   obvCPSIG = SAN_SIGNAL::NOSIG;
   mfiSIG = SAN_SIGNAL::NOSIG;
   rsiSIG = SAN_SIGNAL::NOSIG;
   adxCovDivSIG = SAN_SIGNAL::NOSIG;
   fastIma514SIG = SAN_SIGNAL::NOSIG;
   fastIma1430SIG = SAN_SIGNAL::NOSIG;
   fastIma530SIG = SAN_SIGNAL::NOSIG;
   fastIma30120SIG = SAN_SIGNAL::NOSIG;
   fastIma120240SIG = SAN_SIGNAL::NOSIG;
   fastIma240500SIG = SAN_SIGNAL::NOSIG;
   ima514SIG = SAN_SIGNAL::NOSIG;
   ima1430SIG = SAN_SIGNAL::NOSIG;
   ima530SIG = SAN_SIGNAL::NOSIG;
   ima530_21SIG = SAN_SIGNAL::NOSIG;
   ima30120SIG = SAN_SIGNAL::NOSIG;
   ima30240SIG = SAN_SIGNAL::NOSIG;
   ima120240SIG = SAN_SIGNAL::NOSIG;
   ima120500SIG = SAN_SIGNAL::NOSIG;
   ima240500SIG = SAN_SIGNAL::NOSIG;
//  atrSIG = SANTRENDSTRENGTH::POOR;
   volSIG = SAN_SIGNAL::NOSIG;
   volSlopeSIG = SAN_SIGNAL::NOSIG;
   profitSIG = SAN_SIGNAL::NOSIG;
   profitPercentageSIG = SAN_SIGNAL::NOSIG;
   tradeSIG = SAN_SIGNAL::NOSIG;
   tradeVolVarSIG = SAN_SIGNAL::NOSIG;
   lossSIG = SAN_SIGNAL::NOSIG;
   acfTrendSIG = SANTREND::NOTREND;
   acfStrengthSIG = SANTRENDSTRENGTH::POOR;
   trendRatio5SIG = SANTREND::NOTREND;
   trendRatio14SIG = SANTREND::NOTREND;
   trendRatio30SIG = SANTREND::NOTREND;
   trendRatio120SIG = SANTREND::NOTREND;
   trendRatio240SIG = SANTREND::NOTREND;
   trendRatio500SIG = SANTREND::NOTREND;
   trendRatioSIG = SANTREND::NOTREND;
   trendVolRatioSIG =  SANTREND::NOTREND;
   trendSumSig = SAN_SIGNAL::NOSIG;
   trendVolRatioStrengthSIG = SANTRENDSTRENGTH::POOR;
   slopeVarSIG = SAN_SIGNAL::NOSIG;
   trendSlopeSIG = SANTREND::NOTREND;
   trendSlope5SIG = SANTREND::NOTREND;
   trendSlope14SIG = SANTREND::NOTREND;
   trendSlope30SIG = SANTREND::NOTREND;
   cpScatterSIG = SANTREND::NOTREND;
   cpScatter21SIG = SANTREND::NOTREND;
   trendScatterSIG = SANTREND::NOTREND;
   trendScatter5SIG = SANTREND::NOTREND;
   trendScatter14SIG = SANTREND::NOTREND;
   trendScatter30SIG = SANTREND::NOTREND;
   fsig5 = SAN_SIGNAL::NOSIG;
   fsig14 = SAN_SIGNAL::NOSIG;
   fsig30 = SAN_SIGNAL::NOSIG;
   fsig60 = SAN_SIGNAL::NOSIG;
   fsig120 = SAN_SIGNAL::NOSIG;
   fsig240 = SAN_SIGNAL::NOSIG;
   fsig500 = SAN_SIGNAL::NOSIG;
   sig5 = SAN_SIGNAL::NOSIG;
   sig14 = SAN_SIGNAL::NOSIG;
   sig30 = SAN_SIGNAL::NOSIG;
   sig120 = SAN_SIGNAL::NOSIG;
   sig240 = SAN_SIGNAL::NOSIG;
   sig500 = SAN_SIGNAL::NOSIG;
   candleImaSIG = SAN_SIGNAL::NOSIG;
   candleVolSIG = SAN_SIGNAL::NOSIG;
   candleVol120SIG = SAN_SIGNAL::NOSIG;
   candleVol120SIG_V2 = SAN_SIGNAL::NOSIG;
   simpleSlope_14_SIG =  SAN_SIGNAL::NOSIG;
   simpleSlope_30_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_120_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_240_SIG = SAN_SIGNAL::NOSIG;
   simpleSlope_500_SIG =  SAN_SIGNAL::NOSIG;
   c_SIG =  SAN_SIGNAL::NOSIG;
   tradeSlopeSIG =  SAN_SIGNAL::NOSIG;
   volatilitySIG =  SAN_SIGNAL::NOSIG;
//   hilbertDftSIG =  SAN_SIGNAL::NOSIG;
   cpSDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima5SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima14SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima30SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima120SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima240SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
   ima500SDSIG = SIGMAVARIABILITY::SIGMA_NULL;
//clusterSIG = EMPTY_VALUE;
}

struct SANSIGBOOL {
   bool              spreadBool;
   bool              fimaWaveBool;
   bool              imaWaveBool;
   bool              imaWaveBool1;
   bool              sigBool;
   bool              sigBool1;
   bool              fsigBool;
   bool              signal514Bool;
   bool              signal1430Bool;
   bool              signal5Wave530Bool;
   bool              signal5Wave1430Bool;
   bool              signal5Wave14Bool;
   bool              signal14Wave1430Bool;
   bool              safeSig1Bool;
   bool              safeSig2Bool;
   bool              safeSig3Bool;
   bool              safeSig4Bool;
   bool              safeSig5Bool;
   bool              adxBool;
   bool              adxIma1430Bool;
   bool              atrAdxBool;
   bool              atrAdxVolOpenBool;
   bool              openTradeBool;
   bool              healthyTrendBool;
   bool              healthyTrendStrengthBool;
   bool              flatTrendBool;
   bool              openVolTrendBool;
   bool              closeVolTrendBool;
   bool              imaSig1Bool;
   //bool              cpSDBool;
   //bool              ima5SDBool;
   //bool              ima14SDBool;
   //bool              ima30SDBool;
   //bool              ima120SDBool;
   //bool              imaSDTradeBool;
   //bool              imaSDNoTradeBool;
   //bool              imaSDTradeTradeBool;
   //bool              imaSDNoNoTradeBool;
   bool              starBool;
   bool              candlePipAlarm;


   SANSIGBOOL() {
      spreadBool = false;
      imaWaveBool = false;
      imaWaveBool1 = false;
      fimaWaveBool = false;
      sigBool = false;
      sigBool1 = false;
      fsigBool = false;
      signal514Bool = false;
      signal1430Bool = false;
      signal5Wave530Bool = false;
      signal5Wave1430Bool = false;
      signal5Wave14Bool = false;
      signal14Wave1430Bool = false;
      safeSig1Bool = false;
      safeSig2Bool = false;
      safeSig3Bool = false;
      safeSig4Bool = false;
      safeSig5Bool = false;
      adxBool = false;
      adxIma1430Bool = false;
      atrAdxBool = false;
      atrAdxVolOpenBool = false;
      imaSig1Bool = false;
      openTradeBool = false;
      healthyTrendBool = false;
      healthyTrendStrengthBool = false;
      flatTrendBool = false;
      openVolTrendBool = false;
      closeVolTrendBool = false;
      //cpSDBool = false;
      //ima5SDBool = false;
      //ima14SDBool = false;
      //ima30SDBool = false;
      //ima120SDBool = false;
      //imaSDTradeBool = false;
      //imaSDTradeTradeBool = false;
      //imaSDNoTradeBool = false;
      //imaSDNoNoTradeBool = false;
      //starBool = false;
      candlePipAlarm = false;
   }
   SANSIGBOOL(const SANSIGNALS &ss) {
      //spreadBool = (currspread < tl.spreadLimit);
      //      imaWaveBool = ((ss.ima514SIG==ss.ima1430SIG)||(ss.ima530SIG==ss.ima1430SIG)||(ss.ima530SIG==ss.ima514SIG));
      imaWaveBool = ((ss.ima514SIG == ss.ima1430SIG) && (ss.ima1430SIG == ss.ima530_21SIG));
      fimaWaveBool = ((ss.fastIma514SIG == ss.fastIma1430SIG) || (ss.fastIma530SIG == ss.fastIma1430SIG));
      imaWaveBool1 = ((ss.fastIma514SIG == ss.ima514SIG) && ((ss.fastIma1430SIG == ss.ima1430SIG) || (ss.fastIma530SIG == ss.ima530SIG)));
      signal514Bool = (ss.sig5 == ss.sig14);
      signal1430Bool = (ss.sig14 == ss.sig30);
      signal5Wave1430Bool = (ss.sig5 == ss.ima1430SIG);
      signal5Wave530Bool = (ss.sig5 == ss.ima530SIG);
      signal5Wave14Bool = (ss.sig5 == ss.ima514SIG);
      //sigBool = ((signal514Bool && signal1430Bool)||(signal514Bool && (ss.sig5==ss.sig30))) ;
      //fsigBool = ((ss.fsig5==ss.fsig14)&&(ss.fsig14==ss.fsig30));
      sigBool = (signal514Bool && signal1430Bool);
      fsigBool = ((ss.fsig5 == ss.fsig14) && (ss.fsig14 == ss.fsig30));
      sigBool1 = ((ss.fsig5 == ss.sig5) && (ss.fsig14 == ss.sig14) && (ss.fsig30 == ss.sig30));
      signal14Wave1430Bool = (ss.sig14 == ss.ima1430SIG);
      safeSig1Bool = (imaWaveBool && signal5Wave14Bool && (ss.sig5 == ss.ima514SIG));
      safeSig2Bool = (signal14Wave1430Bool);
      safeSig3Bool = (signal5Wave530Bool);
      safeSig4Bool = (sigBool && fsigBool && imaWaveBool && fimaWaveBool && (ss.fsig5 == ss.fastIma514SIG) && (ss.sig5 == ss.ima514SIG) && (ss.fsig5 == ss.sig5) && (ss.fastIma514SIG == ss.ima514SIG));
      adxBool = ((ss.adxSIG == SAN_SIGNAL::BUY) || (ss.adxSIG == SAN_SIGNAL::SELL));
      adxIma1430Bool = (ss.adxSIG == ss.ima1430SIG);
      atrAdxBool = ((ss.atrSIG == SAN_SIGNAL::TRADE) && adxBool);
      atrAdxVolOpenBool = ((ss.volSIG == SAN_SIGNAL::TRADE) && atrAdxBool);
      imaSig1Bool = (spreadBool && safeSig1Bool);
      openTradeBool = (ss.tradeSIG == SAN_SIGNAL::TRADE);
      healthyTrendBool = (((ss.acfTrendSIG != SANTREND::NOTREND) && (ss.acfTrendSIG != SANTREND::FLAT)) || ((ss.trendSlopeSIG != SANTREND::NOTREND) && (ss.trendSlopeSIG != SANTREND::FLAT)));
      healthyTrendStrengthBool = ((ss.acfStrengthSIG != SANTRENDSTRENGTH::WEAK) && (ss.acfStrengthSIG != SANTRENDSTRENGTH::POOR));
      flatTrendBool = ((ss.trendSlopeSIG == SANTREND::FLAT) || ((ss.acfTrendSIG == SANTREND::FLAT) && ((ss.acfStrengthSIG == SANTRENDSTRENGTH::NORMAL) || (ss.acfStrengthSIG == SANTRENDSTRENGTH::HIGH) || (ss.acfStrengthSIG == SANTRENDSTRENGTH::SUPERHIGH))));
      openVolTrendBool = ((ss.volSIG == SAN_SIGNAL::TRADE) && healthyTrendBool && healthyTrendStrengthBool && !flatTrendBool);
      closeVolTrendBool = ((ss.volSIG == SAN_SIGNAL::REVERSETRADE) && !healthyTrendBool && !healthyTrendStrengthBool && flatTrendBool);
      //      cpSDBool = ((ss.cpSDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.cpSDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima5SDBool = ((ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima5SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima14SDBool = ((ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima14SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima30SDBool = ((ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima30SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      ima120SDBool = ((ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMA_NULL)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMA_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMANEG_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMAPOS_MEAN)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMANEG_HALF)&&(ss.ima120SDSIG!=SIGMAVARIABILITY::SIGMAPOS_HALF));
      //      //ima5SDBool = (ss.ima5SDSIG==SIGMAVARIABILITY::TRADE);
      //      //ima14SDBool = (ss.ima14SDSIG==SIGMAVARIABILITY::TRADE);
      //      //ima30SDBool = (ss.ima30SDSIG==SIGMAVARIABILITY::TRADE);
      //
      //      imaSDTradeBool = (ima14SDBool && ima30SDBool);
      //      imaSDNoTradeBool = (!ima14SDBool && !ima30SDBool);
      //      imaSDTradeTradeBool = (ima5SDBool && ima14SDBool && ima30SDBool);
      //      imaSDNoNoTradeBool = (!ima5SDBool && !ima14SDBool && !ima30SDBool);
      starBool = ((ss.candlePattStarSIG == SAN_SIGNAL::BUY) || (ss.candlePattStarSIG == SAN_SIGNAL::SELL));
   }
   ~SANSIGBOOL() {}
   void              printStruct() {
      //      Print("cpSDBool: "+cpSDBool+" ima5SDBool: "+ ima5SDBool+" ima14SDBool: "+ ima14SDBool+" ima30DBool: "+ ima30SDBool +" imaSDNoTradeBool: "+imaSDNoTradeBool+" closeVolTrendBool: "+closeVolTrendBool+" openVolTrendBool:"+openVolTrendBool);
      Print("closeVolTrendBool: " + closeVolTrendBool + " openVolTrendBool:" + openVolTrendBool);
      Print("adxBool: " + adxBool + " adxIma1430Bool: " + adxIma1430Bool + " atrAdxBool: " + atrAdxBool + " openTradeBool: " + openTradeBool + " healthyTrendBool:" + healthyTrendBool + " healthyTrendStrengthBool: " + healthyTrendStrengthBool + " atrAdxVolOpenBool: " + atrAdxVolOpenBool + " starBool: " + starBool);
      Print("SpreadBool: " + spreadBool + " imaWaveBool: " + imaWaveBool + " signal514Bool: " + signal514Bool + " signal1430Bool: " + signal1430Bool + " signal5Wave14Bool: " + signal5Wave14Bool + " signal14Wave1430Bool: " + signal14Wave1430Bool + " signal5Wave1430Bool: " + signal5Wave1430Bool + " safeSig1Bool:" + safeSig1Bool + " safeSig2Bool: " + safeSig2Bool + " imaSig1Bool: " + imaSig1Bool);
   }
};
//+------------------------------------------------------------------+



struct STATE_SIGNAL {
   SAN_SIGNAL        dominantSIG;
   SAN_SIGNAL        c_SIG;
   SAN_SIGNAL        tradeSIG;
   SAN_SIGNAL        fastSIG;
   SAN_SIGNAL        simple_5_14_SIG;
   SAN_SIGNAL        simple_14_30_SIG;
   SAN_SIGNAL        simpleTrend_5_14_SIG;
   SAN_SIGNAL        simpleTrend_14_30_SIG;
   SAN_SIGNAL        simpleSlope_30_SIG;
   SAN_SIGNAL        cpSlopeCandle120SIG;
   SAN_SIGNAL        volSIG;
   SAN_SIGNAL        volSlopeSIG;
   SAN_SIGNAL        dominantTrendCPSIG;
   SAN_SIGNAL        dominantTrendSIG;
   TRADE_STRATEGIES  trdStgy;

   void              initSIG() {
      dominantSIG = SAN_SIGNAL::NOSIG;
      tradeSIG = SAN_SIGNAL::NOSIG;
      c_SIG = SAN_SIGNAL::NOSIG;
      fastSIG = SAN_SIGNAL::NOSIG;
      simple_5_14_SIG = SAN_SIGNAL::NOSIG;
      simple_14_30_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_5_14_SIG = SAN_SIGNAL::NOSIG;
      simpleTrend_14_30_SIG = SAN_SIGNAL::NOSIG;
      simpleSlope_30_SIG = SAN_SIGNAL::NOSIG;
      cpSlopeCandle120SIG = SAN_SIGNAL::NOSIG;
      volSIG = SAN_SIGNAL::NOSIG;
      volSlopeSIG = SAN_SIGNAL::NOSIG;
      dominantTrendCPSIG = SAN_SIGNAL::NOSIG;
      dominantTrendSIG = SAN_SIGNAL::NOSIG;
      trdStgy = TRADE_STRATEGIES::NOTRDSTGY;
   }

   STATE_SIGNAL() {
      initSIG();
   }

   ~STATE_SIGNAL() {
      initSIG();
   }
   void              printState() {
      //Print("[STATE] :: domSIG: "+util.getSigString(dominantSIG)+" c_SIG: "+util.getSigString(c_SIG)+" fastSIG: "+util.getSigString(fastSIG)+" 5_14:"+util.getSigString(simple_5_14_SIG)+" Slope30: "+util.getSigString(simpleSlope_30_SIG)+" cp120: "+util.getSigString(cpSlopeCandle120SIG)+" volSIG:"+ util.getSigString(volSIG)+" volSlopeSIG: "+util.getSigString(volSlopeSIG)+" domTrCP: "+util.getSigString(dominantTrendCPSIG)+" trendSIG:: "+util.getSigString(dominantTrendSIG));
   }
};
//+------------------------------------------------------------------+
