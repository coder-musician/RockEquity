//+------------------------------------------------------------------+
//|                                                       Orders.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property library

#include "..\Constants.mqh"
#include "..\Classes\Management.mqh"

class Orders
  {
  
private:

public:
   
   static bool HaveOpenOrders(string symbol) {
      
      int TEMP_LIST[6] = {0,0,0,0,0,0};
      int NumberOfOrders = 0;
     
      for (int i = 0; i < OrdersTotal(); i++) {     
      
      if (OrderSelect(i, SELECT_BY_POS) == true) {
      
            if (OrderSymbol() == symbol && OrderCloseTime() == 0) {
            
               TEMP_LIST[NumberOfOrders] = OrderTicket();
               NumberOfOrders++;
            }
         }
      }
      
      ArrayResize(ORDERS_LIST, NumberOfOrders);      
      
      for(int i=0; i < NumberOfOrders; i++)
         ORDERS_LIST[i] = TEMP_LIST[i];
         
      ORDERS_ACTIVE_AMOUNT = NumberOfOrders;
         
      return (NumberOfOrders > 0);
   }
   
   static void LoadOrder(int orderTicket) {
   
      bool IsOrderSelected = OrderSelect(orderTicket, SELECT_BY_TICKET, MODE_TRADES);
      
      if (IsOrderSelected == True) {
         
         ORDER_OPEN_PRICE = OrderOpenPrice();
         ORDER_TAKE_PROFIT_PRICE = OrderTakeProfit();
         ORDER_STOP_LOSS_PRICE = OrderStopLoss();
      }
   }
   
   static void CloseOrders(string symbol) {
   
      if(Orders::HaveOpenOrders(symbol))
      
         for(int i=0; i < ArraySize(ORDERS_LIST); i++) {
            
            bool closeOrder = OrderSelect(ORDERS_LIST[i], SELECT_BY_TICKET, MODE_TRADES );
            bool orderClose = OrderClose(ORDERS_LIST[i], OrderLots(), OrderClosePrice(), ORDER_SLIPPAGE, clrNONE);
         }
   }   
   
   static void PlaceOrder (long ChartId, string symbol) {      
      
      double ORDER_RISK_CURRENCY = AccountBalance()*(RISK_PERCENTAGE/100);         
      double ORDER_RISK_PIPS = 0;
      double ORDER_UNITS = 0;
      
      ORDER_SPREAD = Ask-Bid;
      ORDER_TAKE_PROFIT_PRICE = Management::GetLinePrice(ChartId, "TP");
      ORDER_STOP_LOSS_PRICE = Management::GetLinePrice(ChartId, "SL");
         
      if(ORDER_TAKE_PROFIT_PRICE != 0 && ORDER_STOP_LOSS_PRICE != 0) {
         
         if(ORDER_STOP_LOSS_PRICE < Bid) {
                
            ORDER_OPERATION = OP_BUY;
            ORDER_OPEN_PRICE = Ask;
            ORDER_ORIGINAL_TAKE_PROFIT_PRICE = ORDER_TAKE_PROFIT_PRICE;
            ORDER_ORIGINAL_STOP_LOSS_PRICE = ORDER_STOP_LOSS_PRICE;
            
            ORDER_RISK_PIPS = ORDER_OPEN_PRICE - ORDER_ORIGINAL_STOP_LOSS_PRICE;            
         } 
         else {
                
            ORDER_OPERATION = OP_SELL;
            ORDER_OPEN_PRICE = Bid;
            
            ORDER_TAKE_PROFIT_PRICE = ORDER_TAKE_PROFIT_PRICE  + ORDER_SPREAD;
            ORDER_STOP_LOSS_PRICE = ORDER_STOP_LOSS_PRICE + ORDER_SPREAD;
             
            ORDER_ORIGINAL_TAKE_PROFIT_PRICE = ORDER_TAKE_PROFIT_PRICE;
            ORDER_ORIGINAL_STOP_LOSS_PRICE = ORDER_STOP_LOSS_PRICE;
            
            ORDER_RISK_PIPS = ORDER_ORIGINAL_STOP_LOSS_PRICE - ORDER_OPEN_PRICE;
            
         }         
         
         ORDER_UNITS = ORDER_RISK_CURRENCY/ORDER_RISK_PIPS;         
         ORDER_LOTS = ORDER_UNITS / ORDER_STANDARD_LOT;
         
         ORDER_TICKET = OrderSend(symbol, ORDER_OPERATION, ORDER_LOTS, ORDER_OPEN_PRICE, 
         ORDER_SLIPPAGE, ORDER_ORIGINAL_STOP_LOSS_PRICE, ORDER_ORIGINAL_TAKE_PROFIT_PRICE);
         
         bool updateOrdersList = HaveOpenOrders(symbol);
      }
      GetTradeSummary();
   }
     
   
   static void UpdateOrder(long ChartId, int &OrdersList[]) {
      
      double CurrentTakeProfit = Management::GetLinePrice(ChartId, "TP");
      double CurrentStopLoss = Management::GetLinePrice(ChartId, "SL");
      
      if(ORDER_OPERATION == OP_SELL) {
         
         CurrentTakeProfit = CurrentTakeProfit + ORDER_SPREAD;
         CurrentStopLoss = CurrentStopLoss + ORDER_SPREAD;
      }
      
      for(int i=0; i < ArraySize(ORDERS_LIST); i++) {
         
         bool UpdateOrder = False;
           
         if(CurrentTakeProfit != ORDER_TAKE_PROFIT_PRICE)
            UpdateOrder = True;
         
         if(CurrentStopLoss != ORDER_STOP_LOSS_PRICE)
            UpdateOrder = True;
            
         if(UpdateOrder) 
            bool UpdateSuccess = OrderModify(ORDERS_LIST[i], 0, CurrentStopLoss, CurrentTakeProfit, 0, clrNONE); 
      }
   }
   
   static void GetTradeSummary() {
   
      string Summary = "ORDER_TICKET: " + IntegerToString(ORDER_TICKET) + "\n" +
         "ORDER_OPEN_PRICE: " + DoubleToStr(ORDER_OPEN_PRICE) + "\n" +
         "ORDER_PROFIT_PRICE: " + DoubleToStr(ORDER_TAKE_PROFIT_PRICE) + "\n" +
         "ORDER_STOP_LOSS_PRICE: " + DoubleToStr(ORDER_STOP_LOSS_PRICE) + "\n" +
         "ORDER_LOTS: " + DoubleToStr(ORDER_LOTS) + "\n"+ 
         "ERROR: " + IntegerToString(GetLastError()) + "\n Enable Auto Trading";
         
         Alert(Summary);
   }
   
   Orders();   
   ~Orders();
   
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orders::Orders()
  {
      
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orders::~Orders()
  {
  }
//+------------------------------------------------------------------+

