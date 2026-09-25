//+------------------------------------------------------------------+
//|                                                 Candlesticks.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Constants.mqh"

class Candlesticks
  {
private:

   static void DeleteCandleDots(long ChartId, string CandleName) {
   
         ObjectDelete(ChartId, CandleName);   
   }
   
   static bool isGreen(int candle) {
      
      if(Close[candle] > Open[candle])
         return true;
      else
         return false;
   }
   
   static double getBodySize(int candle){
      
      double bodySize = 0;
      
      if(isGreen(candle))
         bodySize = Close[candle] - Open[candle];
      else  
         bodySize = Open[candle] - Close[candle];
            
      return bodySize;
   }
   
   static double getWickSize(int candle){
      
      double wickSize = 0;
      
      if(isGreen(candle))
         wickSize = High[candle] - Close[candle];
      else  
         wickSize = Open[candle] - Low[candle];
            
      return wickSize;
   }
   
   static int getOpenColor(int candle) {
      
      int openColor = 0;
   
      if(isGreen(candle+1) && (Open[candle]) > Close[candle+1])
         openColor = CANDLE_OPEN_BULLISH_COLOR;
      else if(isGreen(candle+1) && (Open[candle]) < Close[candle+1])
         openColor = CANDLE_OPEN_BEARISH_COLOR;
         
      else if(!isGreen(candle+1) && (Open[candle]) > Close[candle+1])
         openColor = CANDLE_OPEN_BULLISH_COLOR;
      else if(!isGreen(candle+1) && (Open[candle]) < Close[candle+1])
         openColor = CANDLE_OPEN_BEARISH_COLOR;
         
      else
         openColor = CANDLE_OPEN_TWEEZER_COLOR;
         
      return openColor;
   }
      
   static bool isDoji(int candle) {
      
      if(Open[candle] == Close[candle])
         return true;
      else
         return false;
   }
   
   static bool isEngulfing(int candle) {
      
      bool isEngulfing = False;
      
      double bodySizeOne = 0;
      double bodySizeTwo = 0;     
      
      if(isGreen(candle) != isGreen(candle+1)) {
      
         bodySizeOne = getBodySize(candle);
         bodySizeTwo = getBodySize(candle+1);
      }
     
      if(bodySizeOne > bodySizeTwo)
         isEngulfing =  True;

      return isEngulfing;
   }
   
   static bool isKangeroo(int candle) {
   
      if(getBodySize(candle) < getWickSize(candle))
         return true;
      else
         return false;
   }
   
   static string getCandleType(int candle) {
      
      string candleType = "'";
      /*
      if(isDoji(candle))
         candleType = "+";
         
      else {
         
         if(isEngulfing(candle))
            candleType = "E";
            
         if(isKangeroo(candle))
            candleType = candleType + "K";
         
      }
      
      if(candleType == "")
         candleType = "|";
      */
      return candleType;
   }
   
   static void PlotCandlesDots(long ChartId) {
      
      datetime RightEdgeTime;
      
      for(int i=0; i < ArrayRange(CANDLES_NAMES, 0); i++) {
      
         DeleteCandleDots(ChartId, CANDLES_NAMES[i]);
         
         RightEdgeTime = TimeCurrent() + (PeriodSeconds()*CANDLE_OFFSET_X[i]);   
         ObjectCreate(ChartId, CANDLES_NAMES[i], OBJ_TEXT, 0, RightEdgeTime, Bid);
         
         ObjectSetString(ChartId, CANDLES_NAMES[i], OBJPROP_TEXT, ".");
         ObjectSetInteger(ChartId, CANDLES_NAMES[i], OBJPROP_FONTSIZE, CANDLE_FONT_SIZE);      
         ObjectSetInteger(ChartId, CANDLES_NAMES[i], OBJPROP_COLOR, clrWhite);
      }
   }
   
   
   
public:

   Candlesticks();
  ~Candlesticks();
  
  static void UpdateCandlesOpen(long ChartId, bool newCandle)
  {
      if(newCandle) {
      
         PlotCandlesDots(ChartId);
         
         ObjectSetText(CANDLES_NAMES[0], getCandleType(0), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(0));
         ObjectSetText(CANDLES_NAMES[1], getCandleType(1), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(1));
         ObjectSetText(CANDLES_NAMES[2], getCandleType(2), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(2));
      }
      else {
         
         bool MoveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[0], OBJPROP_PRICE1, Bid);
         MoveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[1], OBJPROP_PRICE1, Bid);
         MoveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[2], OBJPROP_PRICE1, Bid);
      }
      
   }
  
  
  
  
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Candlesticks::Candlesticks()
  {
  }

//+------------------------------------------------------------------+
/*static void UpdateCandlesOpen(long ChartId, bool CandleIsNew)
  {
  
//tatic void MoveLine(long ChartId, double Price) {

      if(CandleIsNew) {
      
         PlotCandlesDots(ChartId);
         
         ObjectSetText(CANDLES_NAMES[0], getCandleType(0), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(0));
         ObjectSetText(CANDLES_NAMES[1], getCandleType(1), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(1));
         ObjectSetText(CANDLES_NAMES[2], getCandleType(2), CANDLE_FONT_SIZE, CANDLE_FONT_TYPE, getOpenColor(2));
      }      
      else {
         
         double price = NormalizeDouble(ObjectGet(CANDLES_NAMES[0], 1),Digits); 
         bool moveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[0], OBJPROP_PRICE1, Bid);
         
         price = NormalizeDouble(ObjectGet(CANDLES_NAMES[1], 1),Digits); 
         moveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[1], OBJPROP_PRICE1, Bid);
         
         price = NormalizeDouble(ObjectGet(CANDLES_NAMES[2], 1),Digits); 
         moveLine = ObjectSetDouble(ChartId, CANDLES_NAMES[2], OBJPROP_PRICE1, Bid);
      }
      
   }*/