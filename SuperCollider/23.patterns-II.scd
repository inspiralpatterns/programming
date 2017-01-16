/*PATTERN II
combine the use of patterns to control some specific actions on a synth instance*/


SynthDef(\sinperc, {
	arg freq = 440, detune = 0.05, amp = 0.125, pos = 0;

	var sig = Mix.arFill(10, {
		SinOsc.ar(freq + Rand(0, freq*detune), mul: amp)});
		sig = sig * EnvGen.kr(Env.perc);
		sig = FreeVerb.ar(sig, mix: 0.2, mul: 0.9);

		/*check the silence to deallocate the synth instance*/
		DetectSilence.ar(sig, -96.dbamp, doneAction: 2);

		Out.ar(0, Pan2.ar(sig, pos));
	}
).add;


/***CASE 1: 10-note pitch sequence using Pseq***/
var a, p;
a = [0, 2, 5, 7, 3, 9, 12, 15, 3, 7];
p = Pseq(a, inf).asStream;

{200.do{
	Synth.new(\sinperc, [
		\freq, ((p.next + 60).midicps),
		\pos, ((20.rand/10) - 1)]);

	0.125.wait}
}.fork;


/***CASE 2: 10-note pitch + 9 temporal variations
(or the so-called Talea VS Color)***/
var a, b, p, q;
a = [0, 2, 5, 7, 3, 9, 12, 15, 3, 7];
b = [1, 1, 3, 2, 1, 4, 1, 2, 3];
p = Pseq(a, inf).asStream;
q = Pseq(b, inf).asStream;

{100.do{
	Synth.new(\sinperc, [
		\freq, ((p.next + 60).midicps),
		\pos, ((20.rand/10) - 1)]);

	(q.next*0.125).wait}
}.fork;


/***CASE 3: extending Talea concept to
harmonisation, interval and octave variations***/
var a, b, p, q;
a = [0, 2, 5, 7, 3, 9, 12, 15, 3, 7];
b = [1, 1, 3, 2, 1, 4, 1, 2, 3];
p = Pseq(a, inf).asStream;
q = Pseq(b, inf).asStream;
~density = Pseq([1, 3, 4, 4, 2, 3], inf).asStream;
~interval = Pseq([2, 4, 7, 10], inf).asStream;
~octave = Pseq([0, 0, 1, 0, -1, -1], inf).asStream;

{
	200.do{
		var den = ~density.next;

		/*create for each density value n synth instance*/
		den.do{
			var delta = ~interval.next;
			var oct = ~octave.next;
			Synth.new(\sinperc, [
				\freq, (p.next+60+delta+(12*oct)).midicps,
				\pos, ((20.rand/10) - 1),
				\amp, 0.125/den]);
		};

		(q.next*0.125).wait;
	}
}.fork;

s.freeAll;
