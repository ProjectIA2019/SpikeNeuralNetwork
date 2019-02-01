# Spiking Neural Network

## <a name="ancora-indice"></a>Indice
* <a href="#ancora-neurone">1. Neurone</a>
* <a href="#ancora-progarduino">2. Programma Arduino</a>
    * <a href="#ancora-singneuron">Singolo Neurone</a>
    * <a href="#ancora-dupneuron">Catena Neuroni: coppia</a>
 * <a href="#ancora-modizhikevich">3. Modello Izhikevich</a>
 * <a href="#ancora-progprolog">4. Programma Prolog</a>
    * <a href="#ancora-prologsing">Singolo Neurone</a>
    * <a href="#ancora-prologtre">Catena Neuroni</a>
         * <a href="#ancora-prologtredorm">Neuroni "Sleepy"</a>
            * <a href="#ancora-plotsleep">Plotting</a>
         * <a href="#ancora-prologtrewake">Neuroni "Awake"</a>
            * <a href="#ancora-plotwake">Plotting</a>

## <a name="ancora-neurone"></a>Neurone
<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/1024px-Neuron.svg.png"/>

Parti del neurone:
* Soma
* Dendriti
* Nucleo
* Assone
* Guaina Melinica
* Terminale

__________________________________________________________________________________________

In questo progetto di inettligenza artificiale si è implemenmtato un neurone sintetico(simile al neurone biologico) con il modello di Izhikevich, in Arduino e SWI-Prolog, e successivamente si è creata una Spike Neural Network(una catena di neuroni collegato tra loro) per studiarne il funzionamento.

*Cos'è una spiking neural network?*

Una SNN è una rete artificiale ad impulso che emula il comportamento della rete neuronale naturale.

_____________________________________________________________________________________________

## <a name="ancora-progarduino"></a>Programma In Arduino

### <a name="ancora-singneuron"></a>Singolo Neurone
[Qui](https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Izhikevich_Model_in_Arduino/Izhikevich_Model_in_Arduino.ino) è presente il programma in arduino, in cui attraverso:<br>
1. N° 1 potenziometro andiamo a modificare la corrente inniettata(corrente di sinapsi)in moda da vedere l'andamento su un'oscilloscopio digitale, realizzato da [Baden Lab](https://github.com/BadenLab), in cui vediamo l'andamento della corrente(in verde) e quello del potenziale di membrana(in rosso) man mano che la corrente di sinapsi aumenta e diminuisce; <br>
2. N° 1 bottone per settera le varie modalità di spike, che vanno a differire in base a diversi valori; <br>
3. N° 1 bottone per abilitare/disabilitare il potenziometro come corrente iniettiva; <br>
3. N° 1 buzzer per far emettere un suono acustico ogni volta che si presenta uno spike.<br>
4. N° 2 led per verificare se il potenziometro è attivo[LED VERDE acceso] e in che modalità ci troviamo(inibitoria[LED ROSSO spento] o eccitatoria[LED ROSSO acceso])

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Screen/screen%20oscilloscopio.png"/>

Come possiamo vedere dallo screen soprariportato: man mano che la corrente aumenta, il potenziale di membrana supera la tensione di soglia e innesca lo spike.
Man mano che la corrente dimuisce lo spike risulta essere meno presente.

Quindi la corrente, man mano che aumenta, aumenta la fequenza di scarica(aumenta il numero dei potenziali d'azione del neurone) e, man mano che diminuisce(fino a riportare il potenziale di membrana a riposo, cioè -70mV), diminuisce la frequenza di scarica.

Ecco lo schema, realizzato con Arduino:


<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/Arduino_Spike_Neuron.png"/>

#### [Video YouTube](https://www.youtube.com/watch?v=hH13wbqk_TM)

### <a name="ancora-dupneuron"></a>Catena di 2 neuroni

Così come si è realizzato lo schema per un neurone, lo si è realizzato per un secondo e lo si è collegato al primo, come nello schema seguente:

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/Arduino_Spike_Neural_network.png"/>

In questa piccola Spiking Neural Network vediamo due Arduino, dove ognuno dei quali rappresenta un neurone, collegati gtra loro a rappresentare una catena.
Il neurone 1 manda dei segnali al neurone successivo solamente quuando avviene lo spike, quindi, il neurone 2 calcola continuamente il potenziale di membrana nel tempo con corrente che sarà identica alla corrente di sinapsi del neurone precedente, quando quest'ultimo arriva allo spike, altrimenti sarà colcolato con corrente 0.

Nel modello di arduino del secondo neurone vediamo un bottone e un led: il led identifica lo spike del neurone precedente e il bottone aumenta la quantizzazione(aumenta il valore di tau), per poter vedere prima lo spike.

____________________________________________________________________________________________

### <a name="ancora-modizhikevich"></a>Mod Izhikevich's Spike Model

Tipologie di neuroni del modelloi di Izhikevich

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

___________________________________________________________________________________________________________


## <a name="ancora-progprolog"></a>Programma in Prolog

### <a name="ancora-prologsing"></a>Singolo Neurone

Di seguito il cuore del programma fatto in SWI-Prolog, dove si è implementato un singolo neurone seguendo i modelli di Izhikevich

        spike(ts,0.02,0.2,-65,6,14).

        spike(ps,0.02,0.25,-65,6,0.5).

        spike(tb,0.02,0.2,-50,2,15).

        spike(pb,0.02,0.25,-55,0.05,0.6).

        spike(mm,0.02,0.2,-55,4,10).

        spike(sfa,0.01,0.2,-65,8,30).

        spike(cuno,0.02,-0.1,-55,6,0).

        spike(cdue,0.2,0.26,-65,0,0).

        spike(sl,0.02,0.2,-65,6,7).

        spike(reson,0.1,0.26,-60,-1,0).

        %Predicato per fallimento iniziale di start()
        nSpike(nil).

        % Conrtrollo per il raggiungemento del picco
        % da parte del poteziale di membrana
        spikeControl(Vf,Uf,C,D,NVf,NUf) :-
            Vf >= 30,
            assert(nSpike(Vf)),
            write('Picco Vf: '),
            write(Vf),
            write(' mV'),nl,nl,nl,nl,
            NVf = C,
            NUf = Uf+D.
        spikeControl(Vf,Uf,_,_,Vf,Uf).

        %Lanciatore
        snn(Spike):-
            start(Spike,-70,-20,0,0.02,1).

        %Implementazione SNN
        start(_,_,_,Vf,_,_):-
            nSpike(Vf),
            retractall(nSpike(_)).

        start(Spike,Vi,Ui,_,Tau,Iter):-
            spike(Spike,A,B,C,D,I),
            Vf is Vi+(0.04*Vi*Vi+5*Vi+140-Ui+I)*Tau,
            Uf is Ui+(A*(B*Vf-Ui))*Tau,
            write('Impulso n°'),write(Iter),nl,nl,
            write('Potenziale di membrana ==> '),write(Vf),nl,nl,
            write('Recupero di membrana ==> '),write(Uf),nl,nl,nl,nl,nl,
            spikeControl(Vf,Uf,C,D,NVf,NUf),
            Itera is Iter + 1,
            start(Spike,NVf,NUf,Vf,Tau,Itera).
            
Per far partire il programma in prolog basta lanciare il predicato `snn/1` come termine il nome del predicato. <br>
Esempio:
`snn(ts)`.<br>

Per avere una guida su tutti i predicati che è possibile lanciare, eseguire: `spikehelp.`.

### <a name="ancora-prologtre"></a>Spike Neural Network a 3 neuroni
In questa parte si sono implementati 3 neuroni colegati(a catena) tra di loro per studiarne il funzionamento.
Si è previsto due modalità di funzionamento:
* Catena di neuroni "dormienti":
    * Un insieme di neuroni collegati tra di loro risultano inesistenti fino a che non ricevono un impulso di spike dal neurone precedente, un pò come se stessero in "ibernazione" fino a quel momento e vengono chiamati in causa solamente quando ricevono l'impulso.
* Catena di neuroni "svegli":
    * Un insieme di neuroni collegati tra di loro risultano sempre attivi ma a corrente 0(zero) fino a che non ricevono l'impulso di spike dal neurone precedente... e solamente in quel momento ricevono un impulso di corrente pari alla corrente di sinapsi del neurone precendente.

### <a name="ancora-prologtredorm"></a>Catena di neuroni "Dormienti"

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/Schema%20Neuron%20Sleep.png"/>

         spike(ts,0.02,0.2,-65,6).

         spike(ps,0.02,0.25,-65,6).

         spike(tb,0.02,0.2,-50,2).

         spike(pb,0.02,0.25,-55,0.05).

         spike(mm,0.02,0.2,-55,4).

         spike(sfa,0.01,0.2,-65,8).

         spike(cuno,0.02,-0.1,-55,6).

         spike(cdue,0.2,0.26,-65,0).

         spike(sl,0.02,0.2,-65,6).

         spike(reson,0.1,0.26,-60,-1).

         %Spiking neural network
         s('Freya','Odino').
         s('Odino','Thor').
         s('Thor','Freya').

         %Inizializzazione lista dei neuroni presenti sulla SNN
         initNrnsList(InitNeuron,InitList,List):-
             listControl(InitNeuron,InitList,NewList),
             InitList \= NewList,
             s(InitNeuron,PostNeuron),
             initNrnsList(PostNeuron,NewList,List).
         initNrnsList(_,List,List).

         % Conrtrollo per il raggiungemento del picco
         % da parte del poteziale di membrana
         spikeControl(Neuron,Vf,Uf,C,D,Nlist) :-
             Vf >= 30,
             write('_____________________________________________________________'),nl,
             write('Registrato picco del neurone '),write(Neuron),nl,nl,
             write('Potenziale di membrana ==> '),write(Vf),write(' mV'),nl,
             write('Recupero di membrana   ==> '),write(Uf),write(' mV'),nl,
             write('_____________________________________________________________'),
             nl,nl,nl,nl,
             NVf = C,
             NUf is Uf+D,
             listUpdate(Neuron-[NVf,NUf],Nlist,Newlist),
             s(Neuron,NeuronS),
             start(NeuronS,Newlist).
         spikeControl(_,_,_,_,_,_).

         % Controllo sulla lista dei neuroni se il neurone considerato è presente
         listControl(Neuron,List,Nlist):-
             \+member(Neuron-_,List),
             append([Neuron-[-70,-20]],List,Nlist).
         listControl(_,List,List).

         %Aggiornamento della Lista dei neuroni
         listUpdate(Neuron-Pot,List,NewList):-
             delete(List,Neuron-_,Nlist),
             append([Neuron-Pot],Nlist,NewList).

         %Prelevo il neurone considerato dalla lista, con i rispettivi potenziali
         searchNeuron(Neuron,[Neuron-[NV,NU]|_],NV,NU).
         searchNeuron(Neuron,[_|T],NV,NU):-
             searchNeuron(Neuron,T,NV,NU).

         %Controllo per l'inserimento dei valori di Vf in un file
         controlFile(X,[_-[NV,_]|Tail]):-
             write(X,NV),
             write(X, " , "),
             controlFile(X,Tail).
         controlFile(_,_).

         % Funzione di sart che impone una corrente costante in ingresso ad un
         % certo neurone, eccitandolo e attivando tutti i processi della SNN
         start(Neuron,NrnsList):-
             kSpike(Spike),
             spike(Spike,A,B,C,D),
             searchNeuron(Neuron,NrnsList,Vi,Ui),
             initI(I),
             tau(Tau),
             Vf is Vi+(0.04*Vi*Vi+5*Vi+140-Ui+I)*Tau,
             Uf is Ui+(A*(B*Vf-Ui))*Tau,
             listUpdate(Neuron-[Vf,Uf],NrnsList,Newlist),
             initFile(File),
             open(File,append,X),
             sort(0,@<,Newlist,OrderList),
             controlFile(X,OrderList),
             nl(X),
             close(X),
             spikeControl(Neuron,Vf,Uf,C,D,Newlist),
             initNeuron(InitNeuron),
             start(InitNeuron,Newlist).


         %Lanciatore
         %
         %       Spike --> Tipologia di spike da lanciare
         %           I --> Corrente di sinapsi
         %         Tau --> Campionamento
         %  InitNeuron --> Neurone iniziale
         %        File --> File di destinazione su dove inserire i valori
         %

         snn(Spike,I,Tau,InitNeuron,File):-
             retractall(tau(_)),
             retractall(initI(_)),
             retractall(kSpike(_)),
             retractall(initNeuron(_)),
             retractall(initFile(_)),
             assert(initNeuron(InitNeuron)),
             assert(initI(I)),
             assert(kSpike(Spike)),
             assert(tau(Tau)),
             assert(initFile(File)),
             initNrnsList(InitNeuron,[],List),
             start(InitNeuron,List).

In questa modalità i neuroni sono collegati a catena chiusa e il primo neurone della catena manda al suo successivo l'impulso elettrico ricevuto solamente quando avviene lo spike.
In questo caso la Spike Neural Network non considera i neuroni fino a che non avviene lo spike.

Per far partire questo programma basta lanciare il predicato `snn/5`, in cui i 5 argomenti identificano:
* Tipologia di neurone che si vuol studiare
* Corrente di sinapsi di partenza del primo neurone
* Campionamento(Tau)
* Neurone da cui partire: essendo una catena chiusa di neuroni, è possibile partire da uno dei 3.
* File dove salvare i dati per poi essere plottati

In questo caso si sono salvati i dati in file `.txt` e successivamente elaborati con Excel per ottenere i garfici.

#### <a name="ancora-plotsleep"></a>Plotting

Di seguito i grafici dei neuroni "Sleepy"

##### Tonic Spiking

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/STS/Plotting_STS_Tau002_I14.png"/>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/STS/Plotting_STS_Tau002_I80.png"/>

##### Tonic Bursting

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/STB/Plotting_STB_Tau002_I15.png"/>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/STB/Plotting_STB_Tau002_I80.png"/>

_______________________________________________________________________________________________________

### <a name="ancora-prologtrewake"></a>Catena di neuroni "Svegli"

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Schemi/Schema%20Neuron%20Wake.png"/>

##### Tipologie di neurone
         spike(ts,0.02,0.2,-65,6).

         spike(ps,0.02,0.25,-65,6).

         spike(tb,0.02,0.2,-50,2).

         spike(pb,0.02,0.25,-55,0.05).

         spike(mm,0.02,0.2,-55,4).

         spike(sfa,0.01,0.2,-65,8).

         spike(cuno,0.02,-0.1,-55,6).

         spike(cdue,0.2,0.26,-65,0).

         spike(sl,0.02,0.2,-65,6).

         spike(reson,0.1,0.26,-60,-1).
         
##### Neuroni 

         %Spiking neural network
         s('Freya','Odino').
         s('Odino','Thor').
         s('Thor','Freya').
         
##### Controllo Dello Spike

         % Conrtrollo per il raggiungemento del picco
         % da parte del poteziale di membrana
         spikeControl(Neuron,I,Vf,Uf,C,D,Nlist) :-
             Vf >= 30,
             write('_____________________________________________________________'),nl,
             write('Registrato picco del neurone '),write(Neuron),nl,nl,
             write('Potenziale di membrana ==> '),write(Vf),write(' mV'),nl,
             write('Recupero di membrana   ==> '),write(Uf),write(' mV'),nl,
             write('_____________________________________________________________'),
             nl,nl,nl,nl,
             %sleep(2),
             NVf = C,
             NUf is Uf+D,
             listUpdate(Neuron-[NVf,NUf],Nlist,Newlist),
             s(Neuron,NeuronS),
             start(NeuronS,Newlist,I).
         spikeControl(Neuron,_,_,_,_,_,Nlist):-
             s(Neuron,NeuronS),
             NeuronS \= 'Freya',
             start(NeuronS,Nlist,0).
         spikeControl(_,_,_,_,_,_,_).
         
##### Controllo/aggiornamento lista neuroni e valori di quest'ultimi

         % Controllo sulla lista dei neuroni se il neurone considerato è presente
         listControl(Neuron,List,Nlist):-
             \+member(Neuron-_,List),
             append([Neuron-[-70,-20]],List,Nlist).
         listControl(_,List,List).

         %Aggiornamento della Lista dei neuroni
         listUpdate(Neuron-Pot,List,NewList):-
             delete(List,Neuron-_,Nlist),
             append([Neuron-Pot],Nlist,NewList).

         %Prelevo il neurone considerato dalla lista, con i rispettivi potenziali
         searchNeuron(Neuron,[Neuron-[NV,NU]|_],NV,NU).
         searchNeuron(Neuron,[_|T],NV,NU):-
             searchNeuron(Neuron,T,NV,NU).

##### Predicato di lancio
         %Lanciatore
         %
         %       Spike --> Tipologia di spike da lanciare
         %           I --> Corrente di sinapsi
         %         Tau --> Campionamento
         %  InitNeuron --> Neurone iniziale
         %        File --> File di destinazione su dove inserire i valori
         %
         snn(Spike,I,Tau,InitNeuron,File):-
             retractall(tau(_)),
             retractall(initI(_)),
             retractall(kSpike(_)),
             retractall(initNeuron(_)),
             retractall(initFile(_)),
             assert(initNeuron(InitNeuron)),
             assert(initI(I)),
             assert(kSpike(Spike)),
             assert(tau(Tau)),
             assert(initFile(File)),
             start(InitNeuron,[],I).

##### Controllo di inserimento in un file
         %Controllo per l'inserimento dei valori di Vf in un file
         controlFile(Neuron,X,Vf):-
             initNeuron(InitNeuron),
             Neuron \= InitNeuron,
             write(X,Vf),
             write(X, " , "),
             close(X).
         controlFile(_,X,Vf):-
             nl(X),
             write(X,Vf),
             write(X, " , "),
             close(X).

##### Programma di calcolo del potenziale di membrana e recupero di quest'ultima
         %Calcolo del Vf e Uf secondo il modello di Izhikevich
         %
         % start = Programma principale
         %
         start(Neuron,Nlist,I):-
             kSpike(Spike),
             spike(Spike,A,B,C,D),
             listControl(Neuron,Nlist,Newlist1),
             searchNeuron(Neuron,Newlist1,Vi,Ui),
             tau(Tau),
             Vf is Vi+(0.04*Vi*Vi+5*Vi+140-Ui+I)*Tau,
             Uf is Ui+(A*(B*Vf-Ui))*Tau,
             initFile(File),
             open(File,append,X),
             controlFile(Neuron,X,Vf),
             listUpdate(Neuron-[Vf,Uf],Newlist1,Newlist2),
             spikeControl(Neuron,I,Vf,Uf,C,D,Newlist2),
             initNeuron(InitN),
             initI(InitI),
             start(InitN,Newlist2,InitI).
            
            
#### <a name="ancora-plotwake"></a>Plotting
Di seguito alcuni modelli di neuroni plottate con excel attraverso i dati elaborati dal Prolog

##### Tonic Spiking

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TS/Plotting_TS_Tau002_I14.png"/>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TS/Plotting_TS_Tau002_I80.png"/>

##### Tonic Bursting

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TB/Plotting_TB_Tau002_I15.png"/>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TB/Plotting_TB_Tau002_I50.png"/>
            
________________________________________________________________________________

### Conclusioni

I Neuroni "Spleeèy" sono da escludere perchè non rispecchaino a pieno il comportamento del neurone biologico.

Come possiamo notare, anche dall’esperienza in Arduino, quando la corrente indotta aumenta si ha un aumento della frequenza di scarica, cioè il numero degli spike tende ad aumentare considerando la quantizzazione(Tau) inalterata.
Ogni tipologia di neurone corrisponde ad un andamento di tipo grafico, che varia in base ai valori assegnati, ma la corrente indotta è qualcosa che fa variare fortemente la funzione nella sua frequenza. 

*Cosa succede se lasciamo la corrente inalterata e variamo il tau?*

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TS/Plotting_TS_Tau002_I14.png"/>

<img src="https://github.com/ProjectIA2019/SpikeNeuralNetwork/blob/master/Img/Plotting/TS/Plotting_TS_Tau02_I14.png"/>


L’andamento del grafico non cambia, ma, in questo caso, si ha un grafico più schiacciato e compatto, come se il tempo per arrivare al picco fosse più breve… ed è proprio quello che accade!
Aumentando il tempo di quantizzazione, si hanno intervalli di tempo più ampi dove è possibile arrivare prima allo spike.
Questo metodo potrebbe aiutare a vedere prima lo spike, qualora quest’ultimo fosse molto lontano, ma non sempre è la soluzione più giusta, perché aumentando fortemente il tau, succederebbe tutto molto in fretta falsando i valori.


#### <a href="#ancora-indice">Torna all'indice</a>

______________________________________________________________________________________

### Progetto di Intelligenza Artificiale
Pietro Rignanese & Andrea Polenta 
Università politecnica delle marche

Anno 2018/2019

Intelligenza artificiale


Fonti: https://github.com/BadenLab/Spikeling
