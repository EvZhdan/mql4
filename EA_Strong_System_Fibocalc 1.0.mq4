//+------------------------------------------------------------------+
//|                                EA_Strong_System_Fibocalc 1.0.mq4 |
//|                                      Copyright © 2013, drivermql |
//|                                        http://stavmany.ru/forex/ |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2013, drivermql@mail.ru"
#property link      "http://stavmany.ru/forex/"

extern string    name       = "EA_Strong_System_Fibocalc 1.0";
extern string    neme       = "Новые версии на http://stavmany.ru/forex/";
extern string    crc        = "-----------------------------------------";
extern string    ccc        = "Принимаю пожертвования (доллар-два) на еду:";
extern string    cuc        = "Z411827092671, R244537751285, U636811156469";
extern string    crx        = "-----------------------------------------";
extern string    txxt       = "Параметры торговли";
extern double    lots       = 0.01;
extern int       takeprofit = 80;
extern int       stoploss   = 35;
extern int       slippage   = 3;
extern int       magic      = 112233;
extern string    tex        = "Период торговли";
extern int       hourstart  = 7;
extern int       hourend    = 16;
extern string    txe        = "Параметры =красной= МА";
extern int       MA_Period  = 8;
extern int       MA_Shift   = 0;
extern int       MA_Method  = 1;
extern string    xet        = "Параметры =тёмной= МА";
extern int       MA_Period1 = 21;
extern int       MA_Shift1  = 0;
extern int       MA_Method1 = 1;
extern string    xte        = "Параметры Signal_Fibo_M15";
extern int       FasterEMA  = 8;
extern int       SlowerEMA  = 21;




double price, sl, slfortr, tp, ma8, ma21,greenarrow,redarrow;
int ticket;


int init()
  
  //жжжжжжжжжжжжжж     УЧИТЫВАЕМ, СКОЛЬКО ЗНАКОВ ПОСЛЕ ЗАПЯТОЙ   жжжжжжжжжжжжжжжжжжжжжжжжжжжжж
  {
if (Digits == 5 || Digits == 3)
   takeprofit   *=10;
   stoploss     *=10;
   slippage     *=10;
   //trailing     *=10; // трейлинг
   //trailingstep *=10;// шаг трейлинга
   return(0);
  }

int deinit()
  {
   return(0);
                       
  }
int start()
  {
// trailing();
 if (Hour()<hourstart || Hour()>hourend) return(0);  // задаем период торговли
  {
       
  //+++++++++++++ДАННЫЕ ИЗ МАшек++++++++++++++++++++++++     
  double ma8 = iMA (Symbol(),0,MA_Period,MA_Shift,MA_Method,PRICE_CLOSE,1); // получаем данные  индикатора МА - 8
  double ma21 = iMA (Symbol(),0,MA_Period1,MA_Shift1,MA_Method1,PRICE_CLOSE,1);   // получаем данные  индикатора МА - 21
  
  //+++++++++++++ ДАННЫЕ ИЗ нижнего сине-красного индикатора+++++++++++++
    
  greenarrow = iCustom (Symbol(),0,"Signal_Fibo_M15",FasterEMA,SlowerEMA,0,0);
  redarrow   = iCustom (Symbol(),0,"Signal_Fibo_M15",FasterEMA,SlowerEMA,1,0); 
 
      //жжжжжжжжжжжжж УСЛОВИЯ ПРОДАЖИ жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
    
  if (CountSell() == 0 && CountBuy() ==0 && ma8 < ma21 && redarrow > 0 && (Close[1]> ma21 || Close[2]> ma21))
   
   {
     sl = NormalizeDouble(Bid + stoploss * Point,Digits); // делаем стоп лосс в выражении цены
     tp = NormalizeDouble(Bid - takeprofit *Point,Digits); // то же с тейком
     
     ticket = OrderSend (Symbol(),OP_SELL,lots,Bid,slippage,0,0,name,magic,0,Red);
     if (ticket>0)
     {
       if (OrderSelect (ticket,SELECT_BY_TICKET,MODE_TRADES) == true) // выбираем ордер для модицикации
           OrderModify (ticket,OrderOpenPrice(),sl,tp,0); // модифицируем СЛ и ТП для ЕСН счетов
           
           }
        }
     
 //жжжжжжжжжжжжжжжжжжж    УСЛОВИЯ ДЛЯ ПОКУПКИ   жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
  
   if (CountBuy() ==0 &&  CountSell() == 0 && ma8 > ma21 && greenarrow > 0 && (Close[1]< ma21 || Close[2]< ma21))
   {
     sl = NormalizeDouble(Ask - stoploss * Point,Digits); // делаем стоп лосс в выражении цены
     tp = NormalizeDouble(Ask + takeprofit *Point,Digits); // то же с тейком
     
     ticket = OrderSend (Symbol(),OP_BUY,lots,Ask,slippage,0,0,name,magic,0,Green);
     if (ticket>0)
     {
       if (OrderSelect (ticket,SELECT_BY_TICKET,MODE_TRADES) == true) // выбираем ордер для модицикации
           OrderModify (ticket,OrderOpenPrice(),sl,tp,0); // модифицируем СЛ и ТП для ЕСН счетов
          
           }
        }
     }
   
   return(0);
  }
//жжжжжжжжжжжжжжжжж   ПЕРЕСЧИТЫВАЕМ ОРДЕРА БАЙ жжжжжжжжжжжжжжжжжжжжжжж
int CountBuy ()
{
   int count = 0;
   for (int trade = OrdersTotal ()-1;trade>=0; trade--)
   {
     OrderSelect (trade, SELECT_BY_POS, MODE_TRADES);
     if (OrderSymbol ()==Symbol () && OrderMagicNumber ()==magic)
      {
        if (OrderType ()==OP_BUY)
        count++;
      }
    }
     return (count);
}

 //жжжжжжжжжжжжжж   СЧИТАЕМ ОРДЕРА СЕЛЛ   жжжжжжжжжжжжжжжжжжжжж 

int CountSell ()
{
   int count = 0;
   for (int trade = OrdersTotal ()-1;trade>=0; trade--)
   {
     OrderSelect (trade, SELECT_BY_POS, MODE_TRADES);
     if (OrderSymbol ()==Symbol () && OrderMagicNumber ()==magic)
      {
        if (OrderType ()==OP_SELL)
        count++;
      }
    }
    
    return (count);
 }
/*
//жжжжжжжжжжжжжжж БЛОК ВКЛЮЧЕНИЯ ТРЕЙЛИНГ-СТОПА   жжжжжжжжжжжжжжжжжжжжжж
void trailing()
{
 for (int i=0; i<OrdersTotal(); i++)
 {
    if (OrderSelect (i, SELECT_BY_POS,MODE_TRADES))
       {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
         {
            if (OrderType() == OP_BUY)
            {
                if (Bid - OrderOpenPrice() > trailing*Point)
                {
                   if (OrderStopLoss() < Bid - (trailing + trailingstep)*Point)
                   {
                      slfortr = NormalizeDouble(Bid - trailing*Point, Digits);
                      if (OrderStopLoss()!=slfortr)
                      OrderModify (OrderTicket(), OrderOpenPrice(),slfortr,0,0);
                    }
                }
            }
             if (OrderType() == OP_SELL)
            {
              if (OrderOpenPrice() - Ask >trailing*Point)
              {
                 if (OrderStopLoss () >Ask + (trailing + trailingstep)*Point)
                 {
                   slfortr = NormalizeDouble(Ask + trailing*Point,Digits);
                   if (OrderStopLoss()!=slfortr)
                   OrderModify (OrderTicket(), OrderOpenPrice(),slfortr,0,0);
                 
                          }
                        }
                      }
                    }
                  }
                }
             }
 //жжжжжжжжжжжжжжжжж  КОНЕЦ БЛОКА ТРЕЙЛИНГ СТОПА  жжжжжжжжжжжжжжжжжжжжжжжжжжж
 */