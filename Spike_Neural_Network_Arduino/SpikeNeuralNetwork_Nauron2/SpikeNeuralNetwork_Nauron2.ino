/*
  Pietro Rignanese & Andrea Polenta
  Spike Neural Network in Arduino
  Gennaio 2019
  Inetlligenza artificiale
  UNIVPM
*/

float a = 0.02;           //Scala temporale di u
float b = 0.2;            //Sensibilità di recupero
int c = -65;              //Valore di ripristino dopo il picco v
float d = 6;              //Ripristino di u dopo il picco
float i = 14;             //Corrente di sinapsi

float v = -70;
float u = -20;
float tau = 0.02;

int SPIKE = 2;            //Spike del neurone precedente
int MOD_TAU = 4;          //Bottone per la modifica del tau [0.02,0.2,1,2]

float imp_tau[] = {0.02 , 0.2 , 1 , 2};
int n = -1;

String OutputStr = "";

void setup() 
{
  pinMode(SPIKE,INPUT);
  pinMode(MOD_TAU,INPUT);
  Serial.begin(234000);
}

void loop() 
{
  //Verifica modifica tau
  if(digitalRead(MOD_TAU)==HIGH)
  {
    n += 1;
    if(n >  3)
    {
      n = 0;
    }
    tau = imp_tau[n];
    delay(20);
  }

  //Verifica arrivo spike neurone precedente
  if(digitalRead(SPIKE)==HIGH)
  {
    Serial.println("SPIKE");
    v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + i);
  }
  else
  {
    v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + 0);
  }
  OutputStr += v;
  OutputStr += " ,";
  u +=  tau * a * (b * v - u);
  OutputStr += 0;
  OutputStr += " ,";
  OutputStr += u;

  //Controllo di picco per eventuale spike
  if(v > 30)
  {
    //tone(buzzerPIN, 1000, 2); //Il buzzer suona
    v = c;
    u += d;
  }
  //Controllo per non farlo scendere sotto la soglia di "Potenziale di membrana a riposo"
  if(v < -80)
  {
    v = -80;
  }
  
  Serial.println(OutputStr);
  OutputStr = "";

  delay(2);
}
