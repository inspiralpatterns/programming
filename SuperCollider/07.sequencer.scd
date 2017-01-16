/*CONTROL SIGNALS
SuperCollider provides several pseudo-casual control signals
(noises, random impulses). One of these, LFONoise0 is noise with
sampled-and-held values and could be used to manage sequencer steps*/

(
SynthDef(\modalSeq, {arg freq = 8, amp = 0.2, octave = 2, transpose = 0;
	var offset = 57 + transpose;
	var pitches = [0, 0, 0, 3, 3, 3, 5, 5, 7, 10, 10, 10, 12] + offset;
	var scale = pitches.add(pitches + 12*(octave -1)).flat.midicps;
	var range = scale.size.asInteger;
	Out.ar(bus: [0, 1], channelsArray: SinOsc.ar(
		freq: Select.kr(
			which: LFNoise0.kr(freq: freq, mul: range).round,
			array: scale
		),
		mul: amp * EnvGen.kr(Env.perc(
			attackTime: 0.0001, releaseTime: 0.2, curve: -9)
			, gate: Impulse.kr(freq), doneAction: 2)
		);
	);
	};
).add;
)


var seq = Group.new;
x = Synth.new(\modalSeq, [\freq, 4, \octave, 1, \transpose, -36, \amp, 0.7]);
y = Synth.new(\modalSeq, [\octave, 2, \transpose, 0]);
z = Synth.new(\modalSeq, [\octave, 1, \transpose, -12]);
w = Synth.new(\modalSeq, [\octave, 2, \transpose, -5]);
k = Synth.new(\modalSeq, [\freq, 8, \octave, 1, \transpose, 60, \amp, 0.6]);


x.free(true);
y.free(true);
z.free(true);
w.free(true);
k.free(true);

Env.perc(attackTime: 0.01, releaseTime: 0.3, curve: -9).plot;


/*STOCHASTIC TRIGGERING
'Dust' unit generator is often used as trigger,
for example in conjunction with TRand*/

/*TRand is triggered with constant-timing impulses*/
{
	var trigger = Impulse.kr(freq: 9);
	SinOsc.ar(freq: TRand.kr(220, 440, trigger), mul: 0.5);
}.play;

/*TRand is triggered with Dust*/
{
	var trigger = Dust.kr(density: 40);
	SinOsc.ar(freq: TRand.kr(220, 440, trigger), mul: 0.5);
}.play;