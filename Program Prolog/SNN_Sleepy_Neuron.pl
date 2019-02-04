/*
 *    Pietro Rignanese & Polenta Andrea
 *    UniversitÃ  politecnica delle marche
 *    Anno 2018/2019
 *    FacoltÃ  di Ingegneria informatica e dell'automazione
 *
 */

% ______________________________Sleepy_Neuron_SSN_______________________
%
/*  Implementazione di una Spike Neural Network utilizzando il modello di neurone dettato da E.Izhikevich.
 *
 *  I Neuroni in fase di riposo vengono considerati dormienti.
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

% Info sugli spike
spikehelp:-
    write("ELENCO FUNZIONI NEURONE:"), nl,
    write(" 1. snn(ts) -->  TS:  Tonic Spiking"), nl,
    write(" 2. snn(ps) -->  PS:  Phasic Spiking"), nl,
    write(" 3. snn(tb) -->  TB:  Tonic Bursting"), nl,
    write(" 4. snn(pb) -->  PB:  Phasic Bursting"), nl,
    write(" 5. snn(mm) -->  MM:  Mixed Mode"), nl,
    write(" 6. snn(fa) -->  SFA: Spike Frequency Adaption"), nl,
    write(" 7. snn(cuno)->  C1:  Class 1"), nl,
    write(" 8. snn(cdue)->  C2:  Class 2"), nl,
    write(" 9. snn(sl) -->  SL:  Spike Latency"), nl,
    write("10. snn(r)  -->   R:   Resonator"), nl,
    write("11. snn(i)  -->   I:   Integrator"), nl,
    write("12. snn(rs) -->  RS:  Rebound Spike"), nl,
    write("13. snn(rb) -->  RB:  Rebound Burst"), nl,
    write("14. snn(tv) -->  TV:  Threshold Variability"), nl,
    write("15. snn(is) -->  IS:  Inhibition-induce Spiking"), nl,
    write("16. snn(ib) -->  IB:  Inhibition-induce Bursting"), nl,
    nl.

% Spiking neural network
s('Freya','Odino').
s('Odino','Thor').
s('Thor','Freya').

% Inizializzazione lista dei neuroni presenti sulla SNN
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

% Aggiornamento della Lista dei neuroni
listUpdate(Neuron-Pot,List,NewList):-
    delete(List,Neuron-_,Nlist),
    append([Neuron-Pot],Nlist,NewList).

% Prelevo il neurone considerato dalla lista, con i rispettivi potenziali
searchNeuron(Neuron,[Neuron-[NV,NU]|_],NV,NU).
searchNeuron(Neuron,[_|T],NV,NU):-
    searchNeuron(Neuron,T,NV,NU).

% Controllo per l'inserimento dei valori di Vf in un file
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


% Lanciatore
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




