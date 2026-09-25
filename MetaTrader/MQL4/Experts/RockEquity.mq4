//+------------------------------------------------------------------+
//|                                                  Rock Equity.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Include\\RockEquity\\Classes\\Orders.mqh"
#include "..\\Include\\RockEquity\\Classes\\Journal.mqh"
#include "..\\Include\\RockEquity\\Classes\\Analytics.mqh"
#include "..\\Include\\RockEquity\\Classes\\RockExpert.mqh"
#include "..\\Include\\RockEquity\\Indicators\\CustomVolume.mqh"
#include "..\\Include\\RockEquity\\Indicators\\Candlesticks.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
      
int OnInit()
  {
      if (Symbol() == "EURUSD") {
         LTF_CHART_ID = 134333430149543870;
         HTF_CHART_ID = 134333430135761055;
      }
      
      if (Symbol() == "EURGBP") {
         LTF_CHART_ID = 134334337949015556;
         HTF_CHART_ID = 134334337834424651;
      }
      
      if (Symbol() == "GBPUSD") {
         LTF_CHART_ID = 134334340546161909;
         HTF_CHART_ID = 134334359205706787;
      }
      
      if (Symbol() == "EURJPY") {
         LTF_CHART_ID = 134334341463480176;
         HTF_CHART_ID = 134334341438855800;
      }
      
      if (Symbol() == "USDJPY") {
         LTF_CHART_ID = 134334345187495181;
         HTF_CHART_ID = 134334345173670289;
      }
      
      if (Symbol() == "USDCAD") {
         LTF_CHART_ID = 134334345904232668;
         HTF_CHART_ID = 134334345933093075;
      }
      
      
      return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {   
      ORDER_SPREAD = Ask-Bid;
      
      bool IsNewCandle = RockExpert::IsNewCandle();
      RockExpert::ApplyChartSettings(); // FUNCTIONS DISABLED --> RefreshChartIDs / ApplyTemplates
      Management::RefreshLevels(ChartID());         

      CustomVolume::PlotCustomVolume(ChartID(), IsNewCandle);  
      Candlesticks::UpdateCandlesOpen(ChartID(), IsNewCandle);
      
      if(Orders::HaveOpenOrders(Symbol())) {
      
         if(!ORDER_IS_ACTIVE){ 
            
            // This happens only ONCE -> when the TRADE is just OPENED            
            ORDER_TICKET = ORDERS_LIST[ORDERS_ACTIVE_AMOUNT-1];
            ORDER_IS_ACTIVE = True;            
            Journal::TakeOpenSnapshot(LTF_CHART_ID, HTF_CHART_ID);
            
         } else { 
         
            // This happens ALWAYS throughout the TRADE LIFETIME.
            Orders::UpdateOrder(ChartID(), ORDERS_LIST);
            
            if(IsNewCandle)
               Journal::TakeTradeNextSnapshot(LTF_CHART_ID, HTF_CHART_ID);
         }
         
      } else {
      
         // This happens only ONCE -> when the TRADE is just CLOSED
         if(ORDER_IS_ACTIVE) {
            
            ORDER_IS_ACTIVE = False;
            Journal::TakeCloseSnapshot(LTF_CHART_ID, HTF_CHART_ID);
            Management::DeleteLevels(ChartID());
            //Analytics::WriteStats(ORDER_TICKET);
      }
      
      // This happens ONLY when there is NO TRADE OPEN         
         if(IsNewCandle)
           Journal::TakeMarketSnapshot(LTF_CHART_ID, HTF_CHART_ID);
      }
  }
  
//+------------------------------------------------------------------+
      
      
      
      
      