/***ringDelay.cpp
 *delay with circular buffer
 *pointers to pointers
 *(Lazzarini, p. 492 version)
 ***/

#include <iostream>
#include "WavFile.h"

using namespace std;

#define SR 44.1
float delay (float* sig, int dt, float* del_buffer, float* dp, float* sp, int vecsize){
    float out;/*store copied sample to output it*/
    for (int i = 0; i < vecsize; i++){
        out = *dp;
        *dp = *sp;
        *sp += out;/*slap-back echo*/
        *sp /= 2;/*normalize*/
        sp += 1;
        if (dp == &del_buffer[dt - 1]) dp = del_buffer;
        else dp += 1;
    }
    return *sp;
}

int main(int argc, char** argv){
    int vecsize;
    float dtime = atof(argv[1]);
    int dt = dtime*SR;/*ms to samples delay duration*/
    
    /*input file*/
    WavInFile input(argv[2]);
    int sr = input.getSampleRate ();
    int bits = input.getNumBits ();
    int nchan = input.getNumChannels ();
    int samples = input.getNumSamples ();
    
    vecsize = 44100; /*QUESTION
                       *output is dependent from vecsize, instead of delay time
                       *why?*/
    /*output file*/
    WavOutFile output(argv[3], sr, bits, nchan);
    
    float* sig = new float[samples + dt];/*input and output vector*/
    memset (sig, 0, sizeof (float)*samples + dt);
    float* sp;/*pointer to sig*/
    float* del = new float[vecsize];
    float* dp;/*pointer to del*/
    dp = del;
    sp = sig;
    
    /*reading input file*/
    input.read(sig, samples);
    
    /*processing*/
    for (int k = 0; k < samples + dt; k += vecsize){
        delay (sig, dt, del, dp, sp, vecsize);
        sp = &sig[k + vecsize];
    }
    
    /*writing output file*/
    output.write(sig, samples + dt);
    
    delete [] sig;
    delete [] del;
    
    return 0;
}