/*
  Pietro Rignanese & Andrea Polenta
  Spiking Neural Network
  
  Intelligenza Artificiale
  
  Università Politecnica delle Marche
*/

float a = 0.02;           //Scala temporale di u
float b = 0.2;            //Sensibilità di recupero
int c = -65;              //Valore di ripristino dopo il picco v
float d = 6;              //Ripristino di u dopo il picco
float i = 14;             //Corrente di sinapsi

float CorrI = 0;          //Corrente di sinapsi, viene salvata in un'altra variabile per farla calare lentamente

float v = -70;            //Potenziale di membrana a riposo
float u = -20;            //Recupero di membrana a riposo
float tau = 0.02;         //Quantizzazione

int SPIKE = 2;            //Spike del neurone precedente
int MOD_TAU = 4;          //Bottone per la modifica del tau [0.02,0.2,1,2]
int BOTTON_SPIKE = 6;     //Bottone settaggio modalità di spike [Tonic Spiking , Phasic Spiking , Tonic Bursting , Phasic Bursting , ...]
int mod = 0;              //Modalità attuale(settato a 0 = Tonic Spiking)
int buzzerPIN = 7;        //Buzzer

float imp_tau[] = {0.02 , 0.2 , 1 , 2};
int n = -1;

String OutputStr = "";    //Valori di output da accumulare per essere lettu sull'oscilloscopio

void setup() 
{
  pinMode(BOTTON_SPIKE,INPUT);
  pinMode(SPIKE,INPUT);
  pinMode(MOD_TAU,INPUT);
  Serial.begin(234000);

  mod = 0;
}

void loop() 
{
  //Controllo sul bottone per vedere la modalità attivata
  if(digitalRead(BOTTON_SPIKE)==HIGH)
  {
    //Resetto i valori
    v = -70;
    u = -20;
    
    tone(buzzerPIN, 500, 2); //Il buzzer suona
    mod += 1;
    if(mod > 11)
    {
      mod = 0;
    }
    delay(150);

  if(mod == 0)
  {
    Serial.println("Tonic Spiking");
    a = 0.02; //Scala temporale di u
    b = 0.2;  //Sensibilità di recupero
    c = -65;  //Valore di ripristino dopo il picco v
    d = 6;    //Ripristino di u dopo il picco
    i = 14;
  }
  if(mod == 1)
  {
    Serial.println("Phasic Spiking");
    a = 0.02; //Scala temporale di u
    b = 0.25; //Sensibilità di recupero
    c = -65;  //Valore di ripristino dopo il picco v
    d = 6;    //Ripristino di u dopo il picco
    i = 0.5;
  }
  if(mod == 2)
  {
    Serial.println("Tonic Bursting");
    a = 0.02; //Scala temporale di u
    b = 0.2;  //Sensibilità di recupero
    c = -50;  //Valore di ripristino dopo il picco v
    d = 2;    //Ripristino di u dopo il picco
    i = 15;
  }
  if(mod == 3)
  {
    Serial.println("Phasic Bursting");
    a = 0.02; //Scala temporale di u
    b = 0.25; //Sensibilità di recupero
    c = -55;  //Valore di ripristino dopo il picco v
    d = 0.05; //Ripristino di u dopo il picco
    i = 0.6;
  }
  if(mod == 4)
  {
    Serial.println("Mixed Mode");
    a = 0.02; //Scala temporale di u
    b = 0.2;  //Sensibilità di recupero
    c = -55;  //Valore di ripristino dopo il picco v
    d = 6;    //Ripristino di u dopo il picco
    i = 10;
  }
  if(mod == 5)
  {
    Serial.println("Spike Frequency Adaption");
    a = 0.01; //Scala temporale di u
    b = 0.2;  //Sensibilità di recupero
    c = -65;  //Valore di ripristino dopo il picco v
    d = 8;    //Ripristino di u dopo il picco
    i = 30;
  }
  if(mod == 6)
  {
    Serial.println("Class 1");
    a = 0.02;   //Scala temporale di u
    b = - 0.1;  //Sensibilità di recupero
    c = -55;    //Valore di ripristino dopo il picco v
    d = 6;      //Ripristino di u dopo il picco
    i = 0;
  }
  if(mod == 7)
  {
    Serial.println("Class 2");
    a = 0.2;  //Scala temporale di u
    b = 0.26; //Sensibilità di recupero
    c = -65;  //Valore di ripristino dopo il picco v
    d = 0;    //Ripristino di u dopo il picco
    i = 0;
  }
  if(mod == 8)
  {
    Serial.println("Spike Latency");
    a = 0.02; //Scala temporale di u
    b = 0.2;  //Sensibilità di recupero
    c = -65;  //Valore di ripristino dopo il picco v
    d = 6;    //Ripristino di u dopo il picco
    i = 7;
  }
  if(mod == 9)
  {
    Serial.println("Resonator");
    a = 0.1;  //Scala temporale di u
    b = 0.26; //Sensibilità di recupero
    c = -60;  //Valore di ripristino dopo il picco v
    d = -1;   //Ripristino di u dopo il picco
    i = 0;
  }
  if(mod == 10)
  {
    Serial.println("Inhibition-induced spiking");
    a = -0.02;
    b = -1;
    c = -60;
    d = 8;
    i = 80;
  }
  if(mod == 11)
  {
    Serial.println("Inhibition-induced bursting");
    a = -0.026;
    b = -1;
    c = -45;
    d = 0;
    i = 80;
  }
  }
  
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
    OutputStr += v;
    OutputStr += " ,";
    OutputStr += i;
    CorrI = i;
  }
  else
  {
    if(CorrI < 0)
    {
      v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + 0);
      OutputStr += v;
      OutputStr += " ,";
      OutputStr += 0;
    }
    else
    {
      CorrI = CorrI - 0.05;
      v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + CorrI);
      OutputStr += v;
      OutputStr += " ,";
      OutputStr += CorrI;
    }
    
  }
  
  u +=  tau * a * (b * v - u);
  OutputStr += " ,";
  OutputStr += u;

  //Controllo di picco per eventuale spike
  if(v > 30)
  {
    tone(buzzerPIN, 2000, 2); //Il buzzer suona
    v = c;
    u += d;
  }
  //Controllo per non farlo scendere sotto la soglia di "Potenziale di membrana a riposo"
  if(v < -70)
  {
    v = -70;
  }
  
  Serial.println(OutputStr);
  OutputStr = "";

  delay(2);
}
