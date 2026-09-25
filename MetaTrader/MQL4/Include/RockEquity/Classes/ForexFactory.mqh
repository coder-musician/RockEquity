//+------------------------------------------------------------------+
//|                                                 ForexFactory.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class ForexFactory
  {
  
private:

//------------------------------------------------------
static int FindLongestString(string &ColumnValues[]) {
   int LongestString = 0;
   for(int i=0; i<ArraySize(ColumnValues); i++)
      if(StringLen(ColumnValues[i])>LongestString)
         LongestString=StringLen(ColumnValues[i]);
   return LongestString;
}

//------------------------------------------------------
static string ResizeRecord(string record, int size) {
   int SpacesLeft = size - StringLen(record);
   while(SpacesLeft>0) { record = record + " "; SpacesLeft--; }
   return record;
}

//------------------------------------------------------
static void DeleteRecords() {
   
   int obj_total = ObjectsTotal()-1;
   string name;
   
   while(obj_total>=0) {
   
      name = ObjectName(obj_total);
   
      if(StringFind(name,"record_")!=-1 || StringFind(name,"impact_")!=-1) 
         ObjectDelete(0,name);
   
      obj_total--;
   }
}
static void ChangeColor() {
   
   int obj_total = ObjectsTotal()-1;
   string name;
   string labelText;
   
   while(obj_total>=0) {
      name = ObjectName(obj_total);
      
      if(StringFind(name,"impact_")!=-1) {
         
         ObjectGetString(0, name, OBJPROP_TEXT, 0, labelText);
         
         if(labelText == "LOW")
            ObjectSetInteger(0,name,OBJPROP_COLOR,clrGreen);
      }
      
      obj_total--;
   }
}


public:
                     ForexFactory();
                    ~ForexFactory();
                    
   static void RefreshNews() {
   
   int HourSize     = 0;
   int TimeLeftSize = 1;   
   int CurrencySize = 2;
   int NameSize     = 3;   
   int ImpactSize   = 4;
   int ActualSize   = 5;
   int ForecastSize = 6;   
   int PreviousSize = 7;
   
      string FileName="FFcal.txt";
   string CSVRows[];
   int CSVRowIndex=0;
   string Colums[];
   int ColumnSize[8];
   string EventHour[], EventTimeLeft[], EventCurrency[];
   string EventName[], EventImpact[], EventActual[], EventForecast[], EventPrevious[];

   DeleteRecords();

   //--- Read CSV file
   int fileHandle = FileOpen(FileName,FILE_READ|FILE_TXT);
   if(fileHandle<0) { Print("Could not open file: ",FileName); return; }
   while(!FileIsEnding(fileHandle)) {
      ArrayResize(CSVRows,CSVRowIndex+1);
      CSVRows[CSVRowIndex]=FileReadString(fileHandle);
      CSVRowIndex++;
   }
   FileClose(fileHandle);

   //--- Parse CSV rows into arrays
   for(int i=0;i<ArraySize(CSVRows);i++) {
      StringSplit(CSVRows[i],',',Colums);
      ArrayResize(EventHour,i+1);     EventHour[i]=Colums[0];
      ArrayResize(EventTimeLeft,i+1); EventTimeLeft[i]=Colums[1];
      ArrayResize(EventCurrency,i+1); EventCurrency[i]=Colums[2];
      ArrayResize(EventName,i+1);     EventName[i]=Colums[3];
      ArrayResize(EventImpact,i+1);   EventImpact[i]=Colums[4];
      ArrayResize(EventActual,i+1);   EventActual[i]=Colums[5];
      ArrayResize(EventForecast,i+1); EventForecast[i]=Colums[6];
      ArrayResize(EventPrevious,i+1); EventPrevious[i]=Colums[7];
   }

   //--- Calculate column widths (consider header names)
   ColumnSize[HourSize]     = MathMax(FindLongestString(EventHour), StringLen("Hour"));
   ColumnSize[TimeLeftSize] = MathMax(FindLongestString(EventTimeLeft), StringLen("TL"));
   ColumnSize[CurrencySize] = MathMax(FindLongestString(EventCurrency), StringLen("CUR"));
   ColumnSize[NameSize]     = MathMax(FindLongestString(EventName), StringLen("Name"));
   ColumnSize[ImpactSize]   = MathMax(FindLongestString(EventImpact), StringLen("Impact"));
   ColumnSize[ActualSize]   = MathMax(FindLongestString(EventActual), StringLen("Actual"));
   ColumnSize[ForecastSize] = MathMax(FindLongestString(EventForecast), StringLen("Forecast"));
   ColumnSize[PreviousSize] = MathMax(FindLongestString(EventPrevious), StringLen("Previous"));

   //--- Calculate X offsets
   int xOffsetLeft=10;
   int leftWidth=(ColumnSize[HourSize]+2+ColumnSize[TimeLeftSize]+2+
                  ColumnSize[CurrencySize]+2+ColumnSize[NameSize])*7;
   int xOffsetRight=xOffsetLeft+leftWidth+130; // padding

   //--- Headers
   string leftHeader = ResizeRecord("Hour",ColumnSize[HourSize])+"  "+
                       ResizeRecord("TL",ColumnSize[TimeLeftSize])+"  "+
                       ResizeRecord("CUR",ColumnSize[CurrencySize])+"  "+
                       ResizeRecord("Name",ColumnSize[NameSize]);

   string rightHeader= ResizeRecord("Impact",ColumnSize[ImpactSize])+"  "+
                       ResizeRecord("Actual",ColumnSize[ActualSize])+"  "+
                       ResizeRecord("Forecast",ColumnSize[ForecastSize])+"  "+
                       ResizeRecord("Previous",ColumnSize[PreviousSize]);

   ObjectCreate(0,"record_left_header",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"record_left_header",OBJPROP_TEXT,leftHeader);
   ObjectSetString(0,"record_left_header",OBJPROP_FONT,"Courier");
   ObjectSetInteger(0,"record_left_header",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"record_left_header",OBJPROP_XDISTANCE,xOffsetLeft);
   ObjectSetInteger(0,"record_left_header",OBJPROP_YDISTANCE,10);
   ObjectSetInteger(0,"record_left_header",OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,"record_left_header",OBJPROP_COLOR,clrYellow);

   ObjectCreate(0,"record_right_header",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"record_right_header",OBJPROP_TEXT,rightHeader);
   ObjectSetString(0,"record_right_header",OBJPROP_FONT,"Courier");
   ObjectSetInteger(0,"record_right_header",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"record_right_header",OBJPROP_XDISTANCE,xOffsetRight);
   ObjectSetInteger(0,"record_right_header",OBJPROP_YDISTANCE,10);
   ObjectSetInteger(0,"record_right_header",OBJPROP_FONTSIZE,8);
   ObjectSetInteger(0,"record_right_header",OBJPROP_COLOR,clrYellow);


   //--- Left table
   for(int i=0;i<ArraySize(EventName);i++) {
   
      if(StringFind(Symbol(), EventCurrency[i], 0) != -1) {
      
         string record= ResizeRecord(EventHour[i],ColumnSize[HourSize])+"  "+
                        ResizeRecord(EventTimeLeft[i],ColumnSize[TimeLeftSize])+"  "+
                        ResizeRecord(EventCurrency[i],ColumnSize[CurrencySize])+"  "+
                        ResizeRecord(EventName[i],ColumnSize[NameSize]);
                        
         string objName="record_left_"+IntegerToString(i);
         
         ObjectCreate(0,objName,OBJ_LABEL,0,0,0);
         ObjectSetString(0,objName,OBJPROP_TEXT,record);
         ObjectSetString(0,objName,OBJPROP_FONT,"Courier");
         ObjectSetInteger(0,objName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,objName,OBJPROP_XDISTANCE,xOffsetLeft);
         ObjectSetInteger(0,objName,OBJPROP_YDISTANCE,27 + i*17); // below header
         ObjectSetInteger(0,objName,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,objName,OBJPROP_COLOR,clrWhite);
      

   


//--- Right table

   
    
       string impactUpper = StringToUpper(EventImpact[i]);
   
       // Create label for Impact column only
       string impactLabel = ResizeRecord(EventImpact[i], ColumnSize[ImpactSize]);
       string objImpact = "record_right_impact_" + IntegerToString(i);
       ObjectCreate(0,objImpact,OBJ_LABEL,0,0,0);
       ObjectSetString(0,objImpact,OBJPROP_TEXT, impactLabel);
       ObjectSetString(0,objImpact,OBJPROP_FONT,"Courier");
       ObjectSetInteger(0,objImpact,OBJPROP_CORNER,CORNER_LEFT_UPPER);
       ObjectSetInteger(0,objImpact,OBJPROP_XDISTANCE,xOffsetRight);
       ObjectSetInteger(0,objImpact,OBJPROP_YDISTANCE,27 + i*17);
       ObjectSetInteger(0,objImpact,OBJPROP_FONTSIZE,8);
       
       if(EventImpact[i] == "LOW")
         ObjectSetInteger(0,objImpact,OBJPROP_COLOR,clrGreen);
       else if(EventImpact[i] == "MEDIUM")
         ObjectSetInteger(0,objImpact,OBJPROP_COLOR,clrGold);
       else if(EventImpact[i] == "HIGH")
         ObjectSetInteger(0,objImpact,OBJPROP_COLOR,clrRed);
       
       
       
       
       // Create separate label for the rest of the row
       string restLabel = ResizeRecord(EventActual[i], ColumnSize[ActualSize]) + "  " +
                          ResizeRecord(EventForecast[i], ColumnSize[ForecastSize]) + "  " +
                          ResizeRecord(EventPrevious[i], ColumnSize[PreviousSize]);
       string objRest = "record_right_rest_" + IntegerToString(i);
       ObjectCreate(0,objRest,OBJ_LABEL,0,0,0);
       ObjectSetString(0,objRest,OBJPROP_TEXT, restLabel);
       ObjectSetString(0,objRest,OBJPROP_FONT,"Courier");
       ObjectSetInteger(0,objRest,OBJPROP_CORNER,CORNER_LEFT_UPPER);
       ObjectSetInteger(0,objRest,OBJPROP_XDISTANCE,(xOffsetLeft+leftWidth+200) + ColumnSize[ImpactSize] + 2);
       ObjectSetInteger(0,objRest,OBJPROP_YDISTANCE,27 + i*17);
       ObjectSetInteger(0,objRest,OBJPROP_FONTSIZE,8);
       ObjectSetInteger(0,objRest,OBJPROP_COLOR,clrWhite);
    


}
}
   
   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ForexFactory::ForexFactory()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ForexFactory::~ForexFactory()
  {
  }
//+------------------------------------------------------------------+
