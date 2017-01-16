/*SAMPLER
A buffer can be filled with any audio sample and can be read
successively by PlayBuf class.
Notice how UGen can modify other Ugen parameters.
*/



a = Buffer.read(s, "/Users/Boggiz/Desktop/test.aiff", 441000);
d = Buffer.read(s, "/jongly.aif");

SynthDef(\sampler, {arg buf, start = -1, end = -0.3,
	dur = 3, loop = 1, freq = 5, amp = 0.5;
	Out.ar(0, Pan2.ar(
		in: FreeVerb.ar(PlayBuf.ar(1, buf,
			rate: Line.kr(start, end, dur),
			loop: loop),
			mix: 0.15,
			mul: 0.8),
		pos: LFNoise1.kr(freq),
		level: amp));
	}
).add;

b = Synth.new(\sampler, [\buf, a, \start, 0.75, \end, 0.69, \dur, 5, \amp, 0.7]);
c = Synth.new(\sampler, [\buf, d, \loop: 1]);


/*live interaction*/
c.set(\freq, 20);
b.set(\freq, 3);
b.set(\freq, 100, \amp, 0.3);



s.freeAll;
