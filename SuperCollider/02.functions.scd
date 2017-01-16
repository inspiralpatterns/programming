/*FUNCTION AND PERIODIC SIGNALS*/

(
var samples = Array.newClear(10);
f = {arg x; y = (x/2).pow(3)};

//compute a loop over the array
samples.do{arg item, index;
	samples[index] = f.value(index);
};

samples.plot("Function example", 600).front;
)


/*fill one-sec buffer with periodic function
time is given as period (1/s)*/
(
var buffer = Array.newClear(44100);
f = {arg x, a, k; (a*((2*3.14)*k*x).sin)};

//compute a loop over the array
a = 0.7;
k = 1/44100;
buffer.do{arg y, x;
	buffer[x] = f.value(x, a, k);
};

buffer.plot("Function example", 1200).front;
)

/* time is given as frequency (Hz)
a rescale operation is needed*/
(
var sig, amp = 0.5, freq = 440, val;
sig = Signal.newClear(44100);

f = {arg x, amp, freq; (amp * sin(2pi*(x/sig.size)*freq))};
sig.size.do({arg y, x;
	sig[x] = f.value(x, amp, freq);
});

sig.plot("Function example", 1200, minval: -1, maxval: 1);
sig.play(true);
)

/*periodic signal with n-harmonics
REAL-TIME APPROACH: the algorithm computes sample-by-sample*/
(
var sig, ampn, freq = 1, val;
var harm = 128;
sig = Signal.newClear(44100).fill(0);

sig.size.do({arg x;
	val = 0;
	harm.do{arg i;
		harm = i + 1;
		if (harm.odd) {
			ampn = 1.0/harm;
			val = val + (ampn*sin(2pi*freq*(i+1)*(x/sig.size)));
		}
	};
	sig[x] = val/2;
});

sig.plot("Function example", 1200, minval: -1, maxval: 1);
)


//signal class has its own synthesis methods
Signal.sineFill(44100, 1/(Array.series(100, 1, 1))).plot;


//absolute value, square and clipping method over a sine wave
(
var sig = (Signal.sineFill(44100, [1])).squared.abs;
sig.size.do {arg x;
	sig[x] = (sig[x] - 0.5).clip2(0.45);
};
sig.plot;
)


/*triangular wave: series approach*/
(
var size = 10000, sign = 1;
var freq = 1; //slope increasing when freq increases
var incr = (1 / size) * 4 * freq;
var sig = Signal.newClear(size);
var val = 0;

sig.size.do {arg x;
	if ((val >= 1) || (val <= 1.neg)) {
		sign = sign.neg;
	};
	val = val + (incr * sign);
	sig[x] = val;
};

sig.plot("Function example", 1200, minval: -1, maxval: 1);
)


/*signal with randomic phases
that is: NOISE*/
var sig = Signal.sineFill(1024, Array.fill(64, {1.0.rand}), Array.fill(64, {2pi.rand})).plot("random phase", 1200);



