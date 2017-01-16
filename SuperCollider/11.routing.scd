/*ROUTING
SuperCollider provides automatically a multichannel expansion
when an Array has given as argument in an UGen*/


/*COMPARISON AMONG DIFFERENT FUNCTIONS DECLARATION*/
/*a sine wave is written out to bus 0*/
{SinOsc.ar(440)}.play;
/*a sine wave with an array of frequencies is written out
starting from bus 0, that is to buses 0 and 1*/
{SinOsc.ar([220, 440])}.play;

/*two sine waves are written separately on a single bus
starting from the lowest, e.g. 0*/
{[SinOsc.ar(220), SinOsc.ar(440)]}.play;
/*two sine waves are written, each of these with a specific out*/
(
{Out.ar(0, SinOsc.ar(220))}.play;
{Out.ar(1, SinOsc.ar(440))}.play;
)


/*DISCUSSION
SynthDef poly creates a 16-channel array, each of which contains a sine wave
with randomic pitch, randomic amplitude and panning.*/
(
SynthDef(\poly, {arg out = 2, bfreq = 110; //keep the lowest buses free
	Out.ar(out, Array.fill(16, {
		Pan2.ar(
			in: SinOsc.ar(
				freq: Rand(bfreq, bfreq*3) +
				(LFNoise1.kr(6, 0.5, 0.5))*bfreq*0.02,
				mul: LFNoise1.ar(Rand(0.1, 1))
			),
			pos: LFNoise1.ar(0.5, 4 , -2))}
	))};
).add;

/*SynthDef mix acts as a stereo mix.
It allows an array of channels as input and sums them all*/
SynthDef(\mix, {arg in, out;
	Out.ar(out, Mix.new(In.ar(in, 16)/16))};
).add;

/*reverb and general panning units*/
SynthDef(\rev, {arg in, out;
	Out.ar(out, FreeVerb.ar(In.ar(in), 0.1, 0.3))};
).add;

SynthDef(\pan, {arg in, out = 0;
	Out.ar(out, Pan2.ar(In.ar(in), LFNoise1.ar(3, 0.5), 1))};
).add;
)


/*create internal buses to let the signal pass through*/
~tube = Bus.audio(s, 16);
~rev = Bus.audio(s, 2);
~pan = Bus.audio(s, 2);

/*create instances of every synth and assign corresponding
inputs and outputs so to make them communicate with each other*/
x = Synth.new(\poly, [\out, ~tube]);
y = Synth.after(x, \mix, [\in, ~tube, \out, ~rev]);
z = Synth.after(y, \rev, [\in, ~rev, \out, ~pan]);
p = Synth.after(z, \pan, [\in, ~pan]);

/*create a control bus to change smoothly the base frequency
(the output of the function is passed
to the bus and the parameter is mapped)*/
c = Bus.control;
x.map(\bfreq, c);
{Out.kr(c, LFNoise1.kr(0.3, 2, 110))}.play


/*change synth settings on-the-fly*/
z.set([\mix, 0.3, \damp, 0.7]);


s.plotTree;
s.freeAll;

/*commands for recording an audiofile*/
s.prepareForRecord;
s.record;
s.stopRecording;


