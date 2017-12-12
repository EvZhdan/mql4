//+---------------------------------------------------------+
//|                                          MarketMood.mq4 |
//+---------------------------------------------------------+
#property copyright "StoneHeart"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 DeepPink
#property indicator_color3 Tomato
#property indicator_color4 Orange
#property indicator_color5 Yellow
#property indicator_color6 Lime
#property indicator_color7 Aqua
#property indicator_color8 Blue
#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_DOT
#property indicator_style3 STYLE_DOT
#property indicator_style4 STYLE_DOT
#property indicator_style5 STYLE_DOT
#property indicator_style6 STYLE_DOT
#property indicator_style7 STYLE_DOT
#property indicator_style8 STYLE_DOT

//--- input parameters
extern int TimeMX=3; // Multiply analized timeframe
extern bool SignalAudio=false; // Enable Audio signals, and also LOG (regadless SignalLog)
extern bool SignalLog=false; // Enable LOG signals, when Audio is OFF
extern int  SignalInterval=-1; // Time in Seconds between two signals, < 0 every time; Max<Period()
extern int PercentCoincidence=80; // Give signal only above this value (range 1...99)

int N1,N2,N3,N4,N5,N6,N7,N8;
double T1[],T2[],T3[],T4[],T5[],T6[],T7[],T8[]; //---- buffers
int I,J;
datetime LastSignalTime;
int CoincidenceUP,CoincidenceDOWN;
double mBid;

void ArrowUP(color ArrowColor) // Show Signal BUY
{ string Name=TimeToStr(iTime(NULL,0,0),TIME_DATE)+"="+TimeToStr(iTime(NULL,0,0),TIME_MINUTES);
  if ( ObjectFind(Name)>=0 ) return;
  ObjectCreate(Name,OBJ_ARROW,0,iTime(NULL,0,0),0.999*iLow(NULL,0,0));
  ObjectSet(Name,OBJPROP_ARROWCODE,241); ObjectSet(Name,OBJPROP_COLOR,ArrowColor); ObjectSet(Name,OBJPROP_WIDTH,3);
  if ( SignalAudio ) Alert(Name+" : BUY_"+Symbol()+"_@_="+DoubleToStr(iHigh(NULL,0,0),Digits));
  else if ( SignalLog ) Print(Name+" : BUY_"+Symbol()+"_@_="+DoubleToStr(iHigh(NULL,0,0),Digits));
  switch (ArrowColor)
  { case Lime : { ObjectSetText(Name,"BUY_@_="+DoubleToStr(iHigh(NULL,0,0),Digits)); break; }
    case Yellow : { ObjectSetText(Name,"SUPPORT="+DoubleToStr(iLow(NULL,0,0),Digits)); break; }
  }
}

void ArrowDOWN(color ArrowColor) // Show Signal SELL
{ string Name=TimeToStr(iTime(NULL,0,0),TIME_DATE)+"="+TimeToStr(iTime(NULL,0,0),TIME_MINUTES);
  if ( ObjectFind(Name)>=0 ) return;
  ObjectCreate(Name,OBJ_ARROW,0,iTime(NULL,0,0),1.004*iHigh(NULL,0,0));
  ObjectSet(Name,OBJPROP_ARROWCODE,242); ObjectSet(Name,OBJPROP_COLOR,ArrowColor); ObjectSet(Name,OBJPROP_WIDTH,3);
  if ( SignalAudio ) Alert(Name+" : SELL_"+Symbol()+"_@_="+DoubleToStr(iLow(NULL,0,0),Digits));
  else if ( SignalLog ) Print(Name+" : SELL_"+Symbol()+"_@_="+DoubleToStr(iLow(NULL,0,0),Digits));
  switch (ArrowColor)
  { case Red : { ObjectSetText(Name,"SELL_@_="+DoubleToStr(iLow(NULL,0,0),Digits)); break; }
    case Yellow : { ObjectSetText(Name,"RESISTANCE="+DoubleToStr(iHigh(NULL,0,0),Digits)); break; }
  }
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{ SetIndexBuffer(0,T1); SetIndexBuffer(1,T2); SetIndexBuffer(2,T3); SetIndexBuffer(3,T4);
  SetIndexBuffer(4,T5); SetIndexBuffer(5,T6); SetIndexBuffer(6,T7); SetIndexBuffer(7,T8);
  SetIndexLabel(0,"MOOD_"+N1+" "); SetIndexLabel(1,"MOOD_"+N2+" "); SetIndexLabel(2,"MOOD_"+N3+" "); SetIndexLabel(3,"MOOD_"+N4+" ");
  SetIndexLabel(4,"MOOD_"+N5+" "); SetIndexLabel(5,"MOOD_"+N6+" "); SetIndexLabel(6,"MOOD_"+N7+" "); SetIndexLabel(7,"MOOD_"+N8+" ");
  IndicatorDigits(2);
  LastSignalTime=0;
  N1=1*TimeMX;
  N2=2*TimeMX;
  N3=3*TimeMX;
  N4=4*TimeMX;
  N5=5*TimeMX;
  N6=6*TimeMX;
  N7=7*TimeMX;
  N8=8*TimeMX;
  return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{ return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{ if ( PercentCoincidence<=0 ) { Alert(" WARNING : PercentCoincidence must be > 0 !"); return; }
  if ( PercentCoincidence>=100 ) { Alert(" WARNING : PercentCoincidence must be < 100 !"); return; }
  if ( TimeMX<=0 ) { Alert(" WARNING : TimeMX must be > 0 !!! ====="); return; }
  if ( SignalInterval>=Period() ) { Alert(" WARNING : SignalInterval must be < "+Period()+" !"); return; }

  int counted_bars=IndicatorCounted();
  if (counted_bars<0) return(-1);
  if (counted_bars>0) counted_bars--;

  int I0=Bars-counted_bars;

// N8
  I=I0;
  while ( I>=0 )
  { T8[I]=0; J=0;
    while ( J<N8 )
    { T8[I]=T8[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T8[I]=T8[I]+iClose(NULL,0,I);
    I--; }
// N7
  I=I0;
  while ( I>=0 )
  { T7[I]=0; J=0;
    while ( J<N7 )
    { T7[I]=T7[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T7[I]=T7[I]+iClose(NULL,0,I);
    I--; }
// N6
  I=I0;
  while ( I>=0 )
  { T6[I]=0; J=0;
    while ( J<N6 )
    { T6[I]=T6[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T6[I]=T6[I]+iClose(NULL,0,I);
    I--; }
// N5
  I=I0;
  while ( I>=0 )
  { T5[I]=0; J=0;
    while ( J<N5 )
    { T5[I]=T5[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T5[I]=T5[I]+iClose(NULL,0,I);
    I--; }
// N4
  I=I0;
  while ( I>=0 )
  { T4[I]=0; J=0;
    while ( J<N4 )
    { T4[I]=T4[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T4[I]=T4[I]+iClose(NULL,0,I);
    I--; }
// N3
  I=I0;
  while ( I>=0 )
  { T3[I]=0; J=0;
    while ( J<N3 )
    { T3[I]=T3[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T3[I]=T3[I]+iClose(NULL,0,I);
    I--; }
// N2
  I=I0;
  while ( I>=0 )
  { T2[I]=0; J=0;
    while ( J<N2 )
    { T2[I]=T2[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T2[I]=T2[I]+iClose(NULL,0,I);
    I--; }
// N1
  I=I0;
  while ( I>=0 )
  { T1[I]=0; J=0;
    while ( J<N1 )
    { T1[I]=T1[I]+iHigh(NULL,0,I+J)-iLow(NULL,0,I+J+1)+iLow(NULL,0,I+J)-iHigh(NULL,0,I+J+1);
      J++; }
    T1[I]=T1[I]+iClose(NULL,0,I);
    I--; }

  CoincidenceDOWN=(T8[0]>T7[0])+(T8[0]>T6[0])+(T8[0]>T5[0])+(T8[0]>T4[0])+(T8[0]>T3[0])+(T8[0]>T2[0])+(T8[0]>T1[0])
                 +(T7[0]>T6[0])+(T7[0]>T5[0])+(T7[0]>T4[0])+(T7[0]>T3[0])+(T7[0]>T2[0])+(T7[0]>T1[0])+(T6[0]>T5[0])
                 +(T6[0]>T4[0])+(T6[0]>T3[0])+(T6[0]>T2[0])+(T6[0]>T1[0])+(T5[0]>T4[0])+(T5[0]>T3[0])+(T5[0]>T2[0])
                 +(T5[0]>T1[0])+(T4[0]>T3[0])+(T4[0]>T2[0])+(T4[0]>T1[0])+(T3[0]>T2[0])+(T3[0]>T1[0])+(T2[0]>T1[0]);
  CoincidenceUP=(T8[0]<T7[0])+(T8[0]<T6[0])+(T8[0]<T5[0])+(T8[0]<T4[0])+(T8[0]<T3[0])+(T8[0]<T2[0])+(T8[0]<T1[0])
               +(T7[0]<T6[0])+(T7[0]<T5[0])+(T7[0]<T4[0])+(T7[0]<T3[0])+(T7[0]<T2[0])+(T7[0]<T1[0])+(T6[0]<T5[0])
               +(T6[0]<T4[0])+(T6[0]<T3[0])+(T6[0]<T2[0])+(T6[0]<T1[0])+(T5[0]<T4[0])+(T5[0]<T3[0])+(T5[0]<T2[0])
               +(T5[0]<T1[0])+(T4[0]<T3[0])+(T4[0]<T2[0])+(T4[0]<T1[0])+(T3[0]<T2[0])+(T3[0]<T1[0])+(T2[0]<T1[0]);

  if ( LastSignalTime+SignalInterval<TimeCurrent() )
  { if ( CoincidenceUP>=CoincidenceDOWN || PercentCoincidence<50 )
    { mBid=iLow(NULL,0,1);
      if ( ( T8[0]>mBid && T7[0]>mBid && T6[0]>mBid && T5[0]>mBid && T4[0]>mBid && T3[0]>mBid && T2[0]>mBid && T1[0]>mBid ) )
           { ArrowUP(Lime); LastSignalTime=TimeCurrent(); return; }
      if ( CoincidenceUP>=PercentCoincidence*28/100 )
           {  ArrowUP(Yellow); LastSignalTime=TimeCurrent(); return; }
    }
    if ( CoincidenceDOWN>=CoincidenceUP || PercentCoincidence<50 )
    { mBid=iHigh(NULL,0,1);
      if ( ( T8[0]<mBid && T7[0]<mBid && T6[0]<mBid && T5[0]<mBid && T4[0]<mBid && T3[0]<mBid && T2[0]<mBid && T1[0]<mBid ) )
           { ArrowDOWN(Red); LastSignalTime=TimeCurrent(); return; }
      if ( CoincidenceDOWN>=PercentCoincidence*28/100 )
           {  ArrowDOWN(Yellow); LastSignalTime=TimeCurrent(); return; }
    }
  }
}
//+------------------------------------------------------------------+