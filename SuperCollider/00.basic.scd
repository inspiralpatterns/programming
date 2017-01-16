/*SuperCollider basic
press Return button and watch the Post window*/

//mathematics
2.6*3
2**3
4/3
2+3*6

3.pow(3)
3.class //a number itself is an object and takes part of a class

/*Introspection properties*/
Integer.superclasses
Magnitude.allSubclasses
Magnitude.dumpClassSubtree
RawArray.subclasses;

/*all code lines between curves are returned by interpreter
double click after the parenthesis and see what's highlighted*/
(
a = [1, 2, 3];
)

(
("grazie" ++ " " ++ 450).postln;
"grazie" ++ " " ++ 450.asString;
)

/* local VS environmental variables*/
a = [1, 2, 3];
array = [1, 2, 3];

(
var array;
array = [1, 2, 3];
array.postln;
)

~array = [4, 5, 6];
~array;
//all environmental variables starts with 'a...z' or '~' character.

/*Symbols*/
(
a = \symbol;
a.postln;
b = 'sono un simbolo';
b.postln;

(a == b).postln;
(a === b).postln;

b = \symbol;
a == b;
)

(
a = \symbol;
b = \symbol;
[a, b].class.post.name.post.class;
)

/*Functions*/
Function.dumpInterface;

(
g = {arg a, b; (a*2).pow(b)};
g.value(2, 3).postln;
g.value(245, 4);


/*GRAPHICS
plot some breakpoints*/
[5, 6, 7, 6.5, 4.5, 3.5].plot("Some data, in stereo", numChannels:2, discrete: true)

(
b = [{1.0.rand}.dup(50), { 20.0.rand - 30 }.dup(50),{ 10.0.rand }.dup(50)].lace(150);
b.plot(numChannels:3, minval: nil, maxval: nil);
)

(
s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b.plot;
b.plot(minval: nil, maxval: nil);
)

[1, 20, 3, 4.5, 65, 32].plot(name: "test", bounds: 589, numChannels: 1);
