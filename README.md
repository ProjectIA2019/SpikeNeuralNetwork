# SpikeNeuralNetwork

## Neurone
<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/1024px-Neuron.svg.png"/>

## Programma In Arduino
[Qui](https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Izhikevich_Model_in_Arduino/Izhikevich_Model_in_Arduino.ino) è presente il programma in arduino, in cui attraverso:<br>
1. N° 1 potenziometro andiamo a modificare la corrente inniettata(corrente di sinapsi)in moda da vedere l'andamento su un'oscilloscopio digitale, realizzato da [Baden Lab](https://github.com/BadenLab), in cui vediamo l'andamento della corrente(in verde) e quello del potenziale di membrana(in rosso) man mano che la corrente di sinapsi aumenta e diminuisce; <br>
2. N° 1 bottone per settera le varie modalità di spike, che vanno a differire in base a diversi valori; <br>
3. N° 1 buzzer per far emettere un suono acustico ogni volta che si presenta uno spike.<br>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Screen/screen%20oscilloscopio.png"/>

Come possiamo vedere dallo screen soprariportato: man mano che la corrente aumenta, il potenziale di membrana supera la tensione di soglia e innesca lo spike.
Man mano che la corrente dimuisce lo spike risulta essere meno presente.

Quindi la corrente, man mano che aumenta, aumenta la fequenza di scarica(aumenta il numero dei potenziali d'azione del neurone) e, man mano che diminuisce(fino a riportare il potenziale di membrana a riposo, cioè -70mV), diminuisce la frequenza di scarica.

Ecco il semplice schema, realizzato con Arduino, per verificare lo spike e il funzionamento del neurone al variare della corrente di innesco:


<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/IMG_20190119_142220(2).png"/>




## Programma in Prolog



### Progetto di Intelligenza Artificiale
Pietro Rignanese & Andrea Polenta 
Università politecnica delle marche

Anno 2018/2019

Intelligenza artificiale


Fonti: https://github.com/BadenLab/Spikeling
