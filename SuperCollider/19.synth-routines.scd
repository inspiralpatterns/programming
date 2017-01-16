/*SCHEDULING SYNTH PARAMETERS
an example of synthesizer in which events are scheduled through a routine
(both synth and routine are at SystemTempo)*/


/***tips
all the arguments that begin with 't_' will be made as a TrigControl
and they don't need a reset message***/

(
SynthDef(\saw, {arg freq = 220, detune = 0.3, dur = 0.3, t_trig = 1;
	Out.ar(0, Pan2.ar(
		Mix.fill(4, {arg i;
			EnvGen.kr(Env([0, 1, 0], [0.9, 0.1], \sin), t_trig) *
			Saw.ar(
				freq: freq * (i+1) + SinOsc.kr(freq*0.2, 0, detune, detune/2),
				mul: 0.5/(i+1))}), LFNoise1.kr(2)
		);
	)};
).add;
)

(
x = Synth.new(\saw);

~mul = 1; //standard event duration (sec)
~base = 36; //MIDI offset

Routine.new({
	inf.do {arg i;

		/*choose a randomic event duration*/
		var dur;
		dur = [1, 2, 2, 4, 3].choose * ~mul;

		/*set synth parameters for each event*/
		x.set(
			\t_trig ,1,
			\freq, ([0, 2, 3, 5, 7, 8, 10].choose + ~base).midicps,
			\detune, rrand(1.0, 3.0),
			\dur, dur * 0.95 //the event must be finished before choosing another one!
		);

		/*set time scheduling relative to time event*/
		dur.wait;
	};
	}
).play(SystemClock);
)



/*interacting with routine and synth through environmental variables*/
~mul = 0.3; ~base = 48;
~mul = 1.4; ~base = 24;


s.freeAll;
s.plotTree;