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

spikehelp():-
    write("ELENCO FUNZIONI NEURONE:"), nl,
    write(" 1. snn(ts) -->  TS:  Tonic Spiking"), nl,
    write(" 2. snn(ps) -->  PS:  Phasic Spiking"), nl,
    write(" 3. snntb) -->  TB:  Tonic Bursting"), nl,
    write(" 4. snn(pb) -->  PB:  Phasic Bursting"), nl,
    write(" 5. snn(mm) -->  MM:  Mixed Mode"), nl,
    write(" 6. snn(fa)-->  SFA: Spike Frequency Adaption"), nl,
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




