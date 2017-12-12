//+------------------------------------------------------------------+
//|                                                    EA_ROLL_2.mq4 |
//|                                     Copyright 2013,    drivermql |
//|                       drivermql@mail.ru  http://stavmany.ru/forex|
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, stavmany.ru"
#property link      "drivermql@mail.ru  http://stavmany.ru/forex/"
extern double Lots         = 0.01;         
extern int    TakeProfit   = 50;            
extern int    Step         = 150;              
extern double Multiolier   = 1.5;            
extern int    Magic        = 18082013;   
extern int    Slippage     = 10;             
int ticket ;           
extern int    MaxOrders    = 50;                    
double price, TP, LastLot, minprice, maxprice, LastLots, dev1,dev2; 
                
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
 int init()
  {
  if (Digits == 3 || Digits == 5)
  {
  TakeProfit *= 10;
  Step       *= 10;
  Slippage   *= 10;
  }
    return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {

   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//+----------------Загружаем данные из индикатора Deviation---------------------------------------------+  
     dev1 = iCustom(Symbol(),30,"Deviation",2,0); // Максимальное отклонение вверх
     dev2 = iCustom(Symbol(),30,"Deviation",4,0); // Максимальное отклонение вниз

    
     // minprice = NormalizeDouble(GetMinPrice(),Digits);
    //  maxprice = NormalizeDouble(GetMaxPrice(),Digits);

//+----------------Блок; 1---------------------------------------------+    
          
          
          if (Ask<=dev2 && CountTrades()==0)
          {
              ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, 0, 0, "makaka-buy", Magic,0, Blue);
              if (ticket > 0)
              {
                  TP = NormalizeDouble(Ask + TakeProfit * Point, Digits);
                  OrderModify(ticket, OrderOpenPrice(), 0, TP, 0);
              }
           }
           if(Bid>=dev1 && CountTrades()==0)
           {
                   ticket =OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, 0, 0, "makaka-sell", Magic, 0, Red); 
                   if (ticket > 0)
                   {
                       TP = NormalizeDouble(Bid - TakeProfit * Point, Digits);
                       OrderModify(ticket, OrderOpenPrice(), 0, TP, 0);
                   }
            }
       
       
 //+---------------------- Блок; 3-----------------------------------+
         if(CountTrades() > 0 && CountTrades() < MaxOrders)
         {   
            int order_type = FindLastOrderType();
            if(order_type == OP_BUY)
            {
 //+---------------------- Блок; 4-----------------------------------+
                price = FindLastPrice(OP_BUY);
                if (Ask <= price-Step * Point)
                {

                  LastLots = FindLastLots (OP_BUY); 
                  if (LastLots <= 0) return;                               //-------------Блок: 5--------------------//
                  LastLots = NormalizeDouble(LastLots * Multiolier, 2);                              
                  ticket = OrderSend(Symbol(), OP_BUY, LastLots, Ask, Slippage, 0, 0, "", Magic, 0, Blue);
                  if (ticket > 0)
                  ModifyOrders(OP_BUY);
                }
             } 
      
           else   if(order_type == OP_SELL)
           {
                price = FindLastPrice(OP_SELL);
                if (Bid >= price+Step * Point)
                {
                    LastLots = FindLastLots (OP_SELL);
                    if (LastLots <= 0) return;                                //-------------Блок: 5--------------------//
                    LastLots = NormalizeDouble(LastLots * Multiolier, 2);                              
                    ticket = OrderSend(Symbol(), OP_SELL, LastLots, Bid, Slippage, 0, 0, "", Magic, 0, Red);
                    if (ticket > 0)
                    ModifyOrders(OP_SELL);
               }
            }
           } 
 return(0);
 }
//+----------- Блок; 6----------------------------------------------+
 void ModifyOrders(int otype)
{
     double avgprice = 0, order_lots=0, price = 0; 

     for(int i=OrdersTotal()-1; i>=0; i--)
     {
         if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES))
         {
             if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == otype)
             {
                 price += OrderOpenPrice() * OrderLots();
                 order_lots += OrderLots();

             }

         }
     }
     avgprice = NormalizeDouble(price / order_lots, Digits);
     if (otype == OP_BUY)
     TP = NormalizeDouble(avgprice + TakeProfit * Point, Digits);
     if (otype == OP_SELL)
     TP = NormalizeDouble(avgprice - TakeProfit * Point, Digits);
     for (i=OrdersTotal()-1; i>=0; i--)
     {
          if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES))
          {
              if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == otype)
              OrderModify(OrderTicket(),OrderOpenPrice(), 0, TP, 0);
          }
     }
}
//+-----------Продолжение Блока; 5-----------------------------------+
double FindLastLots(int otype)
{
       double oldlots; 
       int oldticket;
       ticket = 0;
       
       for(int i = OrdersTotal()-1; i>=0; i--)
       {
           if(OrderSelect (i, SELECT_BY_POS, MODE_TRADES))
           {
              if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == otype)
              {
                  oldticket = OrderTicket();
                  if(oldticket > ticket)
                  {
                    oldlots = OrderLots();
                    ticket = oldticket;

                  }
              }
           }
       }
       return(oldlots);
}
 
//+-----------Продолжение Блока; 4-----------------------------------+ 
  double FindLastPrice(int otype)  
{
        double oldopenprice;  
        int    oldticket;    
        ticket = 0;         

        for(int i = OrdersTotal()-1; i>=0; i--) 
        {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))  
            {
                if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == otype)  
                {
                    oldticket = OrderTicket();  
                    if(oldticket > ticket)      
                    {
                       oldopenprice = OrderOpenPrice();   
                       ticket = oldticket;                
                     }
                }
            }
        }
        return(oldopenprice);
 }

 
//+-----------Продолжение Блока; 3-----------------------------------+
 int FindLastOrderType()                               
{
     for(int i=OrdersTotal()-1;i>=0;i--)                           
     {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))                  
         {
             if(OrderSymbol()==Symbol()&&OrderMagicNumber()==Magic)        
             return(OrderType());                                      
         }
      }
            return(-1);
 } 
    
//+-----------Продолжение Блока; 2-----------------------------------+ 
/*double GetMinPrice()  
  {
         double dLow = 100000,
                minprice;
       
         for (int i=1; i<=BarCount; i++)
         { 
              minprice = iLow(Symbol(),0,i);
              if (minprice < dLow)
              dLow = minprice;
         } 
         return(dLow);
   }
 //+------------------------------------------------------------------+
     double GetMaxPrice() 
 {      
       double dHigh = 0,
              maxprice;
       for (int i=1; i<=10; i++)
       {
       maxprice = iHigh(Symbol(),0, i);
       if (maxprice > dHigh)
           dHigh = maxprice;
       }
       return(dHigh);
  }*/
 
 //+-----------Продолжение Блока; 1-----------------------------------+ 
int CountTrades()
{
    int count = 0;
    for (int i = OrdersTotal()-1; i>=0; i--)
    {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES ))
         {
             if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
             count++; 
         }
    }
        return(count);
}
 //+------------------------------------------------------------------+
   