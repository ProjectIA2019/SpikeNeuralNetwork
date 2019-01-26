/*
 *    Pietro Rignanese & Polenta Andrea
 *    Università politecnica delle marche
 *    Anno 2018/2019
 *    Facoltà di Ingegneria informatica e dell'automazione
 *
 */

% ______________________________Izhikevich Model________________________
%
/*  Implementazione algoritmi base per la simulazione di una Spike Neural Network
 *                  utilizzando il modello di Izhikevich.
 *
 * TIPOLOGIE:
 *
 * TS:  Tonic Spiking
 * PS:  Phasic Spiking
 * TB:  Tonic Bursting
 * PB:  Phasic Bursting
 * MM:  Mixed Mode
 * SFA: Spike Frequency Adaption
 * C1:  Class 1
 * C2:  Class 2
 * SL:  Spike Latency
 * R:   Resonator
 * I:   Integrator
 * RS:  Rebound Spike
 * RB:  Rebound Burst
 * TV:  Threshold Variability
 * IS:  Inhibition-induce Spiking
 * IB:  Inhibition-induce Bursting
 *
 * COSTANTI:
 * v = -70mV (Potenziale di membrana a riposo)
 * u = -20mV (Recupero di membrana)
 */


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
%Info sugli spike
spikehelp():-
    write("ELENCO FUNZIONI NEURONE:"), nl,
    write(" 1. snn(ts)    -->  TS:  Tonic Spiking"), nl,
    write(" 2. snn(ps)    -->  PS:  Phasic Spiking"), nl,
    write(" 3. snn(tb)    -->  TB:  Tonic Bursting"), nl,
    write(" 4. snn(pb)    -->  PB:  Phasic Bursting"), nl,
    write(" 5. snn(mm)    -->  MM:  Mixed Mode"), nl,
    write(" 6. snn(fa)    -->  SFA: Spike Frequency Adaption"), nl,
    write(" 7. snn(cuno)  -->  C1:  Class 1"), nl,
    write(" 8. snn(cdue)  -->  C2:  Class 2"), nl,
    write(" 9. snn(sl)    -->  SL:  Spike Latency"), nl,
    write("10. snn(reson) -->   R:   Resonator"), nl,
    write("11. snn(i)     -->   I:   Integrator"), nl,
    write("12. snn(rs)    -->  RS:  Rebound Spike"), nl,
    write("13. snn(rb)    -->  RB:  Rebound Burst"), nl,
    write("14. snn(tv)    -->  TV:  Threshold Variability"), nl,
    write("15. snn(is)    -->  IS:  Inhibition-induce Spiking"), nl,
    write("16. snn(ib)    -->  IB:  Inhibition-induce Bursting"), nl,
    nl,nl,
    write("Per lanciare il programma:"), nl,
    write(" - Scegliere la tipologia di spike tra quelle soprariportate;"), nl,
    write(" - Inserire nel lanciatore:"),nl,
    write("           - la modalità,"),nl,
    write("           - il neurone iniziale,"),nl,
    write("           - la corrente,"),nl,
    write("           - il quantizzatore,"),nl,
    write("           - il file di destinazione."),nl,nl,
    write("ESEMPIO: snn(ts,15,0.2,'C:/Desktop/nome.txt') ").

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





