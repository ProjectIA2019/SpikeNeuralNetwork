/*
 *    Pietro Rignanese & Polenta Andrea
 *    Universit� politecnica delle marche
 *    Anno 2018/2019
 *    Facolt� di Ingegneria informatica e dell'automazione
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
    write(" 1. izhik(ts) -->  TS:  Tonic Spiking"), nl,
    write(" 2. izhik(ps) -->  PS:  Phasic Spiking"), nl,
    write(" 3. izhik(tb) -->  TB:  Tonic Bursting"), nl,
    write(" 4. izhik(pb) -->  PB:  Phasic Bursting"), nl,
    write(" 5. izhik(mm) -->  MM:  Mixed Mode"), nl,
    write(" 6. izhik(sfa)-->  SFA: Spike Frequency Adaption"), nl,
    write(" 7. izhik(cuno)->  C1:  Class 1"), nl,
    write(" 8. izhik(cdue)->  C2:  Class 2"), nl,
    write(" 9. izhik(sl) -->  SL:  Spike Latency"), nl,
    write("10. izhik(r)  -->   R:   Resonator"), nl,
    write("11. izhik(i)  -->   I:   Integrator"), nl,
    write("12. izhik(rs) -->  RS:  Rebound Spike"), nl,
    write("13. izhik(rb) -->  RB:  Rebound Burst"), nl,
    write("14. izhik(tv) -->  TV:  Threshold Variability"), nl,
    write("15. izhik(is) -->  IS:  Inhibition-induce Spiking"), nl,
    write("16. izhik(ib) -->  IB:  Inhibition-induce Bursting"), nl,
    nl.

spikeControl(Vf,Uf,C,D,NVf,NUf) :-
    write(Vf),nl,
    Vf >= 30,
    write('Picco Vf: '),
    write(Vf),
    write(' mV'), nl,nl,nl,
    NVf = C,
    NUf = Uf+D,
    break().

spikeControl(Vf,Uf,_,_,Vf,Uf).

izhik(Spike):-
    start(Spike,-70,-20,0.02).

start(Spike,Vi,Ui,Tau):-
    spike(Spike,A,B,C,D,I),
    Vf is Vi+(0.04*Vi*Vi+5*Vi+140-Ui+I)*Tau,
    Uf is Ui+(A*(B*Vf-Ui))*Tau,
    spikeControl(Vf,Uf,C,D,NVf,NUf),
    start(Spike,NVf,NUf,Tau).




