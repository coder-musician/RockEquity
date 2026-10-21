//+------------------------------------------------------------------+
//|                                                      Journal.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Constants.mqh"
#include "..\\Utils.mqh"

class Journal
  {
private:
   /*
   static string GetImageFullPath(string group, string desc) {
      
      datetime LocalTime = TimeLocal();
      string LocalTimeString = TimeToString(LocalTime);
      
      datetime ServerTime = TimeCurrent();
      string ServerTimeString = TimeToString(ServerTime);
      
      // FOLDER NAME
      
      string FolderName = ChartSymbol() + "\\";      
      string YearMonth = StringSubstr(ServerTimeString,0,7);      
      FolderName = FolderName + YearMonth + "\\" + group + "\\";
      
      
      // IMAGE NAME
      
      string ImageName = ChartSymbol() + "--";
       
      StringReplace(LocalTimeString, " ", "_");
      StringReplace(LocalTimeString, ":", ".");      
      ImageName = ImageName + LocalTimeString + "--";
      
      StringReplace(ServerTimeString, " ", "_");
      StringReplace(ServerTimeString, ":", ".");
      ImageName = ImageName + ServerTimeString + "--";      
      
      ImageName = ImageName + desc + IMAGE_EXTENSION;
      
      return FolderName + ImageName;   
   }
   
   static void TakeSnapshot(long chartid, string group, string desc) {
   
      string imagePath = GetImageFullPath(group, desc);
      
      bool SnapSuccess = ChartScreenShot(chartid, imagePath, IMAGE_XPIX, 
         IMAGE_YPIX, ALIGN_RIGHT); 
   }*/
   
   
   static string GetImageName(string symbol) {
      
         datetime LocalTime = TimeLocal();
         string LocalTimeString = TimeToString(LocalTime);
         
         datetime ServerTime = TimeCurrent();
         string ServerTimeString = TimeToString(ServerTime);
            
         string ImageName = symbol + "-";
             
         StringReplace(LocalTimeString, " ", "--");
         StringReplace(LocalTimeString, ":", ".");      
         ImageName = ImageName + LocalTimeString + "--";
         
         StringReplace(ServerTimeString, " ", "-");
         StringReplace(ServerTimeString, ":", ".");
         ImageName = ImageName + ServerTimeString + "-"; 
         
         return ImageName;
   }
   
   
   static void TakeSnapshot(string symbol, string desc) {      
      
      string rootdir = IMAGE_PATH + symbol + "\\";
      string ImageName = GetImageName(symbol);
      string fullpath = "";
      
      bool SnapSuccess = false;
      string timeframe = "";
      
      long chart_id = ChartFirst();      
      int ChartCounter = 0;
      
      bool isLTFCompliant = false;

      while(chart_id >= 0) {
      
         if(ChartSymbol(chart_id) == symbol) {
            
            ChartCounter++;
            
            if(ChartCounter == 1) {               
               
               if(ChartPeriod(chart_id) == LTF_PERIOD) {
               
                  isLTFCompliant = true;
                  
                  timeframe = "LTF";               
                  fullpath = rootdir + "Intraday\\" + timeframe + "\\" + ImageName + desc + "-" + timeframe + IMAGE_EXTENSION;
                  
                  SnapSuccess = ChartScreenShot(chart_id, fullpath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
               }               
            }
            
            if(ChartCounter == 2 && isLTFCompliant) {
            
               timeframe = "HTF";               
               fullpath = rootdir + "Intraday\\" + timeframe + "\\" + ImageName + desc + "-" + timeframe + IMAGE_EXTENSION;
               
               SnapSuccess = ChartScreenShot(chart_id, fullpath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
            }
            
            if(ChartCounter == 3 && isLTFCompliant) {
            
               timeframe = "Daily";               
               fullpath = rootdir + "LTA\\" + timeframe + "\\" + ImageName + desc + "-" + timeframe + IMAGE_EXTENSION;
               
               SnapSuccess = ChartScreenShot(chart_id, fullpath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
            }
            
            if(ChartCounter == 4 && isLTFCompliant) {
            
               timeframe = "Weekly";               
               fullpath = rootdir + "LTA\\" + timeframe + "\\" + ImageName + desc + "-" + timeframe + IMAGE_EXTENSION;
               
               SnapSuccess = ChartScreenShot(chart_id, fullpath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
            }
            chart_id = ChartNext(chart_id);  
         }             
      }
   }
   
public:

   Journal();
  ~Journal();
   
   static void TakeMarketSnapshot(string symbol) {
      
      TakeSnapshot(symbol,"Market");
   }
   
   static void TakeOpenSnapshot(string symbol, int orderid) {
      
      TakeSnapshot(symbol,"Open-" + IntegerToString(orderid));
   }
   
   static void TakeTradeNextSnapshot(string symbol, int orderid) {
      
      TakeSnapshot(symbol,"Next-" + IntegerToString(orderid));
   }
   
   static void TakeCloseSnapshot(string symbol, int orderid) {
      
      TakeSnapshot(symbol,"Close-" + IntegerToString(orderid));
   }
   static void TakeCustomSnapshot(string symbol) {
      
      TakeSnapshot(symbol,"Custom");
   }
   /*static void TakeMarketSnapshot(long LTFChartID, long HTFChartID) {
      
      TakeSnapshot(LTFChartID, "LTF", "LTF");
      TakeSnapshot(HTFChartID, "HTF", "HTF");
   }
   
   static void TakeOpenSnapshot(long LTFChartID, long HTFChartID) {
      
      string Desc = "Open--" + IntegerToString(ORDER_TICKET);
          
      TakeSnapshot(LTFChartID, "LTF", Desc);
      TakeSnapshot(LTFChartID, "Trades\\LTF", Desc);
      
      TakeSnapshot(HTFChartID, "HTF", Desc);
      TakeSnapshot(HTFChartID, "Trades\\HTF", Desc);
   }
   
   static void TakeTradeNextSnapshot(long LTFChartID, long HTFChartID) {
      
      string Desc = "Next--" + IntegerToString(ORDER_TICKET);
          
      TakeSnapshot(LTFChartID, "LTF", Desc);
      TakeSnapshot(LTFChartID, "Trades\\LTF", Desc);
      
      TakeSnapshot(HTFChartID, "HTF", Desc);
      TakeSnapshot(HTFChartID, "Trades\\HTF", Desc);
   }
   
   static void TakeCloseSnapshot(long LTFChartID, long HTFChartID) {
      
      string Desc = "Close--" + IntegerToString(ORDER_TICKET);
          
      TakeSnapshot(LTFChartID, "LTF", Desc);
      TakeSnapshot(LTFChartID, "Trades\\LTF", Desc);
      
      TakeSnapshot(HTFChartID, "HTF", Desc);
      TakeSnapshot(HTFChartID, "Trades\\HTF", Desc);   
   }
   
   static void TakeCustomSnapshot(long LTFChartID) {
      
      TakeSnapshot(LTFChartID, "LTF", "Custom-LTF");
      TakeSnapshot(LTFChartID, "Custom\\LTF", "Custom-LTF");
      
      TakeSnapshot(LTFChartID, "HTF", "Custom-HTF");
      TakeSnapshot(LTFChartID, "Custom\\HTF", "Custom-HTF");
   }
   
   static void TakeLTASnapshot(long LTAChartID) {
     
     int chartPeriod = ChartPeriod(LTAChartID);
     //string dir = Utils::GetChartPeriodName(chartPeriod);
     
     //TakeSnapshot(LTAChartID, dir, dir);     
   }*/
   
   
   
   
   
      
  };
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Journal::Journal()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Journal::~Journal()
  {
  }
//+------------------------------------------------------------------+


  /*static void TakeSnapshot(string symbol, string Description) {
            
      long HtfChartId;
      long LtfChartId;
      
      Utils::GetChartIDs(symbol, HtfChartId, LtfChartId);
      Utils::
      
      if(Description != "")
         Description = "-" + Description;
      
      string FileName = symbol + "-" + Utils::GetDate() + "-" + Utils::GetTime() + Description + IMAGE_EXTENSION;
      
      long chartID = LtfChartId;
      string timeFrame = "LTF";
      
      string FilePath = timeFrame + "\\";
      string FullPath = FilePath + FileName;
      
      bool SnapSuccess = ChartScreenShot(chartID, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
      
      Sleep(100);
      
      chartID = HtfChartId;
      timeFrame = "HTF";
      
      FilePath = timeFrame + "\\";
      FullPath = FilePath + FileName;
      
      SnapSuccess = ChartScreenShot(chartID, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
      
   }
   
   static void TakeSnapshotID(long htfid, long ltfid, string Description) {
      
      string symbol = ChartSymbol(htfid);
      
      if(Description != "")
         Description = "-" + Description;
            
      string FileName = symbol + "-" + Utils::GetDate() + "-" + Utils::GetTime() + Description + IMAGE_EXTENSION;
      
      string FullPath = "LTF\\" + FileName;      
      bool SnapSuccess = ChartScreenShot(ltfid, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT); 
      
      Sleep(100);
      
      FullPath = "HTF\\" + FileName; 
      
      SnapSuccess = ChartScreenShot(htfid, FullPath, IMAGE_XPIX, IMAGE_YPIX, ALIGN_RIGHT);
      
   }
   
   static void MarketSnapshot(string symbol) {
      
      Journal::TakeSnapshot(symbol, "");
   }
   
   static void TradeSnapshot(string symbol, string tradeID) {
      
      Journal::TakeSnapshot(symbol, tradeID);   
   }   
   
   static void CustomSnapshot(string symbol) {
      
      Journal::TakeSnapshot(symbol, "Custom");
   }*/