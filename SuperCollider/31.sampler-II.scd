/*SAMPLER II
create a sampler who reads only one soundfile in several different ways
and with stochastic controls of rate and pan position*/


(
SynthDef.new(\variations, {arg buf = 0;
    var left, right;
    var num = 3;
    var level = 1/num;
    var source = Array.fill(num, {arg i;
        Pan2.ar(
            in: PlayBuf.ar(
				numChannels: 1,
				bufnum: buf,
				rate: LFNoise0.kr(1+i, mul: 2),
				loop: 1),
            pos: LFNoise1.kr(1+i),
            level: level);
    });

	/***source is an Array of num elements, each of one contains a stereo
	signal originated from spatialisation.
	To prepare the entire signal to stereo output, it needs to group ALL
	the left and right signal, so to create a 2d array of two elements
	(respectively L and R), each of which contains num/2 signals.
	To do that, flop method is used***/

    source = source.flop;
    left = Mix.new(source[0]);
    right = Mix.new(source[1]);
    Out.ar(0, [left, right])
}
).add;
)

(
var buf, aSynth ;
buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav") ;
aSynth = Synth(\variations , [\buf , buf]) ;
)

s.freeAll;