//+------------------------------------------------------------------+
//|                                                    Analytics.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Utils.mqh"

class Analytics
  {
private:
   
public:

   Analytics();
   ~Analytics();
   
   static void WriteStats(int ActiveOrderTicket) {
    
      string TradeRow;      
      bool IsOrderSelected = OrderSelect(ActiveOrderTicket, SELECT_BY_TICKET, MODE_TRADES);

      if(IsOrderSelected) {
         
         TradeRow =  Utils::GetDate() + "," + 
                  Utils::GetTime() + "," + 
                  OrderSymbol() + "," + 
                  IntegerToString(OrderTicket()) + "," + 
                  IntegerToString(OrderType()) + "," + 
                  DoubleToString(OrderOpenPrice()) + "," + 
                  DoubleToString(OrderTakeProfit()) + "," + 
                  DoubleToString(OrderStopLoss()) + "," + 
                  DoubleToString(OrderProfit());
         
         
         string FileName = Utils::GetDate() + "-ANALYTICS.csv";
         int FileHandle;
         
         if(!FileIsExist(FileName, 0)) {
        
           FileHandle = FileOpen(FileName,FILE_READ|FILE_WRITE|FILE_CSV, ',');
           FileWrite(FileHandle, ANALYTICS_HEADER); // HEADERS
           FileSeek(FileHandle, 0, SEEK_END);
           FileWrite(FileHandle, TradeRow);
           FileClose(FileHandle);
        
         }
         else {
            FileHandle = FileOpen(FileName,FILE_READ|FILE_WRITE|FILE_CSV, ',');
            FileSeek(FileHandle, 0, SEEK_END);
            FileWrite(FileHandle, TradeRow);
            FileClose(FileHandle);
         }
      }
   }
   
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Analytics::Analytics()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Analytics::~Analytics()
  {
  }
//+------------------------------------------------------------------+

/*
   void WriteStats(string tradeDetails) {
   
      //string folder = CreateFolder();
      //string yearmonth = IntegerToString(Year()) + "." + IntegerToString(Month());
      string filename = GetDate() + "-ANALYTICS.csv";
      int filehandle;
      
      string header = "ORDER_DATE," + 
      "ORDER_TIME," + 
      "SYMBOL," + 
      "ORDER_OPERATION," + 
      "ORDER_TICKET," + 
      "ORDER_OPEN_PRICE," + 
      "ORDER_PROFIT_PRICE," + 
      "CLOSED_TAKE_PROFIT," + 
      "ORDER_RISK_PRICE," + 
      "CLOSED_RISK_PRICE," + 
      "PROFIT";
                  
      if(!FileIsExist(filename, 0)) {
        
        filehandle = FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV, ',');
        FileWrite(filehandle, header + "\n"); // HEADERS
        FileSeek(filehandle, 0, SEEK_END);
        FileWrite(filehandle, tradeDetails + "\n");
        FileClose(filehandle);
        
      }
      else {
         filehandle = FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV, ',');
         FileSeek(filehandle, 0, SEEK_END);
         FileWrite(filehandle, tradeDetails + "\n");
         FileClose(filehandle);
      }
      */