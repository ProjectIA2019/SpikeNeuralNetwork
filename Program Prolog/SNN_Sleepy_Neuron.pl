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

%Spiking neural network
s('Freya','Odino').
s('Odino','Thor').
s('Thor','Freya').
%Info sugli spike
spikehelp():-
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

%Predicato per fallimento iniziale di start()
nSpike(nil).

% Conrtrollo per il raggiungemento del picco
% da parte del poteziale di membrana
spikeControl(Neuron,Vf,Uf,C,D,Nlist,Spike) :-
    Vf >= 30,
    assert(nSpike(Vf)),
    write('_____________________________________________________________'),nl,
    write('Registrato picco del neurone '),write(Neuron),nl,nl,
    write('Potenziale di membrana ==> '),write(Vf),write(' mV'),nl,
    write('Recupero di membrana   ==> '),write(Uf),write(' mV'),nl,
    write('_____________________________________________________________'),
    nl,nl,nl,nl,
    sleep(2),
    NVf = C,
    NUf is Uf+D,
    listUpdate(Neuron-[NVf,NUf],Nlist,Newlist),
    s(Neuron,NeuronS),
    start(Spike,NeuronS,Newlist,0.02).
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
snn(Spike,InitNeuron):-
    start(Spike,InitNeuron,[],0.02).

start(Spike,Neuron,Nlist,Tau):-
    spike(Spike,A,B,C,D,I),
    listControl(Neuron,Nlist,Newlist1),
    searchNeuron(Neuron,Newlist1,Vi,Ui),
    Vf is Vi+(0.04*Vi*Vi+5*Vi+140-Ui+I)*Tau,
    Uf is Ui+(A*(B*Vf-Ui))*Tau,
    listUpdate(Neuron-[Vf,Uf],Newlist1,Newlist2),
    spikeControl(Neuron,Vf,Uf,C,D,Newlist2,Spike),
    start(Spike,'Freya',Newlist2,Tau).





