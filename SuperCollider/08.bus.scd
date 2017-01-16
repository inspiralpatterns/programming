/*INTERNAL and EXTERNAL BUSES*/

/*create a SynthDef with in and out arguments
in order to manage them manually*/
SynthDef(\rev , {arg in, out = 0;
	Out.ar([0,1], FreeVerb.ar(In.ar(in)))
}).add;


(
/*create a bus representation
NB: bus index is not needed because it's stored inside the variable*/
~revBus = Bus.audio(server: s, numChannels: 1);

~rev = Synth(\rev );

/*set the input of ~rev generator to rev bus
NB: ~ variables are environmental ones*/
~rev.set(\in , ~revBus);
)


/*the output bus will pickp up signal from ~revbus*/
x = {Out.ar(~revBus, Dust.ar(3))}.play;

/*de-allocating synth from scsynth*/
x.free;


/*
NB: control bus may be used to make a synth parameter be affected by
another synth, e.g. an LFO. Perhaps this means the main synth can receive
values from control synth only at k-rate.

To maintain the most generic synthDef, it's preferable to let one parameter
be controlled by the use of 'map' method*/

~sin = Synth.new(\sine);
~k = Synth.new(\controlsine);
~kBus = Bus.control(s);
~sin.map(\freq, ~kBus);

~k.run(false);
~k.run;
