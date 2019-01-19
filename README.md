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

Mod Izhikevich's Spike Model

    // From Iziekevich.org - see also https://www.izhikevich.org/publications/figure1.pdf:
    //      0.02      0.2     -65      6       14 ;...    % tonic spiking
    //      0.02      0.25    -65      6       0.5 ;...   % phasic spiking
    //      0.02      0.2     -50      2       15 ;...    % tonic bursting
    //      0.02      0.25    -55     0.05     0.6 ;...   % phasic bursting
    //      0.02      0.2     -55     4        10 ;...    % mixed mode
    //      0.01      0.2     -65     8        30 ;...    % spike frequency adaptation
    //      0.02      -0.1    -55     6        0  ;...    % Class 1
    //      0.2       0.26    -65     0        0  ;...    % Class 2
    //      0.02      0.2     -65     6        7  ;...    % spike latency
    //      0.05      0.26    -60     0        0  ;...    % subthreshold oscillations
    //      0.1       0.26    -60     -1       0  ;...    % resonator
    //      0.02      -0.1    -55     6        0  ;...    % integrator
    //      0.03      0.25    -60     4        0;...      % rebound spike
    //      0.03      0.25    -52     0        0;...      % rebound burst
    //      0.03      0.25    -60     4        0  ;...    % threshold variability
    //      1         1.5     -60     0      -65  ;...    % bistability
    //        1       0.2     -60     -21      0  ;...    % DAP
    //      0.02      1       -55     4        0  ;...    % accomodation
    //     -0.02      -1      -60     8        80 ;...    % inhibition-induced spiking
    //     -0.026     -1      -45     0        80];       % inhibition-induced bursting




## Programma in Prolog



### Progetto di Intelligenza Artificiale
Pietro Rignanese & Andrea Polenta 
Università politecnica delle marche

Anno 2018/2019

Intelligenza artificiale


Fonti: https://github.com/BadenLab/Spikeling
