// Definition of synth in SuperCollider

(
    SynthDef.new(\mads, { | dur=1, attack=0.1, release= 0.9, freq=440, amp=0.25, pan=0, out=0|
        var sig; // the sound
        var env; // the envelope

        /*create envelope*/
        env = EnvGen.kr(
            Env.perc(attack, release),
            gate: 1.0,
            timeScale: 1.0,
            doneAction: 2 /*synth deallocation*/
        );
    
        /*audio signal*/
        sig = LFTri.ar(freq);
        /*apply envelope and amp scaling*/
        sig = sig * env;
        sig = sig * amp;
        
        Out.ar(out, sig);
    }).add
)
