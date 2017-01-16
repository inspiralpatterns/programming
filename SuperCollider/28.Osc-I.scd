/*WAVETABLE SYNTHESIS
a sine function is written into an array of n indexes, so to create
several index/value pairs that represent a period of a (quasi)periodic signal*/

~sig = Array.fill(size: 16,
	function: {arg n, size = ~sig.size;
		sin(n/size * 2pi);
	}
);

~sig.do{arg k, n; ("["++n++"] = " ++k).postln};
/***tips: the arguments provided to the function are always
an element (the first) and an index (the second).
Their meaning depends entirely on their position in declaration***/

~sig.plot;


/*supercollider provides several function to fill a buffer
location with specific signal, e.g. a sine function, and
an UGen that read this models*/
(
var sine = Buffer.alloc(s, 2.pow(12));
buf.sine1(1);
buf.plot;
{Osc.ar(buf, 440, mul: 0.5)}.play;
)


(
var buf = Buffer.alloc(s, 2.pow(12));
buf.sine1(Array.fill(128, {arg n; 1/(n+1)}));
buf.plot;
{Osc.ar(buf, 440, mul: 0.5)}.play;
)

/***discussion: sine1 method has analog syntax to waveFill signal method,
so it requires an n-size array of harmonics and each amps***/


s.freeAll;