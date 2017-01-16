/*ENVELOPES*/

(
var levels, times;
var e1, e2, e3, e4, e5, e6, e7;

//levels = Array.fill(10, {1.0.rand});
levels = [0.01, 0.7, 0.5, 0.4, 0.8, 0.3, 0.01];
levels.postln;
times = Array.series(6, 1, 0.3);
times.postln;

//create envelope shapes
e1 = Env.new(levels, times, \lin);
e2 = Env.new(levels, times, \exp);
e3 = Env.new(levels, times, \sin);
e4 = Env.new(levels, times, \wel);

//shapes can be configured manually as an array
e5 = Env.new([0, 1, 0.8, 0], [0.1, 0.5, 1],[1, 0, 1]);
e6 = Env.new([0, 1, 0.8, 0], [0.1, 0.5, 1],[14, -3, 9]);
e7 = Env.new([0, 1, 0.8, 0], [0.1, 0.5, 1],[-7, 5, -14]);

//collect all together
[e1, e2, e3, e4, e5, e6, e7].collect({arg x; x.asSignal}).flop.flat.plot("Envelope example", 600, numChannels: 7);
)



/*standard shape envelope*/
(
var e1, e2, e3;
var a;
var size = 1024;

//fill Signal class with function
a = Signal.newClear(size);
a.waveFill({arg x; sin(x)}, 0, 20pi);

e1 = Env.linen(0.5, 1.2, 1.7, 0.8, 7).asSignal(size);
e2 = Env.linen(0.5, 1.2, 1.7, 0.8, \sine).asSignal(size);
e3 = Env.linen(0.5, 1.2, 1.7, 0.8, [\exp, \sine, -3]).asSignal(size);

//envelopes superposition on waveform
[e1*a, e2*a, e3*a].flop.flat.plot("Envelope example", 600, numChannels: 3);
)


/*tips: how to create coordinate pairs quicky*/

x = {({1.0.rand} ! 2) !4};















