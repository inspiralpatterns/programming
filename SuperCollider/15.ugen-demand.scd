/*UGEN DEMAND
Demand Ugens have the feature to output a value when asked
- that is at demand-rate*/


/*the user has to provide the array from which frequency are generated*/
(
{
	var a, freq, trig;
	a = {Dseq.new([0, 3, 4, 2, 2, 7, 8, 5, 0, 3], 2)} * 30 + 240;
	trig = Impulse.kr(8);
	freq = Demand.kr(trig, 0, a);
	SinOsc.ar(freq, mul: 0.5);
}.play;
)


/*an array is filled with a randomic generation of n-integers*/
(
{
	var a, freq, trig;
	a = {Dseq.new({10.rand} ! 32, 2)} * 30 + 240;
	trig = Impulse.kr(8);
	freq = Demand.kr(trig, 0, a);
	SinOsc.ar(freq, mul: 0.5);
}.play;
)


/*using Drand and Dxrand
- Dxrand never repeats consecutively twice*/
(
{
	var a, freq, trig;
	a = {Drand.new({10.rand} ! 16, 16)} * 30 + 240;
	trig = Impulse.kr(8);
	freq = Demand.kr(trig, 0, a);
	SinOsc.ar(freq, mul: 0.5);
}.play;
)

(
{
	var a, freq, trig;
	a = {Dxrand([10, 11, 9, 1], 1)} * 30 + 240;
	trig = Impulse.kr(8);
	freq = Demand.kr(trig, 0, a);
	SinOsc.ar(freq, mul: 0.5);
}.play;
)


/*it's possible using demand into another demand
in order to provide semi-improvised patterns*/
(
{
	var a, freq, trig;
	a = {Dseq.new([0, 3, 2, 3, 7, 3, 2, 3, 5, 3, 2, 3, 4,
		Dxrand([19, 14, 11, 23, 19], 3)], inf)} * 30 + 240;
	trig = Impulse.kr(1);
	freq = Demand.kr(trig, 0, a);
	SinOsc.ar(freq + [0, 7] + LFPulse.kr(1, 0, 0.1, freq*2), mul: 0.5);
}.play;
)


s.freeAll;



/*FREQUENCY SETTINGS DISCUSSION
multichannel expansion + double-pitch at k-rate*/

{SinOsc.ar(3 + [0,0.7] + LFPulse.kr(1, 0, 0.1,3*2))* 0.5}.plot(4);
