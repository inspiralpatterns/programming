#include <iostream>
#include "WavFile.h"

using namespace std;

#define SR 44.1

int main(int argc, char** argv){
    float dtime = atof(argv[1]);
    int dt = dtime*SR;/*ms to samples delay duration*/

    /*input file*/
    WavInFile input(argv[2]);
    int sr = input.getSampleRate ();
    int bits = input.getNumBits ();
    int nchan = input.getNumChannels ();
    int samples = input.getNumSamples ();
    
    /*output file*/
    WavOutFile output(argv[3], sr, bits, nchan);
    
    float* sig = new float[samples + dt];/*input and output vector*/
    float* del = new float[dt];

    /*reading input file*/
    input.read(sig, samples);
    
    /*processing*/
    for (int i = 0, k = 0; k < samples + dt; k ++){
        float out;
        out = del[i];
        del[i] = sig[k];
        sig[k] += out;
        sig[k] /= 2.f;
        if (i == dt - 1) i = 0;
        else i++;
    }
    
    /*writing output file*/
    output.write(sig, samples + dt);
    
    delete [] sig;
    delete [] del;
    
    return 0;
}

/*EOF*/