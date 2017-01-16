/*TRIGGERING II
a series of discrete time-events via InRange method*/


/*DISCUSSION
how to create a glitch machine*/
SynthDef.new(\onezero, {arg out = 0, freq = 220, amp = 0.5,
	min = -0.05, max = 0.05, kfreq = 1;
	var glitch = Array.fill(2, {InRange.kr(LFNoise1.kr(kfreq), min, max)
		* SinOsc.ar(freq, mul: amp)});
	Out.ar(out, glitch)
	}
).add;

x = Synth.new(\onezero, [\freq, 12000, \amp, 0.3]);
y = Synth.new(\onezero, [\freq, 55, \amp, 0.3]);
y.set([\min, -0.3, \max, 0.3]);

s.freeAll;
s.plotTree;


/*plot the function for time = 3s*/
{InRange.kr(LFNoise1.kr(3), -0.01, 0.05) * SinOsc.ar(1, mul: 0.7)}.plot(3);


s.prepareForRecord;
s.record;
s.stopRecording;
