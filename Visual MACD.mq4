
#property copyright "Copyright © 2013, drivermql@mail.ru"
#property link      "http://stavmany.ru/forex/"



#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Teal
#property indicator_color2 Brown
#property indicator_color3 Red
#property indicator_color4 Blue
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 2

//----

extern int ma_1 = 28;
extern int ma_2 = 144;
extern int method = 3;
extern int price = 0;
extern int signal = 14;
extern int s_method = 0;
extern int signal2 = 70;
extern int s_method2 = 0;
extern color color1 = Teal;
extern color color2 = Brown;
extern color color3 = Red;
extern color color4 = Blue;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double MACD_Map[];
double SignalLine[];
double SignalLine2[];
double SignalMap2[];
double SignalMap[];
//----
int ExtCountedBars=0;
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
int init()
  {
//---- indicators
   IndicatorBuffers(7);
   
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE, 0, 2, color3);
   SetIndexBuffer(2, SignalLine);
   SetIndexStyle(3,DRAW_LINE, 0, 2, color4);
   SetIndexBuffer(3, SignalLine2);  
   
   SetIndexBuffer(4,MACD_Map);
   SetIndexStyle(4,DRAW_NONE);
   SetIndexBuffer(5,SignalMap);    
   SetIndexStyle(5,DRAW_NONE); 
   SetIndexBuffer(6,SignalMap2);    
   SetIndexStyle(6,DRAW_NONE);
   
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,signal);
   SetIndexDrawBegin(3,signal2);
//---- indicator buffers mapping

     
Comment("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n yuriytokman@gmail.com");

   return(0);
  }
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
int start()
  {
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     { 
      ExtMapBuffer1[pos]=iMA(Symbol(),0,ma_1,0,method,price,pos);
      ExtMapBuffer2[pos]=iMA(Symbol(),0,ma_2,0,method,price,pos);
      MACD_Map[pos]=ExtMapBuffer1[pos]-ExtMapBuffer2[pos];
 	   pos--;
     }
   // сигнальные линии
   pos=Bars-ExtCountedBars-1;  
   
   while(pos>=0) 
     {
      SignalMap[pos]=  iMAOnArray(MACD_Map,0,signal,0,s_method,pos);
      SignalLine[pos]= NormalizeDouble(ExtMapBuffer2[pos]+SignalMap[pos],Digits);
    
      SignalMap2[pos]=  iMAOnArray(MACD_Map,0,signal2,0,s_method2,pos);
      SignalLine2[pos]= NormalizeDouble(SignalMap2[pos]+ExtMapBuffer2[pos],Digits);
      pos--;
     } 

   return(0);
  }
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n