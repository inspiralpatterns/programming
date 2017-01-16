/*UGEN DEMAND II*/


/*Variable control on repeats*/
- LFNoise0: it allows a constant refresh of repeats parameter
due to the non-periodic nature of noise

{LFNoise0.kr(2).unipolar(6)}.plot(4);


- rand method: it allows a refresh of repeats parameter
only when a new SynthDef is allocated

5.rand;


/*DISCUSSION
In this case, LFNoise0 plays 3 values per second included in a 0-6 range*/
(
{arg krate = 4, range = 8;
	var a, freq, trig;
	trig = Impulse.kr(krate);
	a = {Dxrand([10, 11, 9, 1], LFNoise0.kr(krate).unipolar(range))} * 30 + 240;
	freq = Demand.kr(trig, 0, a).poll(krate);
	SinOsc.ar(freq, mul: 0.5);
}.play;
)

s.freeAll;





