//+------------------------------------------------------------------+
//|                                                        SMA21.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                    VARIABLES EXTERNAS
//+------------------------------------------------------------------+
input string Valores_Media_Movil = "-------------------- Media_Móvil";
extern ENUM_MA_METHOD Tipo_Media = MODE_SMA;
extern ENUM_APPLIED_PRICE Tipo_Precio = PRICE_CLOSE;
extern ENUM_TIMEFRAMES Temporalidad = PERIOD_CURRENT;
extern int Periodo_SMA = 21;
//+------------------------------------------------------------------+
//|                    VARIABLES GLOBALES
//+------------------------------------------------------------------+
double valor_sma = 0;
bool cruce_alcista = false,
     cruce_bajista = false;
int contador = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   valor_sma = iMA(_Symbol, Temporalidad, Periodo_SMA, 0, Tipo_Media, Tipo_Precio, 0); // COGER EL VALOR DE LA SMA
//---
   if(Close[1] > valor_sma && Open[1] < valor_sma && !cruce_alcista) // PARA DETERMINAR EL CRUCE ALCISTA DEL PRECIO Y LA SMA
   {
      cruce_alcista = true;
      cruce_bajista = false;
   }
   if(Close[1] < valor_sma && Open[1] > valor_sma && !cruce_bajista) // PARA DETERMINAR EL CRUCE BAJISTA DEL PRECIO Y LA SMA
   {
      cruce_bajista = true;
      cruce_alcista = false;
   }
//---
}// FIN DEL ONTICK
//+------------------------------------------------------------------+
int Contador_Velas_Alcistas (double _valor, int _cont, string _tipo)
// CONTAR LAS VELAS QUE ESTEN POR ENCIMA DE LA SMA DE 21 DESPUES DE QUE OCURRA UN CRUCE
{
   if(_tipo == "alza")
   {
      for(int i = 1; i < 7; i++)
      {
         if(Close[1] > _valor)
         {
            _cont ++;
         }
         else if(Close[1] < _valor)
         {
            _cont = 0;
         }
      }
   }
   else  if(_tipo == "baja")
   {
      for(int i = 1; i < 7; i++)
      {
         if(Close[1] < _valor)
         {
            _cont ++;
         }
         else if(Close[1] > _valor)
         {
            _cont = 0;
         }
      }
   }
   return _cont;
}

//+------------------------------------------------------------------+
