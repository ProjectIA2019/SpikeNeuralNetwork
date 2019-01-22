int potentiometerPin = 0; //Pin Potenziometro A0
int value = 0;            //Valore del potenziometro
float tau = 0.02;         //Quantizzazione
float t = 0;              //Tempo
float v = -70;            //Potenziale membrana a riposo -70mV
float u = -20;              //Ripristino membrana -20mV

int BOTTON_SPIKE = 2;     //Bottone settaggio modalità di spike
int BOTTON_POT = 6;       //Bottone per disattivare o attivare l'uso del potenziometro
int mod = 0;              //Modalità attuale(settato a 0 = Tonic Spiking)
int LED_MOD = 5;          //LED modalità eccitatoria/inibitoria
int pot_disable = 1;      //Variabile per verificare se il potenziometro e disabilitato o no
int LED_POT = 7;          //LED per verificare l'attivazione del potenziometro

int buzzerPIN = 4;        //Buzzer per identificare lo spike

float a = 0.02;           //Scala temporale di u
float b = 0.2;            //Sensibilità di recupero
int c = -65;              //Valore di ripristino dopo il picco v
float d = 6;              //Ripristino di u dopo il picco
float i = 14;             //Corrente di sinapsi

String OutputStr = ""; //Valori di output da accumulare per essere lettu sull'oscilloscopio

void setup()
{
  Serial.begin(234000); // Inizializzazione porta seriale a 234000

  //Settaggio bottone e modalità spike
  pinMode(BOTTON_SPIKE,INPUT);
  pinMode(BOTTON_POT, INPUT);
  mod = 0;
  pot_disable = 0;

  pinMode(buzzerPIN, OUTPUT);
  pinMode(LED_MOD, OUTPUT);
  pinMode(LED_POT, OUTPUT);
  
  digitalWrite(LED_MOD,HIGH);
  digitalWrite(LED_POT,HIGH);
}

void loop()
{
  if(digitalRead(BOTTON_POT) == HIGH)
  {
    pot_disable += 1;
    if(pot_disable > 1)
    {
      pot_disable = 0;
    }
    delay(150);
  }

//---------------SPIKE MODE--------------------------------  
  //Controllo sul bottone per vedere la modalità attivata
  if(digitalRead(BOTTON_SPIKE)==HIGH)
  {
    tone(buzzerPIN, 500, 2); //Il buzzer suona
    mod += 1;
    if(mod > 11)
    {
      mod = 0;
    }

    //Accendiamo il led quando sono presenti modi eccitatori e lo spegniamo quando i modi sono inibitori
    if(mod > 9)
    {
      digitalWrite(LED_MOD,LOW);
    }
    else
    {
      digitalWrite(LED_MOD,HIGH);
    }
    delay(150);
  }

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
//--------------------------------------------------------------
  
  value = analogRead(potentiometerPin) - 512; // Lettura valore potenziometro

  //------------Modello Di Izhikevich---------------------------
  //Controllo del potenziometro se è attivo o meno
  //Se il potenziomnetro è attivo viene letto, altrimenti gli viene dato un valore
  //indicativo alla corrente
  if(pot_disable == 0)
  {
    //Potenziometro attivo
    digitalWrite(LED_POT,HIGH);
    v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + value);
  }
  else
  {
    //Potenziometro non attivo
    digitalWrite(LED_POT,LOW);
    v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + i);
  }  
  
  u +=  tau * a * (b * v - u);
  //------------------------------------------------------------

  OutputStr += v; //Linea verde oscilloscopio
  OutputStr += ", ";
  
  if(pot_disable == 0)
  {
    //Potenziometro attivo
    OutputStr += value; //Linea rossa oscilloscopio
  }
  else
  {
    //Potenziometro non attivo
    OutputStr += i  ; //Linea rossa oscilloscopio
  }
  
  OutputStr += ", ";
  OutputStr += u; //Linea blu oscilloscopio
  Serial.println(OutputStr); // Stampo valori calcolati e li proietto sull'oscilloscopio

  //Controllo di picco per eventuale spike
  if(v > 30)
  {
    tone(buzzerPIN, 1000, 2); //Il buzzer suona
    v = c;
    u += d;
  }
  //Controllo per non farlo scendere sotto la soglia di "Potenziale di membrana a riposo"
  if(v < -80)
  {
    v = -80;
  }
  
  t = t + tau;
  OutputStr = "";
  
  delay(2); //Attesa di 2 ms
}
