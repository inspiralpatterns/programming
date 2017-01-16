/*CANON
how to create an algorithmic composition based on four identical melodic lines,
the last of which are slightly delayed and transposed by custom parameters*/
(
SynthDef(\drop, {
	arg freq = 440, detune = 0.05, amp = 0.125, pos = 0;

	var sig = Mix.arFill(10, {
		SinOsc.ar(freq + Rand(0, freq*detune), mul: amp)});
		sig = sig * EnvGen.kr(Env.perc);
		sig = FreeVerb.ar(sig, mix: 0.2, mul: 0.7);

		/*check the silence to deallocate the synth instance*/
		DetectSilence.ar(sig, -96.dbamp, doneAction: 2);

		Out.ar(0, Pan2.ar(sig, pos));
	}
).add;
)


(
/*create the sequences*/
var mel = [0, 2, 3, 5, 8, 10];
var pan = Array.series(5, -1, 0.5);
var rhythm = [1, 1, 3, 1, 5, 4, 3];

/*create the routines
because of there are two lines, it needs four consecutive index, i.e. a 4-box array*/
var melseq = Array.fill(4, {Pseq(mel, inf).asStream});
var panseq = Array.fill(4, {Pseq(pan, inf).asStream});
var rseq = Array.fill(4,  {Pseq(rhythm, inf).asStream});


/*create the canon
4.do performs four identical parallel routines (i.e. at the same time)*/

4.do{
	arg i;
	{72.do{
		var freqSeq = melseq[i];
		var durSeq = rseq[i];
		var freq = (12*i + freqSeq.next + 24).midicps;
		var pan = panseq[i].next;
		var dur = durSeq.next * 0.125 * (5-i);
		Synth(\drop, [\freq, freq, \pos, pan]);
		dur.wait;
		/*if we had a constant wait time, all the parallel routines would create
		a unison transposed over several octaves*/
		};
	}.fork;
};
)

