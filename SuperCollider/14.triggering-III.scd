/*TRIGGERING III
create a series of cyclical values through multiple instances of modulo operator
- these values are written into an array and successively read by an envelope
(e.g. line, pulse, ramp)*/


/*how to create a basic arpeggiator.

kfreq: how many seconds it takes to complete values cycle
LFSaw is used as LFO ramp between 0 and half array size*/
SynthDef(\arp, {arg out, amp = 0.1, kfreq = 2, offset = 45;
	var notes = Array.fill(15, {
		arg x; (x%5) + (x%7) + (x%13) + offset}).midicps;
	notes.add(69);

	Out.ar([out, out+1], SinOsc.ar(
		freq: Select.kr(LFSaw.kr(1/kfreq).linlin(-1.0, 1.0, 0.0, notes.size), notes),
		mul: amp));
	}
).add;


/*some examples*/
x = Synth.new(\arp);
y = Synth.new(\arp, [\kfreq, 3]);
z = Synth.new(\arp, [\kfreq, 32, \offset, 21]);
w = Synth.new(\arp, [\kfreq, 1.5, \offset, 57]);


/*CASE 2
using Stepper class instead of LFSaw to generate discrete events*/
SynthDef(\arp, {arg out, amp = 0.1, kfreq = 2, offset = 45, mode = 1;
	var notes = Array.fill(15, {
		arg x; (x%5) + (x%7) + (x%13) + offset}).midicps;
	notes.add(69);

	Out.ar([out, out+1], SinOsc.ar(
		freq: Select.kr(Stepper.kr
			(Impulse.kr(kfreq*4), min: 0, max: notes.size, step: mode), notes),
		mul: amp));
	}
).add;


x = Synth.new(\arp);

/*several step modes*/
x.set(\mode, 2);
x.set(\mode, 4);
x.set(\mode, -3);


s.freeAll;