//+------------------------------------------------------------------+
//|                                          RSI_3TF(YTG.COM.UA).mq4 |
//|                                        Yuriy Tokman (YTG.COM.UA) |
//|                                                http://ytg.com.ua |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG.COM.UA)"
#property link      "http://ytg.com.ua"

#property indicator_separate_window

#property indicator_buffers 3
#property indicator_color1 DimGray
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_level1  30
#property indicator_level2  70
#property indicator_minimum 0
#property indicator_maximum 100

extern string Copyright = "Yuriy Tokman";
extern string œ»ÿ”_Õ¿_«¿ ¿«_› —œ≈–“€ = "»Õƒ» ¿“Œ–€_— –»œ“€";
extern string Forex_Expert_Adviser = "YTG.COM.UA";
extern string e_mail = "yuriytokman@gmail.com";
extern string Skype = "yuriy.t.g";

extern int applied_price = 0;
extern int TF_1 = 15 ;
extern int period_1 = 14 ;
extern int TF_2 = 60 ;
extern int period_2 = 14 ;
extern int TF_3 = 240 ;
extern int period_3 = 14 ;

double B1[];
double B2[];
double B3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string name = "RSI_3TF(YTG.COM.UA) ";
   IndicatorShortName(name);GetAvtor();

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,B1);
   SetIndexLabel(0,name+GetNameTF(TF_1)+" "+period_1);
   
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,B2);
   SetIndexLabel(1,name+GetNameTF(TF_2)+" "+period_2);   
   
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,B3);
   SetIndexLabel(2,name+GetNameTF(TF_3)+" "+period_3);    
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("label");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int limit, shif;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

   for(int i=limit; i>=0; i--)
   {
    shif = iBarShift(Symbol(),TF_1,Time[i]);
    double rsi_1 = iRSI(Symbol(),TF_1,period_1,applied_price,shif);
    B1[i] = rsi_1;                
   }
   
   for(  i=limit; i>=0; i--)
   {
    shif = iBarShift(Symbol(),TF_2,Time[i]);
    double rsi_2 = iRSI(Symbol(),TF_2,period_2,applied_price,shif);
    B2[i] = rsi_2;                
   }
   
   for(  i=limit; i>=0; i--)
   {
    shif = iBarShift(Symbol(),TF_3,Time[i]);
    double rsi_3 = iRSI(Symbol(),TF_3,period_3,applied_price,shif);
    B3[i] = rsi_3;                
   }         
//----
   return(0);
  }
//+------------------------------------------------------------------+
string GetNameTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
    case PERIOD_M1:  return("M1");
    case PERIOD_M5:  return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1:  return("H1");
    case PERIOD_H4:  return("H4");
    case PERIOD_D1:  return("Daily");
    case PERIOD_W1:  return("Weekly");
    case PERIOD_MN1: return("Monthly");
    default:         return("UnknownPeriod");
  }
}
//----+
 void Label(string name_label,string text_label,int corner = 2,int x = 3,int y = 15,int font_size = 10,string font_name = "Arial Black",color text_color = LimeGreen )
  {
   if (ObjectFind(name_label)!=-1) ObjectDelete(name_label);
       ObjectCreate(name_label,OBJ_LABEL,0,0,0,0,0);         
       ObjectSet(name_label,OBJPROP_CORNER,corner);
       ObjectSet(name_label,OBJPROP_XDISTANCE,x);
       ObjectSet(name_label,OBJPROP_YDISTANCE,y);
       ObjectSetText(name_label,text_label,font_size,font_name,text_color);
  }
//----+
void GetAvtor()
 {
  string char[256]; int i;
  for (i = 0; i < 256; i++) char[i] = CharToStr(i);   
  string txtt =
  char[32]+char[104]+char[116]+char[116]
  +char[112]+char[58]+char[47]+char[47]+char[121]+char[116]+char[103]+char[46]
  +char[99]+char[111]+char[109]+char[46]+char[117]+char[97];
  Label("label",txtt,2,10,15,15);    
 }
//----+