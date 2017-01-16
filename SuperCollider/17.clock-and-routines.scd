/*CLOCK AND ROUTINES
SuperCollider provides clock class in order to manage temporal execution of
different events on language side (interpreter).
- on the server side, there are signals and Demand ugen*/


/*use of SystemClock class
this event is scheduled to play after 3-second interval
Delta expressed in seconds with SystemClock*/
(
"waiting".postln;
SystemClock.sched(3.0, {"event arrived".postln});
)


/*use of TempoClock class
set the scheduling using musical tempo definitions (i.e. bps).
Delta expressed in beats with TempoClock*/
(
var tempo1, tempo2, tempo3;
"waiting".postln;
tempo1 = TempoClock(240/60);
tempo2 = TempoClock(120/60);
tempo3 = TempoClock(60/60);
tempo1.sched(2.0, {"event arrived - tempo = 240bpm".postln});
tempo2.sched(2.0, {"event arrived - tempo = 120bpm".postln});
tempo3.sched(2.0, {"event arrived - tempo = 60 bpm".postln});
)

/*use of AppClock class : only for GUI scheduling
(low-priority taks)*/



/*routines generally are used for scheduling
minimal routine: a function prints the string on Post window
when it's called with next method*/
(
r = Routine.new({
	"yep! now".postln;
	2.wait;
	"yep! after two seconds".postln}
);
)

r.next; //call the routine
SystemClock.play(r);

/*discussion:
- next method doesn't execute all the routine at once, but only a task
(it must call this method again to go through the routine completely);
- when executed, it needs to reset the routine to play it once again;
- SystemClock's play method performs a complete routine evaluation;
- wait method acts as a routine suspension*/


(
r = Routine.new({
	10.do{arg x;
		(x * 0.3).wait;
		"slow down".postln;};
	1.wait;
	"the ".post;
	1.wait;
	"end".postln;
	}
);
)

SystemClock.play(r);
r.reset;
/*then*/
SystemClock.play(r);


/*use of fork method to compile and play a routine from a function*/
{10.do{arg x; x.postln; (x*0.5).wait}}.fork;

