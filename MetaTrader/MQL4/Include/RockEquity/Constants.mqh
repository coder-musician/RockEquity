
// ---------------------------------- <CONFIG> --------------------------------- 
   double RISK_PERCENTAGE = 1;
   double RISK_REWARD_RATIO = 3;
   
   int ORDER_SLIPPAGE = 0;
   int ORDER_STANDARD_LOT = 100000;
   
   string TRADING_ACCOUNT_CURRENCY = "USD";

// --------------------------- CHARTS
   string CHART_SYMBOL = "";

   int LTF_PERIOD = PERIOD_D1;
   int HTF_PERIOD;
   
   long LTF_CHART_ID = 134325997127756350;
   long HTF_CHART_ID = 134325997110375514;
   
   int CANDLES_COUNT;

// --------------------------- MANAGEMENT  
   int OPEN_PRICE_COLOR = clrSienna;   
   int CLOSE_PRICE_COLOR = clrSienna;  
   int TAKE_PROFIT_COLOR = clrLightGreen;    
   int STOP_LOSS_COLOR = clrRed;
   int ASK_PRICES_COLOR = clrMidnightBlue;
   
   int CANDLE_BULL_LTF_WICK_COLOR = clrLightSeaGreen; 
   int CANDLE_BULL_LTF_BODY_COLOR = clrAqua;
   
   int CANDLE_BEAR_LTF_WICK_COLOR = clrMaroon;
   int CANDLE_BEAR_LTF_BODY_COLOR = clrCrimson;   
   
   int CANDLE_BULL_HTF_BODY_COLOR = clrLimeGreen;
   int CANDLE_BULL_HTF_WICK_COLOR = clrGreen;
   
   int CANDLE_BEAR_HTF_WICK_COLOR = clrMaroon;
   int CANDLE_BEAR_HTF_BODY_COLOR = clrCrimson;
   
// --------------------------- JOURNAL
   string IMAGE_PATH = "";
   string IMAGE_EXTENSION = ".png";
   
   int IMAGE_XPIX = 615;
   int IMAGE_YPIX = 882;  

// --------------------------- ORDERS
   int ORDER_TICKET;   
   string ORDER_SYMBOL_STRING;
   
   int ORDERS_LIST[];
   bool ORDER_IS_ACTIVE; 
   int ORDERS_ACTIVE_AMOUNT;
   
   
   string ORDER_DATE;
   string ORDER_TIME;
   int ORDER_OPERATION;
   
   double ORDER_LOTS;
   
   double ORDER_ORIGINAL_SPREAD;
   double ORDER_SPREAD;
   
   double ORDER_OPEN_PRICE;
   double ORDER_CLOSE_PRICE;
   
   double ORDER_ORIGINAL_TAKE_PROFIT_PRICE;
   double ORDER_TAKE_PROFIT_PRICE = 0;
   
   double ORDER_ORIGINAL_STOP_LOSS_PRICE;
   double ORDER_STOP_LOSS_PRICE = 0;
   
// --------------------------------- <INDICATORS> --------------------------------- 

// --------------------------- CANDLESTICKS
   string CANDLES_NAMES[3] = {"CANDLE0", "CANDLE1", "CANDLE2"};
   
   string CANDLE_FONT_TYPE = "Arial";
   int CANDLE_FONT_SIZE = 25;
   
   int CANDLE_OFFSET_X[3] = {11, 10, 9};
   int CANDLE_OFFSET_Y = 40;

   int CANDLE_OPEN_BULLISH_COLOR = clrGreen;
   int CANDLE_OPEN_BEARISH_COLOR = clrRed;
   int CANDLE_OPEN_TWEEZER_COLOR = clrWhite; 
   
   
// --------------------------- VOLUME
   int BARS_INCLUDED = 10; // last 10 bars
   int VOLUMES_FONT_SIZE = 8;
   int VOLUMES_FONT_COLOR = clrSteelBlue;
   int VOLUME_OFFSET_VALUE = 10;
   int X_POSITION = 50;
   int Y_POSITION = 30;   
   
   
// --------------------------- ANALYTICS
   string ANALYTICS_HEADER = "DATE," + 
      "TIME," + 
      "SYMBOL," + 
      "ORDER_TICKET," + 
      "OPERATION," +       
      "OPEN_PRICE," + 
      "TAKE_PROFIT," + 
      "STOP_LOSS," + 
      "PROFIT";                     
