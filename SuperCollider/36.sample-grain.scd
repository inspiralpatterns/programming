/*GRANULAR SYNTHESIS
Sound could be imagined as a stochastic stream of particles, called grains.
Every grain has its own envelope, duration and there's a density general
parameter to define the quantity. With proper values, it's possible to
re-synthesize an audio file with no audible artifact*/


b = Buffer.read(s, "/jongly.aif");
c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");



/*CASE 1
Example of granular synthesis by parallel streams*/

(
{
	var density = 100 ;
	var amp = 1/ density;
	var minDur = 0.5, maxDur = 3 ;
	Pan2.ar(
		Mix.fill(density,
			{
				PlayBuf.ar(1, b, loop: 1)
				*
				LFPulse.kr(
					freq: LFNoise2.kr(20)
					.linlin(-1.0,1.0, minDur.reciprocal, maxDur.reciprocal),
					iphase: 2pi.rand,
					width: LFNoise2.kr(3, 0.5, 1),
					mul: amp)}),
		pos: LFNoise2.kr(7)
	);
}.play;
)


/*CASE 2
Using specific unit generator*/
(
SynthDef(\grain, {arg buffer, density = 20,
	minDur = 0.24, maxDur = 0.75, rate = 1, out = 0;
	var num = 10;
	Out.ar(out,
		Mix.fill(num, {
			GrainBuf.ar(
				numChannels: 2,
				trigger: LFNoise0.kr(
					freq: density),
				dur: LFNoise0.kr(3, (maxDur - minDur), minDur).range(0.0, 1.0),
				sndbuf: buffer,
				rate: rate + LFNoise2.kr(0.3, 0.1, -0.1),
				pos: LFNoise2.kr(7).range(0.0, 1.0),
				interp: 4,
				pan: LFNoise2.kr(3),
				envbufnum: -1,
				maxGrains: 1024,
				mul: 1 / num;
		)});
	)}
).add;
)


(
x = Synth(\grain, [\buffer, b]);
y = Synth(\grain, [\density, 0.3, \buffer, c, \rate, 1]);
)

/*live interaction*/
x.set(\minDur, 0.02, \maxDur, 0.07, \density, 3);
x.set(\density, 0.7, \rate, 0.3);
x.set(\minDur, 0.2, \maxDur, 1,2);
x.set(\density, 1, \rate, -1);
y.set(\density, 3, \rate, 1.3);


s.freeAll;