/*EVENTS PATTERNS II
an array can be filled with many players, one for each box, so to create
a polyphonic event - all the array boxes are read simultaneously*/

(
SynthDef(\simplesine, {arg freq, pan, amp;
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, mul: amp)*EnvGen.kr(Env.perc), pan))}
).add;


p = Pseq([2, 3, 7, 3, 8, 7, 10], inf);
q = Pseq([0, 1, -1, 0, -1], inf);
r = Pseq([0.4, 0.9, 0.3, 0.7], inf);

a = Array.fill(2, {arg i;
	Pbind(\instrument, \simplesine,
		\freq, 110 * i,
		\ctranspose, p,
		\pan, (i * q) * 0.5,
		\amp, r * 0.25,
		\dur, (r * i))}
);

a = a.collect({arg i; i.play});
)


s.freeAll;
