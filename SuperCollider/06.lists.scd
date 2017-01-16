/*LISTS
communication between SynthDef and GUI objects*/


/*in order to make a single object refer to a unique parameter
(es: a slider for oscillator frequency variation)
and also to automate more the process of GUI construction
it's possible create lists and group them into a single collection*/

SynthDef(\oscili, {arg freq = 400, amp = 0.5;
	Out.ar(
		bus: 0,
		channelsArray: SinOsc.ar(freq: freq, mul: amp)
	)
}).add;


(
var dict;
var sliders, labels, window;
var step = 30;
var pippo = Synth.new(\oscili);

window = Window.new("oscili", Rect.new(30, 30, step*4, step*4)).front;
		dict = IdentityDictionary.newFrom(List[\freq, [200, 400], \amp, [0.0, 1.0]]);
/***or
dict = IdentityDictionary[
	\pippo -> 4,
	\sergio -> 18];
***/

sliders = Array.fill(dict.size,
	{arg x; Slider(window, Rect.new(30*x, 50, step, step*2))});
labels = Array.fill(dict.size,
	{arg x; StaticText(window, Rect.new(30*x, 0, 30, 20))});


dict.do ({arg item, i;

	var range = item[1] - item [0];
	var offset = item[0];
	var name = dict.findKeyForValue(item); //find name for each mapped keys
	labels[i].string_(name); //	assign each keys to a label
	sliders[i].action_{arg control;
		var param = (control.value * range) + offset;
		[name, control.value].postln;
		pippo.set(name, param);
	};
});

)


/*NB: if variables are not correctly compiled into the do function, the function
does not evaluates. If doing so, a variable for each dict instance is created*/
