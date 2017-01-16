/*STOPWATCH
how to create a GUI to measure time intervals in seconds*/


thisThread.seconds;
/*represent the current Thread.
This specically prints the elapsed seconds from session start*/

(
var x = 10, y = 120, w;//GUI variables
var clockField;
var r; //routine variable
var startTime = thisThread.seconds; //systemclock scheduling

//build GUI
w = Window.new("stopwatch", Rect.new(x, y, 200, 60));
clockField = StaticText.new(w, Rect.new(5, 5, 190, 30)).align_(\center).stringColor_(Color(1.0, 0.0, 0.0)).background_(Color(0, 0, 0)).font_(Font(Font.defaultMonoFace, 24));

//do the routine
r = Routine.new({
	loop({
		clockField.string_((thisThread.seconds - startTime)
			.asInteger.asTimeString);
		1.wait});
	}).play(AppClock);

w.front;
w.onClose_({r.stop});
)


/*CASE 2
It's possible to use SystemClock scheduling for GUI instead
AppClock adding to the function 'defer' method.
The function will be evaluated at server priority when CPU is free*/

r = Routine.new({
	loop({

		{clockField.string_((thisThread.seconds - startTime)
			.asInteger.asTimeString)}.defer;

		1.wait});
	}
).play(SystemClock);
