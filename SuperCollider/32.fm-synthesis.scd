/*FREQUENCY MODULATION
case of FM synthDef based not on Carrier (C) and Modulator (M).
The degree of modulation is given by C:M ratio.
A base frequency is given, so to multiplicate the modulator in
the appropriate way to achive a specific ratio.
It's also given FM depth and output gain*/


(
SynthDef(\fm, {arg basefreq = 220, amp = 0.2,
	carrier = 1, modulator = 1, depth = 20;
	Out.ar(bus: 0,
		channelsArray: Pan2.ar(
			in: SinOsc.ar(
			freq: basefreq + SinOsc.ar(
				freq: basefreq * modulator / carrier,
				mul: depth),
			mul: amp),
			pos: LFNoise1.kr(3));
	)};
).add;
)


/***DISCUSSION***/
/*2:1 ratio*/
Synth.new(\fm, [\modulator, 0.5]);

/*1:2 ratio*/
Synth.new(\fm, [\modulator, 2]);

/*1:1 ratio*/
Synth.new(\fm);

/*3:2 ratio*/
Synth.new(\fm, [\modulator, 1.5]);

/*5:2 ratio
compressed spectrum*/
Synth.new(\fm, [\modulator, 0.4]);

/*2:5 ratio
expanded spectrum*/
Synth.new(\fm, [\modulator, 2.5]);

/*2,01:1 ratio
quasi-harmonic spectrum (reproduces natural inharmonics*/
Synth.new(\fm, [\modulator, 0.4975]);



/***INTERFACE DESIGN
1. every fm parameter has its slider and number box to be modified;
2. changes in slider should affect the related number box, and viceversa.
TIPS
- item.action_ assign a specific action to a graphic object;
- item.value_ assign a specific value to a graphic object;
- sliders output a 0-127 range value, so it should be scaled
***/
(
var fm = Synth.new(\fm);
var freqrange = 2000;
var num = 30;
var w = Window.new("FM", Rect.new(100, 100, 220, 440)).front;
var sl = Array.fill(4, {arg i; Slider.new(w, Rect.new(i*50+10, 10, 50, 350))});
var nb = Array.fill(4,  {arg i; NumberBox.new(w, Rect.new(i*50+10, 360, 40, 20)).scroll_step_(0.01)});
["base freq", "C", "M", "depth"].do{
	arg item, index;
	StaticText.new(w, Rect.new(index*50+10, 390, 40, 30)).string_(item).align_(\center)
};

sl[0].action_{arg sl;
	var val = sl.value*freqrange;
	fm.set(\basefreq, val);
	nb[0].value_(val);
};
nb[0].action_{arg nb;
	var val = nb.value;
	fm.set(\basefreq, val);
	sl[0].value_(val/freqrange);
};

sl[1].action_{arg sl;
	var val = (sl.value*num) + 1;
	fm.set(\carrier, val);
	nb[1].value_(val);
};
nb[1].action_{arg nb;
	var val = nb.value;
	fm.set(\carrier, val);
	sl[1].value_(val/num);
};

sl[2].action_{arg sl;
	var val = sl.value*num;
	fm.set(\modulator, val);
	nb[2].value_(val);
};
nb[2].action_{arg nb;
	var val = nb.value;
	fm.set(\modulator, val);
	sl[2].value_(val/num);
};


sl[3].action_{arg sl;
	var val = sl.value*1000;
	fm.set(\depth, val);
	nb[3].value_(val/1000);
};
nb[3].action_{arg nb;
	var val = nb.value;
	fm.set(\depth, val*1000);
	sl[3].value_(val);
};

)


s.freeAll;