/*SUBTRACTIVE SYNTHESIS
This type of synthesis focuses on a rich signal generator that has
passed through several filtering stages. In this way, it's possible
to create very complex spectra with low computational resources.

The example provided here in has these features:
a) a pink noise generator is processed in parallel;
b) every filter has its own central frequency, Q and gain;
c) the filtered signal is then multiplied with an envelope;
d) every envelope has its own shape determined by the filtered signal itself;
e) a slight frequency deviation to achieve a little inharmonic feeling in
process of filter tuning has provided;
f) the so-created array is then mixed all together;
g) a Pan provides a spatialization of the sum;
h) Quadratic interpolated noise provides position values in [-1,1] range.
*/

{Pan2.ar(
	in: Mix.fill(16, {arg n;
		var basefreq = 55;
		var noz = PinkNoise.ar;
		BPF.ar(
			in: noz,
			freq: basefreq * (n+1) + (basefreq*n/10).rand,
			rq: 1/((n+1)*10),
			mul: 1/(n+1) + 0.5)
		*
		EnvGen.kr(
			envelope: Env.perc(0.1*n, 1/n, 1, (n*2).bilinrand),
			gate: Dust.kr(n+1),
			doneAction: 0)}),
	pos: LFNoise2.ar(7, 1.2),
	level: 1.5;
	)
}.play;



s.freeAll