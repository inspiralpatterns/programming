/*PATTERNS II
some kind of pattern classes are explained in short*/

/*PFUNC
it allows to set a Function and to use it inside a Stream that returns values
from the nextFunc for each repeat*/
(
var a, x;
a = Pfunc({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, { \reset.postln });
x = a.asStream;
{3.do{
	x.nextN(3).postln;
	0.5.wait;
	}
}.fork
x.reset;
)


/*PRAND
it selects a random item from a list for each repeat*/
(
var a, b;
a = Prand([1, 2, 3, 4, 5], 4);
b = a.asStream;
7.do({ b.next.postln; });
)


/*PKEY
it allows for backward access to values that are being used inside a Pbind*/
(
p = Pbind(\a, Pwhite(1, 10, inf), \b, Pkey(\a) * 2);
q = p.asStream;

{10.do{
	q.next(()).postln;
	0.5.wait;
	}
}.fork;


/*PBIND in details
It combines several values streams into one event stream.
The arguments are al alternating sequence of keys and patterns*/

a = Pbind(\x, Pseq([1, 2, 3], 1), \y, Pseq([4, 5, 6], 2), \z, Pkey(\x)*Pkey(\y));
x = a.asStream;

{7.do{
	x.next(()).postln;
	1.wait;
	}
}.fork;


/*Some consideration:
- the routine returns 'nil' when only one Pseq doesn't return no more values;
- it's possible chaining several backward accesses from different keys;
- use of () implies that the routine uses default values set inside Pbind.
(See Pbind help for more detailed information about keys)*/