/*EVENT
An event is an association between environment variables and values.
The key/value pairs specify the parameters and allow the event respond
to a -play message*/


().play;
Event.new.play;
/*this is a basic event, who makes a \default synth
defined by the server play*/


/*EVENT AND PATTERNS
in order to use Event keys for multiple allocations, it can need to write
a SynthDef using particular keys provided by the class as arguments.
Here, every note is considered as a single event in time*/
(
SynthDef(\sinperc, {
	arg freq = 440, detune = 0.05, amp = 0.5, pan = 0;

	var sig = Mix.arFill(10, {
		SinOsc.ar(freq + Rand(0, freq*detune), mul: amp * 0.1)});
	sig = sig * EnvGen.kr(Env.perc);
	sig = FreeVerb.ar(sig, mix: 0.2, mul: 0.9);
	DetectSilence.ar(sig, -96.dbamp, doneAction: 2);
	Out.ar(0, Pan2.ar(sig, pan));
	}
).add;

p = Pseq([2, 3, 7, 3, 8, 7, 10], inf).asStream;
q = Pseq([0, 1, -1, 0, -1], inf).asStream;
r = Pseq([0.4, 0.9, 0.3, 0.7], inf).asStream;

a = {
	inf.do{
		(\instrument: \sinperc, \ctranspose: p.next, \pan: q.next).play;
		(0.25*r.next).wait;
	}
}.fork;
)

a.stop;

/*EVENT PATTERNS
it's possible to combine several value streams into one event stream -
for instance, Pbind returns an EventStreamPlayer.
Here, a pattern is passed directly to a key and Pbind generates the event
based on key/value pairs specified in syntax*/
(
p = Pseq([2, 3, 7, 3, 8, 7, 10], inf);
q = Pseq([0, 1, -1, 0, -1], inf);
r = Pseq([0.4, 0.9, 0.3, 0.7], inf);

e = Pbind(\instrument, \sinperc, \ctranspose, p, \pan, q, \amp, r, \dur, r);

/*EventStreamPlayer generates streams based on the patterns provided and
can be controlled via specific methods*/
f = e.play;
f.pause;
f.mute;
f.unmute;
)