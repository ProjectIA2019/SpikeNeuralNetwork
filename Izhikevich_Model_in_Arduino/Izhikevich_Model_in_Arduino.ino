int potentiometerPin = 0; //Pin Potenziometro A0
int value = 0; //Valore del potenziometro
float tau = 0.02; //Quantizzazione
float t = 0; //Tempo
float v = -70; //Potenziale membrana a riposo -70mV
int u = -20; //Ripristino membrana -20mV

float a = 0.02; //Scala temporale di u
float b = 0.2; //Sensibilità di recupero
int c = -65; //Valore di ripristino dopo il picco v
int d = 6; //Ripristino di u dopo il picco

String OutputStr = ""; //Valori di output da accumulare per essere lettu sull'oscilloscopio

void setup()
{
  Serial.begin(234000); // Inizializzazione porta seriale a 234000
}

void loop()
{    
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
