//+------------------------------------------------------------------+
//|                                                   RockExpert.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property library

#include "..\Utils.mqh"
#include "..\Constants.mqh"
#include "..\\Classes\\RockExpert.mqh"

class RockExpert
  {
private:

public:

   RockExpert();
  ~RockExpert();

   static bool IsNewCandle() {

      bool NewCandle = false;
      
      if(CANDLES_COUNT < Bars) {
         
         NewCandle = true;
         CANDLES_COUNT = Bars;
      }
      
      return NewCandle;
   }
      
      
   static void RefreshChartIDs(){
      
      if(ChartID() != LTF_CHART_ID || ChartID() != HTF_CHART_ID) {
      
         long ChartId = ChartFirst();
         long TMP_Chart_IDs[2] = {0,0};
         int ChartCounter = 0;
         
         while (ChartId >= 0 && ChartCounter <= 2) {
         
            if(ChartSymbol(ChartId) == CHART_SYMBOL) {
               
                  if(ChartCounter == 0)            
                     HTF_CHART_ID = ChartId;
                  
                  else if(ChartCounter == 1)   
                     LTF_CHART_ID = ChartId;
                  
                  else
                     break;
                     
               ChartCounter++;
               ChartId = ChartNext(ChartId);
            }
         }
      }
   }
   
   static void SetChartsPeriods() {
   
      ChartSetSymbolPeriod(LTF_CHART_ID, NULL, LTF_PERIOD);
      ChartSetSymbolPeriod(HTF_CHART_ID, NULL, Utils::GetHTFPeriod(LTF_PERIOD));         
   }
   
   static void SetChartColors() {
      
      ChartSetInteger(LTF_CHART_ID, CHART_COLOR_CANDLE_BULL, CANDLE_BULL_LTF_BODY_COLOR);
      ChartSetInteger(LTF_CHART_ID, CHART_COLOR_CANDLE_BEAR, CANDLE_BEAR_LTF_BODY_COLOR);      
      ChartSetInteger(LTF_CHART_ID, CHART_COLOR_CHART_UP, CANDLE_BULL_LTF_WICK_COLOR);
      ChartSetInteger(LTF_CHART_ID, CHART_COLOR_CHART_DOWN, CANDLE_BEAR_LTF_WICK_COLOR);
      
      
      ChartSetInteger(HTF_CHART_ID, CHART_COLOR_CANDLE_BULL, CANDLE_BULL_HTF_BODY_COLOR);
      ChartSetInteger(HTF_CHART_ID, CHART_COLOR_CANDLE_BEAR, CANDLE_BEAR_HTF_BODY_COLOR);         
      ChartSetInteger(HTF_CHART_ID, CHART_COLOR_CHART_UP, CANDLE_BULL_HTF_WICK_COLOR);
      ChartSetInteger(HTF_CHART_ID, CHART_COLOR_CHART_DOWN, CANDLE_BEAR_HTF_WICK_COLOR);
         
   }
   
   static void ApplyTemplates() {
   
      string templateName = "RockEquity-" + CHART_SYMBOL + ".tpl";
      
      ChartApplyTemplate(LTF_CHART_ID, templateName);
      ChartApplyTemplate(HTF_CHART_ID, templateName);
      
   }
   
   static void ApplyChartSettings() {

      if(ChartID() != LTF_CHART_ID || ChartID() != HTF_CHART_ID) {
         CHART_SYMBOL = Symbol();
                  
         //RefreshChartIDs();
         SetChartsPeriods();
         SetChartColors();
         //ApplyTemplates();
      }
   }
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RockExpert::RockExpert()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RockExpert::~RockExpert()
  {
  }
//+------------------------------------------------------------------+