/*OPERATIONS ON SOUNDFILES*/
/*CUT AND SPLICING*/

(
var sig, out;
var f = SoundFile.new;
var block, incr;
var step, numChunks, tail, indexes;

/*reading and copy from source to a buffer*/
f.openRead("Volumes/patterns/Musica Elettronica/Samples/Concert samples/le-attese-silenziose.aif");
//open from absolute path
//insert your absolute path to select a file of yours
sig = Signal.newClear(f.numFrames);
out = Signal.new;
f.readData(sig);
f.close;


/*cut and splice*/
step = 4410; //chunks dimension (in samples)
numChunks = ((sig.size)/step).asInteger;
tail = sig.size - (step*numChunks); //sig tail
indexes = Array.series(numChunks).scramble;

indexes.do {arg i;
	incr = ((i+1)*step) -1;
	block = sig.copyRange(i*step, incr);
	out = out.addAll(block);
	/*print every slice (start and ending position in samples)*/
	(i*step).asString.post ++ " ".post;
	incr.postln;
};

tail = sig.copyRange(sig.size - tail, sig.size);
out = out.addAll(tail);
out.addAll(tail);

out.plot("cut and splice", 1200);
out.play(false, 0.3, 1);
)
