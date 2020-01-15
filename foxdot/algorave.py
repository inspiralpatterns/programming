~p1 >> blip() #+ (0,2,4)
    

~p2 >> dub(
    oct=4,
    dur=PRand(1,4)/10,
    amp=linvar([0, 0.3],8),
    bend=linvar([0, 0.4], 16),
    fmod=2
    )h
    

~p3 >> noise(
    amp=PWhite(0,0.3),
    #chop=PxRand(4,9),
    #room=PDelta([0.1, 0.24, -0.3]),
    #swell=10,
    pshift=36
    )
    

Samples.addPath("/Users/Boggiz/samples")


~s1 >> loop(
    "buzz/Marker 01.wav",
    #3,
    dur=4,     
    stutter=PWalk(16,0.5,4), 
    room=PSine(32)/5+.5, 
    mix=0.6,
    #crush=PxRand(8,16),
    #bend=0.01,
    #shape=0.1
    )
    

~s2 >> stretch(
    "warm_swell/Marker 01.wav",
    dur=8,
    pshift=12,
    amp=linvar([PWhite(0.1,0.2), PWhite(0.3,0.5), 8]),
    #bend=[0, -0.05],
    )
    

~s3 >> stretch(
    "damage_electro_fx/Marker 42.wav",
    dur=3,
    amp=(PSine(32) + 1)/6,
    glide=[-0.5, 0.5]
    )

    
~s4 >> stretch(
    "damage_rim/Marker 23.wav",
    amp=1,
    dur=4,
    echo=16,
    echotime=0.125,
    room=0.5,
    mix=0.5
    )
    

~s5 >> loop(
    "piano_c/Marker 02.wav",
    P[:15].shuffle(),
    dur=16,
    room=0.4,
    mix=0.5,
    delay=[0, PWhite(0.1,0.9)],
    echo=4,
    pshift=2,
    amp=PBern(16, 0.5)
    )
    

~s6 >> loop(
    "high/Marker 11.wav",
    pshift=PRand([-12,12]),
    dur=PDur(3,16),
    )

    
~s7 >> stretch(
    "pulse/Marker 01.wav",
    dur=1/4,
    amp=PEuclid2(5,12,0.1, 0.5),
    spin=16
    )

