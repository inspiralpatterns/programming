/*WAVESHAPING SYNTHESIS II
supercollider provides its own specific UGen for waveshaping, 'Shaper'

Shaper needs a buffer on which performing waveshaping.
The tranfer function is calculated in a client-side signal array and
then converted to a wavetable*/

/*CASE ONE*/
t = Signal.fill(512 + 1, {arg x;
	v = (x.bilinrand)/(x+1);
	if (abs(v) < 0.5,
	{v*0.2},
		{v*2})
}).normalize(-1.0, 1.0);
t.plot;

b = Buffer.alloc(s, 1024, 1);
b.sendCollection(t.asWavetableNoWrap);

/***TIPS: signal size must be power of two + 1, as
the buffer size must be double of the signal one*/

(
{Out.ar(0, Pan2.ar(
	in: Shaper.ar(b, SinOsc.ar(MouseY.kr(10, 1500) + 10, 0, MouseX.kr(0, 1))),
	pos: LFNoise1.kr(7),
	level: 0.5)
)}.scope;
)


/*CASE TWO*/
a = Signal.fill(256, { |i|
    var t = i/255.0;
    t + (0.1 * (max(t, 0.1) - 0.1) * sin(2pi * t * 80 + sin(2pi * 25.6 * t)))
}
);
d = (a.copy.reverse.neg) ++(Signal[0])++ a;
d.plot;

b.sendCollection(d.asWavetableNoWrap);



/*CASE THREE
Chebyshev's polynomial*/
b.cheby(Array.fill(1000, {1.0.rand}));
b.plot;



s.freeAll;