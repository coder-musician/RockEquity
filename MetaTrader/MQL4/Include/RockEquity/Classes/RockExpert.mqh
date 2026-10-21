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
      
      
   static long GetLTFId() {
      
      long ltf_id = 0;
      long chart_id = ChartFirst();
      
      while(chart_id >= 0) {
      
         if(ChartSymbol(chart_id) == Symbol()){
            ltf_id = chart_id;
            break;
         }
         
         chart_id = ChartNext(chart_id);  
      }
      
      return ltf_id;
   }
   
   static void SetChartsPeriods() {
   
      ChartSetSymbolPeriod(LTF_CHART_ID, NULL, LTF_PERIOD);
      ChartSetSymbolPeriod(HTF_CHART_ID, NULL, Utils::GetHTFPeriod(LTF_PERIOD));         
   }
   
   static void SetChartColor(long ChartId) {
   
      long ltf_id = GetLTFId();
      
      if(ChartId == ltf_id) {
         
         ChartSetInteger(ChartId, CHART_COLOR_CANDLE_BULL, CANDLE_BULL_LTF_BODY_COLOR);
         ChartSetInteger(ChartId, CHART_COLOR_CANDLE_BEAR, CANDLE_BEAR_LTF_BODY_COLOR);      
         ChartSetInteger(ChartId, CHART_COLOR_CHART_UP, CANDLE_BULL_LTF_WICK_COLOR);
         ChartSetInteger(ChartId, CHART_COLOR_CHART_DOWN, CANDLE_BEAR_LTF_WICK_COLOR);
      }
      else {
         
         ChartSetInteger(ChartId, CHART_COLOR_CANDLE_BULL, CANDLE_BULL_HTF_BODY_COLOR);
         ChartSetInteger(ChartId, CHART_COLOR_CANDLE_BEAR, CANDLE_BEAR_HTF_BODY_COLOR);      
         ChartSetInteger(ChartId, CHART_COLOR_CHART_UP, CANDLE_BULL_HTF_WICK_COLOR);
         ChartSetInteger(ChartId, CHART_COLOR_CHART_DOWN, CANDLE_BEAR_HTF_WICK_COLOR);
      }
         
   }
   
   static void ApplyTemplates(string symbol, long ChartId) {
      
          
      string templateName = "RockEquity-" + symbol + ".tpl";
      
      long chart_id = ChartFirst();
      
      while(chart_id >= 0) {
      
         if(ChartSymbol(chart_id) == symbol) {
         
            ChartApplyTemplate(chart_id, templateName);
         }
         
         chart_id = ChartNext(chart_id);      
      }      
   }
   
   static void LoadTemplates(string symbol) {
      
      long chart_id = ChartFirst();      
      string templateName = "RockEquity-" + symbol + ".tpl";
      
      while(chart_id >= 0) {
      
         if(ChartSymbol(chart_id) == symbol) {
         
            ChartApplyTemplate(chart_id, templateName);
            Sleep(1000);
         }
         
         chart_id = ChartNext(chart_id);      
      }      
   }
   
   static void SetChartPeriod(string symbol, long chartID) {

      long chart_id = ChartFirst();
      
      int ChartCounter = 0;

      while(chart_id >= 0) {
      
         if(ChartSymbol(chart_id) == symbol) {
            
            ChartCounter++;


            if(ChartCounter == 1 && chart_id == chartID) {

               ChartSetSymbolPeriod(chartID, NULL, LTF_PERIOD);
               break;
            }
            
            if(ChartCounter == 2 && chart_id == chartID) {

               ChartSetSymbolPeriod(chartID, NULL,  Utils::GetHTFPeriod(LTF_PERIOD));
               break;
            }
            
            if(ChartCounter == 3 && chart_id == chartID) {
            
               ChartSetSymbolPeriod(chartID, NULL, PERIOD_D1);
               break; 
            }
            
            if(ChartCounter == 4 && chart_id == chartID) {
            
               ChartSetSymbolPeriod(chartID, NULL, PERIOD_W1); 
               break;
            }
         }
         
         chart_id = ChartNext(chart_id);      
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