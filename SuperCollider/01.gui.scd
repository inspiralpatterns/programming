/*GUI and graphics*/

(
f = FlowView.new;
nil.gui(f);
[1,nil,"three"].gui(f);
)


/* set a window with a knob.
knob changes background color from pink to purple*/

(
var window, knob, screen;
window = Window.new("box", 534);
window.background = Color.black;

knob = Knob.new(window, 200);
knob.value = 0.5;

knob.action_({ arg me;
	//sintassi setter = operatore di assegnazione
	var red, blue, green;
	red = me.value;
	green = red * 0.75;
	blue = 0.25 + (red * 0.2);
	//["red, green, blue", red, green, blue].postln;
	window.background = Color(red, green, blue);
});

window.front;
)

/*SYNTAX SUGAR
the two code lines are identical
SuperCollider is able to understand hidden constructor method*/
Color.new(red, green, blue);
Color(red, green, blue)


/*color switching between RGB and HSV
(use of GUI, functions, loop controls)*/
(
var window = Window.new("FastColor", 400).front;
var guiArr, step = 20;
var flag = \rgb, colorF;
var colorArr = [0, 0, 0];

window.background = Color.white;

colorF = {arg flag, cls;
	var v1, v2, v3; //sliders
	var color; //output array
	# v1, v2, v3 = cls; //syntax sugar
	if (flag = \rgb, {
		color = Color.new(v1, v2, v3);
	},{
		color = Color.hsv(v1.min(0.999), v2, v3);
	});
	color;
};

Button.new(window, Rect(10, 200, 100, 50))
.states_([["RGB", Color.white, Color.red],["HSV", Color.white, Color.black]])
.action_({arg me; if (me.value == 0) {flag = \rgb}{flag = \hsv}});

//procedural approach for array construction
guiArr = Array.fill(3, {arg i;
	[
		Slider(window, Rect(10, (step + 10*i + 10), 100, step)),
		StaticText(window, Rect(120, (step + 10*i + 10), 120, step))
	]
});

guiArr.do {|item, index| //item: each array element; index: array box value
	item[0].action_{arg me;
		item[1].string_(me.value);
		colorArr[index] = me.value;
		window.background_(colorF.value(flag, colorArr));
}};

)


/*Looping operations on array*/
(
var pippo;
pippo = Array.fill(5, {arg i; (i*2)/5});
pippo.do {|item, index|
	[
		item.post;
		(" ").post;
		index.postln;
	]
};
)


