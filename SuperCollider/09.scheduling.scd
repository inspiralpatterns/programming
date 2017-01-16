/*SCHEDULING
how to control execution orders when
performing audio operation simultaneously (at audio-rate)*/

SynthDef.new(\pulse, {
	arg out = 0, freq = 4;
	Out.ar(out, Pulse.ar(freq))};
).add;

SynthDef.new(\rev, {
	arg in, out = 0;
	Out.ar(out, FreeVerb.ar(In.ar(in)))};
).add;


/*CASE 1
wrong because order is ~rev --> ~pulse
*/
(
~sergio = Bus.audio(s, 1);
~pippo = Synth.new(\pulse, [\out, ~sergio]);
~rev = Synth.new(\rev);
~rev.set([\in, ~sergio]);
)

/*CASE 2
right because order is ~pulse --> ~rev
*/
(
~sergio = Bus.audio(s, 1);
~rev = Synth.new(\rev);
~pippo = Synth.new(\pulse, [\out, ~sergio]);
~rev.set([\in, ~sergio]);
)

/*CASE 1 is identical to CASE 2 if:
a. ~rev argument addAction is setted to 'addToTail';
b. ~rev allocating method is 'after'
so to let execution order is correct*/


(
~sergio = Bus.audio(s, 1);
~pippo = Synth.new(\pulse, [\out, ~sergio]);
~rev = Synth.new(\rev, addAction: 'addToTail');
~rev.set([\in, ~sergio]);
)
/*or*/
(
~sergio = Bus.audio(s, 1);
~pippo = Synth.new(\pulse, [\out, ~sergio]);
~rev = Synth.after(~pippo, \rev);
~rev.set([\in, ~sergio]);
)

/*
NB: these methods print node tree definition*/
s.queryAllNodes;
s.plotTree;