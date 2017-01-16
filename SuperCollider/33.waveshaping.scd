/*WAVESHAPING SYNTHESIS
(or non-linear distorsion)
It associates a transfer function to a signal in order to distort it.*/


/*define the transfer function
In this case: neutral TF (line in [-1, 1] range*/
t = Array.fill(512, {arg x; x.linlin(0.0, 512.0, -1.0, 1.0)});
t.plot;
b = Buffer.sendCollection(s, t);
/***TIPS: sendCollection method stream a collection (e.g. an array)
directly into a buffer on the server side***/


/*BufRd read a buffer, whose values are given by phase
(i.e reading index position, in this case provided by signal)*/
{
	var sig = SinOsc.ar(220, mul: MouseX.kr(0, 1)); //signal to be distorted
	Out.ar(0, BufRd.ar(
		numChannels: 1,
		bufnum: b,
		phase: sig.linlin(-1.0, 1.0, 0, BufSamples.ir(b) - 1)
	));
}.scope;


/*transfer function = compander + clipping*/
t = FloatArray.fill(512, {arg x;
	v = x.linlin(0.0, 512.0, -1.0, 1.0);
	if (abs(v) < 0.5,
	{v*0.3},
		{v*1.7})
}).normalize(-1.0, 1.0);
t.plot;
b = Buffer.sendCollection(s, t);


/*transfer function = randomic signal*/
t = FloatArray.fill(512, {arg x;
	v = (x.bilinrand)/(x+1);
	if (abs(v) < 0.5,
	{v*0.2},
		{v*2})
}).normalize(-1.0, 1.0);
t.plot;
b = Buffer.sendCollection(s, t);


/*transfer function = empirical complex table*/
t = FloatArray.fill(512, { |i|
    v = i.linlin(0.0, 512.0, -1.0, 1.0) ;
    v.round(0.5+(v*1.4*(i%8)))
}).normalize(-1.0, 1.0);
t.plot ;
b = Buffer.sendCollection(Server.local, t)


s.freeAll;

