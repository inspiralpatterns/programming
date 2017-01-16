/*LANGUAGE FACILITIES
SuperCollider provides several modes to write the same function, or definition,
in order to define new operation in a very compact way*/


/*CASE 1
using an iteration inside a SynthDef*/
SynthDef.new(\pulse, {arg out = 0;
	8.do{arg i; Out.ar(out + i, SinOsc.ar(220 * (i + 1)) * LFPulse.ar(i + 2))};
	};
).add;

{Synth.new(\pulse)}.play;
s.scope(8);
s.freeAll;


/*CASE 1a
define arguments to give the user all the parameters control
(in this case, SynthDef is in a more abstract level)*/
SynthDef.new(\pulse, {arg out = 0, freq = 220, kfreq = 2, amp = 0.15;
	8.do{arg i; Out.ar(out + i, SinOsc.ar(220 * (freq + 1), mul: amp) * LFPulse.ar(i + kfreq))};
	};
).add;

{Synth.new(\pulse) * 0.5}.play;
{Synth.new(\pulse, [\freq, 50, \kfreq, 3]) * 0.5}.play;

s.scope(8);
s.freeAll;




/*CASE 2
using Mix classes to sum an array of channels*/
SynthDef.new(\pulse, {arg out = 0, freq = 55, kfreq = 1, amp = 0.1;
	var n = 4;
	var arr = Array.newClear(n);
	n.do{ arg x;
		arr[x] = SinOsc.ar(freq * x, mul: amp)*LFPulse.ar(kfreq + x)
	};
	Out.ar(out, Mix.ar(arr)/n);
	};
).add;

{Synth.new(\pulse)}.play;
{Synth.new(\pulse, [\freq, 110, \kfreq, 2, \out, 1])}.play;
s.scope(8);
s.freeAll;


/*CASE 2a
using the Array method fill to get a compact SynthDef*/
SynthDef.new(\pulse, {arg out = 0, freq = 55, kfreq = 1, amp = 0.1;
	var n = 4;
	var arr = Array.fill(n, {|x|
		arr[x] = SinOsc.ar(freq * x, mul: amp)*LFPulse.ar(kfreq + x)};
	Out.ar(out, Mix.ar(arr)/n)};
).add;

{Synth.new(\pulse)}.play;
{Synth.new(\pulse, [\freq, 110, \kfreq, 2, \out, 1])}.play;
s.scope(8);
s.freeAll;


/*CASE 2b
using the Mix method fill to shorten more*/
SynthDef.new(\pulse, {arg out = 0, freq = 55, kfreq = 1, amp = 0.1;
var n = 4;
var mix = Mix.fill(n, {|x|
	SinOsc.ar(freq * x, mul: amp)*LFPulse.ar(kfreq + x)});
	Out.ar(out, mix/n);
	};
).add;

{Synth.new(\pulse)}.play;
{Synth.new(\pulse, [\freq, 220]) * 0.5}.play;
s.scope(8);
s.freeAll;


{Out.ar([0,1], SinOsc.ar(40, mul: 0.2)*LFPulse.ar(1))}.play;

