//+------------------------------------------------------------------+
//|                                                   Management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property library

#include "..\\Constants.mqh"
#include "..\\Utils.mqh"
#include "Orders.mqh"

class Management
  {
private:

public:

   Management();
  ~Management();
  
   static void PlotLine(long ChartId, string LineName, double Price, int Color)  {
   
      if(!IsLineInChart(ChartId, LineName)) {
      
         bool NewLine = ObjectCreate(ChartId, LineName, OBJ_HLINE, 0, Time[0], Price, 0);      
         ObjectSetInteger(ChartId ,LineName,OBJPROP_COLOR, Color);
      }      
   }
   
   static void MoveLine(long ChartId, string LineName, double Price) {
   
      bool MoveLine = ObjectSetDouble(ChartId, LineName, OBJPROP_PRICE1, Price);
   }
   
   static double GetLinePrice(long ChartId, string LineName) {

      double LinePrice = NormalizeDouble(ObjectGet(LineName, 1),Digits); 
      
      if(LinePrice < 0)
         LinePrice = 0;
      
      return LinePrice;
   }
   
   static bool IsLineInChart(long ChartId, string LineName) {
      
      bool IsFound = False;
      
      int FoundLine = ObjectFind(ChartId, LineName);
      
      if(FoundLine != -1)
         IsFound = True;
      
      return IsFound;
   }
   
   static void DeleteLevels(long ChartId) {
         
      if(ObjectFind(ChartId, "TP") >= 0)
         ObjectDelete(ChartId, "TP");
         
      if(ObjectFind(ChartId, "OP") >= 0)
         ObjectDelete(ChartId, "OP");
         
      if(ObjectFind(ChartId, "SL") >= 0)   
         ObjectDelete(ChartId, "SL");
   }
   
   static void AdjustTakeProfit (long ChartId) {
      
      ORDER_SPREAD = Ask - Bid;
      double RiskInPips;
      
      ORDER_STOP_LOSS_PRICE = Management::GetLinePrice(ChartId, "SL");
      
      if(ORDER_STOP_LOSS_PRICE < Bid) { 
      
         ORDER_OPERATION = OP_BUY;
         ORDER_OPEN_PRICE = Ask;
      
         RiskInPips = ORDER_OPEN_PRICE - ORDER_STOP_LOSS_PRICE;         
         ORDER_TAKE_PROFIT_PRICE = ORDER_OPEN_PRICE + (RiskInPips*RISK_REWARD_RATIO);
         
      } else {
         
         ORDER_OPERATION = OP_SELL;
         ORDER_OPEN_PRICE = Bid - ORDER_SPREAD;
         
         RiskInPips = ORDER_STOP_LOSS_PRICE - ORDER_OPEN_PRICE;         
         ORDER_TAKE_PROFIT_PRICE = ORDER_OPEN_PRICE - (RiskInPips*RISK_REWARD_RATIO);
      }
   }
   
   static void RefreshLevels(long ChartId) {
   
      ORDER_SPREAD = Ask - Bid;
      
      if(Orders::HaveOpenOrders(ChartSymbol(ChartId))) {         
         
         int Ticket = 0;
         
         for(int i=0; i < ArraySize(ORDERS_LIST); i++)
            Ticket = ORDERS_LIST[i];
         
         if(OrderSelect(Ticket, SELECT_BY_TICKET)==true) { // <-- puedo tomar el tipo de trade (OP_SELL) tambien de la order en logar de las varioable
            
            ORDER_TAKE_PROFIT_PRICE = OrderTakeProfit();
            ORDER_STOP_LOSS_PRICE = OrderStopLoss();
            ORDER_OPEN_PRICE = OrderOpenPrice();
         }
         
         if(ORDER_OPERATION == OP_SELL)
            ORDER_OPEN_PRICE = ORDER_OPEN_PRICE - ORDER_SPREAD;
            
         if(ObjectFind(ChartID(), "TP") < 0) {
         
            PlotLine(ChartId, "TP", ORDER_TAKE_PROFIT_PRICE, TAKE_PROFIT_COLOR);
            ObjectSetInteger(ChartID(), "TP", OBJPROP_SELECTED, true);
         }
            
         if(ObjectFind(ChartId, "SL") < 0){ 
         
            PlotLine(ChartId, "SL", ORDER_STOP_LOSS_PRICE, STOP_LOSS_COLOR);
            ObjectSetInteger(ChartId, "SL", OBJPROP_SELECTED, true);
         }
            
         if(ObjectFind(ChartId, "OP") < 0)
            PlotLine(ChartId, "OP", ORDER_OPEN_PRICE, OPEN_PRICE_COLOR);
            
      } else {
      
         if(ObjectFind(ChartID(), "SL") >= 0) {
         
            AdjustTakeProfit(ChartId);
            
            if(ObjectFind(ChartID(), "TP") < 0) {
            
               PlotLine(ChartId, "TP", ORDER_TAKE_PROFIT_PRICE, TAKE_PROFIT_COLOR);
               ObjectSetInteger(ChartID(), "TP", OBJPROP_SELECTED, true);
            
            }else {
            
               MoveLine(ChartId, "TP", ORDER_TAKE_PROFIT_PRICE);
            }
            
            ORDER_OPEN_PRICE = Ask;
            
            if(ORDER_OPERATION == OP_SELL)
               ORDER_OPEN_PRICE = Bid - ORDER_SPREAD;
            
            if(ObjectFind(ChartID(), "OP") < 0) {
            
               PlotLine(ChartId, "OP", ORDER_OPEN_PRICE, OPEN_PRICE_COLOR);
            
            } else {
            
               MoveLine(ChartId, "OP", ORDER_OPEN_PRICE);
            }
            
         } else
            DeleteLevels(ChartId);
      }
   }      
   
      /*NUEVO FEATURE: Agregar condicion para que se pueda mover el precio 
      por abajo/encima del OPEN_PRICE cuando el trade esta en positivo
      
      
      bool isSLValid = False;
      double currentSL = GetLinePrice(ChartId, "SL-"+IntegerToString(ChartId));

      if(currentSL != ORDER_STOP_LOSS_PRICE) {

         if(ORDER_OPERATION == OP_BUY)
            if(currentSL > ORDER_ORIGINAL_STOP_LOSS_PRICE && currentSL < ORDER_OPEN_PRICE)
               isSLValid = True;
               
         if(ORDER_OPERATION == OP_SELL)
               if(currentSL < ORDER_ORIGINAL_STOP_LOSS_PRICE && currentSL > ORDER_OPEN_PRICE)
                  isSLValid = True;
                  
         if(isSLValid)
            ORDER_STOP_LOSS_PRICE = currentSL;
         else
            MoveLine(ChartId, "SL-"+IntegerToString(ChartId), ORDER_ORIGINAL_STOP_LOSS_PRICE);
            
      } */ 
   
   
   };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Management::Management()
  {
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Management::~Management()
  {
  }
//+------------------------------------------------------------------+
 
 