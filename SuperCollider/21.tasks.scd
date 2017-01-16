/*TASKS
They are similar to routines, but it's possible to pause the process
with pause method, while using routines it's not.

Task is a pauseable process.
*/


/*task declaration*/
(
t = Task.new({
	10.do {
		arg i;
		i.post; " step(s) from here".postln;
		1.wait}
});
)

t.play;

/*pause the process*/
t.pause;
t.stop;

/*start from last internal status*/
t.resume;
t.play;


/*DISCUSSION
- pause and stop have the same function here, as play and resume;
- it needs to reset the task before starting it again.
The reset routine's method acts also for task class.
*/

