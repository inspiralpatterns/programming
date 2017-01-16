/*TRIGGERING
how to control events in time (sequencing) via functions
- inherited from analog synthesizers modules*/


/*functions let a continue signal change in time
- or become a series of discrete events*/
{LFSaw.kr(0.3, mul: 15, add: 220) + SinOsc.kr(0.3/2, mul: 15)}.plot(6, bounds: 600);
{LFSaw.kr(0.3, mul: 6)*SinOsc.ar(0.3, mul:3)}.plot(4, bounds: 600);
{LFPulse.kr(0.3, mul: 6)+SinOsc.ar(0.3, mul:3)}.plot(4, bounds: 600);


/*discussion*/
/*CASE 1*/
(
SynthDef(\sequencing, {arg sawfreq = 0.3, sinfreq = 0.3, out;
	Out.kr(out,
		LFSaw.kr(sawfreq, mul: 15, add: 220) + SinOsc.kr(sinfreq/2, mul: 15))
	}
).add;

SynthDef(\sine, {arg freq = 220, out;
	Out.ar([out, out+1], SinOsc.ar(freq, mul: 0.5))};
).add;
)

~seq = Bus.control;

x = Synth.new(\sine);
y = Synth.new(\sequencing, [\out, ~seq]);
x.map(\freq, ~seq);

/*NB: ALL THE ARGUMENTS MUST BE INITIALIZED
otherwise they are set to zero*/

/*CASE 2*/
SynthDef(\strangesine, {arg sawfreq = 0.3, sinfreq = 0.3, out;
	Out.ar([out, out+1], SinOsc.ar(
		freq: LFSaw.kr(sawfreq, mul: 15, add: 220) + SinOsc.kr(sinfreq/2, mul: 15),
		mul: 0.5))
	}
).add;

x = Synth.new(\strangesine);


s.freeAll;
s.scope;
