/*WAVETABLE SYNTHESIS II
Osc can also read from an existent audio signal, i.e. a soundfile
previously recorded and stored on hard disk.
In this case, it must convert Signal class in Wavetable class*/

(
/*generate the signal and convert it to wavetable format*/
a = Signal.new;
a = Signal.sineFill(2.pow(10), [1.0]);
a.asWavetable;

/*it's possible generating also not periodic signal:
a = Signal.fill(2.pow(12), {2.0.rand-1}).asWavetable;
a.plot;
*/

/*write the signal into an audio file
***tips: how to create a soundfile - required steps
1. create an instance of SoundFile class;
2. choose the desired raw file parameters;
3. create the header of a file;
4. write the signal to the sampled time buffer;
5. close the soundfile
***/
f = SoundFile.new;
f.headerFormat_("WAV").sampleFormat_("int16").numChannels_(1);
f.openWrite("/Users/Boggiz/Desktop/test.wav");
f.writeData(a);
f.close;
)


/*create SynthDef that reads audio files*/
(
SynthDef(\tableOsc, {arg freq = 440, amp = 0.1, buf;
	Out.ar(0, Osc.ar(buf, freq, 0, amp))};
).add;
)


/*allocate a buffer for SynthDef and fill it with the
soundfile previously created*/
(
b = Buffer.read(s, "/Users/Boggiz/Desktop/test.wav");
x = Synth.new(\tableOsc, [\freq, 220, \buf, b]);
)

/*live interaction*/
x.set(\freq, 440);
x.set(\amp, 0.05);

s.freeAll;


