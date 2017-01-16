/*PATTERN
The pattern class defines a patterns that will be managed by message asStream.
In this way, the sequence is converted in a stream and the next method can be used.
It's possible to get the same result using next method directly on a routine.
So:
- pattern + asStream = Routine
*/


/***DISCUSSION
three identical ways to make and perform a routine ten times***/
/*WAY ONE*/
var a, p, q, r;
a = Array.new;
a = [0, 1, 2, 3];

p = Pseq(a, repeats: 3).postln; //make pattern
q = p.asStream.postln; //have the pattern as stream, i.e a routine

/*perform the routine*/
10.do {arg i;
	"that's the number ".post; q.next.postln};


/*WAY TWO*/
r = Routine.new({
	10.do {arg i;
		i = i%4;
		"that's the number ".post; i.postln;
	}}
);

SystemClock.play(r);


/*WAY THREE*/
{10.do
	{arg i;
		i = i%4;
		"that's the number ".post; i.postln;
	}
}.fork;

