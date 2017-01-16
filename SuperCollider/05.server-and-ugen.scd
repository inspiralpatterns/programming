/*AUDIO SERVER and UGEN*/

//dump all messages by server (in binary)
s.dumpOSC(1);


/*SynthDef class lets the user create an empty box that describes how to build a specific synth module.
It has provided by arguments or unit generators (UGen).
Every Ugen has its own default parameters*/

SynthDef.new("synth", {Out.ar(0, SinOsc.ar)});
/*or*/
SynthDef.new("synth", {Out.ar(0, SinOsc.ar(440, 0.0, 1.0, 0.0))});
/*or*/
SynthDef.new("synth", {Out.ar(bus: 0,
	channelsArray: SinOsc.ar(freq: 440, phase: 0.0, mul: 1.0, add: 0))});


/*Ugen should be used to modify arguments of other Ugen*/
SynthDef.new(\pulseSine, {arg out = 0, amp = 1.0, kfreq = 3;
	Out.ar(out, SinOsc.ar(
		kfreq * 75, mul: LFPulse.ar(kfreq, width: 0.25)) * amp;)}).add;


/*expanded code version
less optimized, more clear*/
SynthDef.new(\pulseSine, {arg out = 0, amp = 1.0, kfreq = 3;
	var pulse, sine;
	pulse = LFPulse.ar(freq: kfreq, width: 0.25);
	sine = SinOsc.ar(freq: kfreq * 75, mul: pulse);
	sine = sine * amp;
	Out.ar(out, channelsArray: sine);
	}
).add;


/*create a synth based on custom-built module*/
s.dumpOSC(1);
SynthDef.new(\pulseSine, {arg out = 0, amp = 1.0, kfreq = 3;
	Out.ar(out, SinOsc.ar(
		kfreq * 75, mul: LFPulse.ar(kfreq, width: 0.25)) * amp;)}).add;

x = Synth(\pulseSine);


/*live coding example
(evaluate each code line as single operation)*/
x.run(false);
x.run(true).set(args: [\amp, 0.7, \kfreq, 10]);
x.set(args: [\amp, 0.3, \kfreq, 15.0.rand]);

y = Synth(\pulseSine, args: [\amp, 0.4, \kfreq, 6]);
z = Synth(\pulseSine, args: [\amp, 0.2, \kfreq, 2]);

x.free;
y.free;
z.free;

s.reboot;


/*group definition*/
SynthDef(\sine , {arg  freq = 100; Out.ar(0, SinOsc.ar(freq))}).add ;
SynthDef(\pulse , {arg freq = 100; Out.ar(1, Pulse.ar(freq))}).add ;
s.scope ;
g = Group.new ;
x = Synth(\sine , [\freq , 200], target:g) ;
y = Synth(\pulse , [\freq , 1000], target:g) ;
g.set(\freq , 400) ;
x.set(\freq , 1000) ;
g.free ;


