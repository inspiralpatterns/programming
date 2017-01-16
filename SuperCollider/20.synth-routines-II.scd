/*SCHEDULING SYNTH PARAMETERS - II
an example of synthesizer in which events are scheduled through a routine
(both synth and routine are at SystemTempo)*/

/***
This version add to the previous a custom-randomic envelope option.
The synth hasn't got a TrigControl to trigger the new envelope, but a new instance of the SynthDef is allocated at every routine and deallocated when the envelope is at its end (doneAction: 2)
***/

(
SynthDef(\saw, {arg freq = 220, detune = 0.3, dur = 0.3,
	a, b, c;
	var env;
	env = Env(
				levels: [0, a, b, c, 0],
				times: [0.05*dur, 0.3*dur, 0.15*dur, 0.5*dur],
				curve:[\lin, \exp, \welch, \welch]
	);
	Out.ar(0, Pan2.ar(
		Mix.fill(4, {arg i;
			EnvGen.kr(env, doneAction: 2) *
			Saw.ar(
				freq: freq * (i+1) + SinOsc.kr(freq*0.2, 0, detune, detune/2),
				mul: 0.5/(i+1))}), LFNoise1.kr(2)
		);
	)};
).add;

~mul = 1; //standard event duration (sec)
~base = 36; //MIDI offset

~r = Routine.new({
	inf.do {arg i;

		/*choose a randomic event duration*/
		var dur;
		dur = [1, 2, 2, 4, 3].choose * ~mul;

		/*choose envelope sections duration*/
		a = 0.3.rand;
		b = 1.4.rand;
		c = 0.5.rand;

		/*allocate a new instance of this synth*/
		Synth.new(\saw, [
			\a, a,
			\b, b,
			\c, c,
			\dur, dur * 0.95,
			\freq, ([0, 2, 3, 5, 7, 8, 10].choose + ~base).midicps,
			\detune, rrand(1.0, 3.0)
			]
		);

		/*set time scheduling relative to time event*/
		dur.wait;
	};
	}
);
)

SystemClock.play(~r);

/*interacting with routine and synth through environmental variables*/
~mul = 0.3; ~base = 48;
~mul = 1.4; ~base = 24;

s.freeAll;
s.plotTree;