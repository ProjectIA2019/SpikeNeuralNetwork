int potentiometerPin = 0; //Pin Potenziometro A0
int value = 0; //Valore del potenziometro
float tau = 0.02; //Quantizzazione
float t = 0; //Tempo
float v = -70; //Potenziale membrana a riposo -70mV
int u = -20; //Ripristino membrana -20mV

int BOTTON = 2; //Bottone settaffio modalità di spike
int mod = 0;

int buzzerPIN = 4; //Buzzer per identificare lo spike

float a = 0.02; //Scala temporale di u
float b = 0.2; //Sensibilità di recupero
int c = -65; //Valore di ripristino dopo il picco v
float d = 6; //Ripristino di u dopo il picco

String OutputStr = ""; //Valori di output da accumulare per essere lettu sull'oscilloscopio

void setup()
{
  Serial.begin(234000); // Inizializzazione porta seriale a 234000

  //Settaggio bottone e modalità spike
  pinMode(BOTTON,INPUT);
  mod = 0;

  pinMode(buzzerPIN, OUTPUT);
}

void loop()
{

//---------------SPIKE MODE--------------------------------  
  //Controllo sul bottone per vedere la modalità attivata
  if(digitalRead(BOTTON)==HIGH)
  {
    tone(buzzerPIN, 500, 2); //Il buzzer suona
    mod += 1;
    if(mod > 9)
    {
      mod = 0;
    }
  }
  if(mod == 0)
  {
    Serial.println("Tonic Spiking");
    a = 0.02; //Scala temporale di u
    b = 0.2; //Sensibilità di recupero
    c = -65; //Valore di ripristino dopo il picco v
    d = 6; //Ripristino di u dopo il picco
  }
  if(mod == 1)
  {
    Serial.println("Phasic Spiking");
    a = 0.02; //Scala temporale di u
    b = 0.25; //Sensibilità di recupero
    c = -65; //Valore di ripristino dopo il picco v
    d = 6; //Ripristino di u dopo il picco
  }
  if(mod == 2)
  {
    Serial.println("Tonic Bursting");
    a = 0.02; //Scala temporale di u
    b = 0.2; //Sensibilità di recupero
    c = -50; //Valore di ripristino dopo il picco v
    d = 2; //Ripristino di u dopo il picco
  }
  if(mod == 3)
  {
    Serial.println("Phasic Bursting");
    a = 0.02; //Scala temporale di u
    b = 0.25; //Sensibilità di recupero
    c = -55; //Valore di ripristino dopo il picco v
    d = 0.05; //Ripristino di u dopo il picco
  }
  if(mod == 4)
  {
    Serial.println("Mixed Mode");
    a = 0.02; //Scala temporale di u
    b = 0.2; //Sensibilità di recupero
    c = -55; //Valore di ripristino dopo il picco v
    d = 6; //Ripristino di u dopo il picco
  }
  if(mod == 5)
  {
    Serial.println("Spike Frequency Adaption");
    a = 0.01; //Scala temporale di u
    b = 0.2; //Sensibilità di recupero
    c = -65; //Valore di ripristino dopo il picco v
    d = 8; //Ripristino di u dopo il picco
  }
  if(mod == 6)
  {
    Serial.println("Class 1");
    a = 0.02; //Scala temporale di u
    b = - 0.1; //Sensibilità di recupero
    c = -55; //Valore di ripristino dopo il picco v
    d = 6; //Ripristino di u dopo il picco
  }
  if(mod == 7)
  {
    Serial.println("Class 2");
    a = 0.2; //Scala temporale di u
    b = 0.26; //Sensibilità di recupero
    c = -65; //Valore di ripristino dopo il picco v
    d = 0; //Ripristino di u dopo il picco
  }
  if(mod == 8)
  {
    Serial.println("Spike Latency");
    a = 0.02; //Scala temporale di u
    b = 0.2; //Sensibilità di recupero
    c = -65; //Valore di ripristino dopo il picco v
    d = 6; //Ripristino di u dopo il picco
  }
  if(mod == 9)
  {
    Serial.println("Resonator");
    a = 0.1; //Scala temporale di u
    b = 0.26; //Sensibilità di recupero
    c = -60; //Valore di ripristino dopo il picco v
    d = -1; //Ripristino di u dopo il picco
  }
//--------------------------------------------------------------
  
  value = analogRead(potentiometerPin) - 512; // Lettura valore potenziometro

  //------------Modello Di Izhikevich---------------------------
  v +=  tau*(0.04 * (v * v) + (5 * v) + 140 - u + value);
  u +=  tau * a * (b * v - u);
  //------------------------------------------------------------

  OutputStr += v;
  OutputStr += ", ";
  OutputStr += value;
  Serial.println(OutputStr); // Stampo valori calcolati e li proietto sull'oscilloscopio

  //Controllo di picco per eventuale spike
  if(v > 30)
  {
    tone(buzzerPIN, 1000, 2); //Il buzzer suona
    v = c;
    u += d;
  }
  //Controllo per non farlo scendere sotto la soglia di "Potenziale di membrana a riposo"
  if(v < -75)
  {
    v = -75;
  }
  
  t = t + tau;
  OutputStr = "";
  
  delay(2); //Attesa di 2 ms
}
