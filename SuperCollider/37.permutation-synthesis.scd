/*PERMUTATION SYNTHESIS
Algorithmic synthesis technique based on numerical description of a digitalized sound.
It consists, for example, in scrambling or multiple permutations of different sections
in which a signal is supposed to be divided.
*/


/*create one-second length buffer to compute permutation over,
once it's been filled with signal*/
b = Buffer.alloc(s, s.sampleRate, 1);

c = Buffer.read(s, "/jongly.aif");
d = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

(
SynthDef(\bufferWrite, {arg freq = 220, buffer;
	RecordBuf.ar(
		inputArray: SinOsc.ar(freq),
		bufnum: buffer,
		loop: 1)}
).add;
)

x = Synth(\bufferWrite, [\buffer, b]);

(
SynthDef(\permutation, {arg buffer, permCoeff = 1, length = 2, out = 0;
	var trig = Impulse.kr(permCoeff);
	var period = permCoeff.reciprocal * SampleRate.ir;
	var startPos = LFNoise1.ar(permCoeff, 1).range(0.0, 1.0);
	var sig = BufRd.ar(1, buffer, Phasor.ar(
		trig: trig,
		rate: 1,
		start: startPos * period,
		end: startPos * period * length,
		resetPos: startPos * LFNoise2.ar(2).range(0.0, 1.0) * period));
	Out.ar(out, sig);
	}
).add;
)

(
SynthDef(\pan, {arg in;
	Out.ar(0, Pan2.ar(
		in: In.ar(in),
		pos: LFNoise1.kr(7)
	))}
).add;
)

(
~pan = Bus.audio(s, 2);
y = Synth(\permutation, [\buffer, c, \out, ~pan]);
z = Synth.after(y, \pan, [\in, ~pan]);
)

/*live interaction*/
y.set(\permCoeff, 10);
y.set(\buffer, d, \permCoeff, 1);
y.set(\permCoeff, 0.2);
y.set(\length, 0.3);
y.set(\length, 3);
y.set(\buffer, c);

y.free;
z.free;


s.freeAll;

s.prepareForRecord("/cooly.wav");
s.record;
s.stopRecording;