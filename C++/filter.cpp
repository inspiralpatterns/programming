/***filter.cpp
 *simple implementation of a first-order filter
 *f = cutoff frequency (hz)
 *
 *filter equation:
 *y(n) = a * x(n) - b* y(n - 1)
 *
 *filter coefficient:
 *a = 1 + (b * sign)
 *b = (sqrt(pow(k, 2) - 1) - k) * sign
 *with k = 2 - cos(2 * M_PHI * f / SR)
 *sign: determine low pass or high pass character
 * sign = 1.......low pass
 * sign = -1......high pass
 *
 *BUGS:
 *a) high pass mode (sign = -1) seems not working;
 ***/

#include <iostream>
#include <cmath>
#include "WavFile.h"

#define SR 44100
#define M_PHI 3.14159265

float filter (float* sig, int samples, float del, int f, long sign){
    
    /*calculating filter coefficients*/
    float k = cos(2.0 * M_PHI * f / SR);
    float b = (sqrt((2.f - k) * (2.f - k) - 1.0) - 2.f + k) * sign;
    float a = 1.0 + (b * sign);
    
    /*processing*/
    for (int i = 0; i < samples + 1; i++){
    sig[i] = a * sig[i] - b * del;
    del = sig[i];/*feedback part of IIR implementation*/
    }
    
    return *sig;
}

int main (int argc, char** argv){
    /*cutoff frequency*/
    int f = atof(argv[1]);
    long sign = atof(argv[2]);
    
    /*input file*/
    WavInFile input(argv[3]);
    int sr = input.getSampleRate ();
    int bits = input.getNumBits ();
    int nchan = input.getNumChannels ();
    int samples = input.getNumSamples ();
    
    /*output file*/
    WavOutFile output(argv[4], sr, bits, nchan);
    
    float* sig = new float[samples + 1];
    float del = 0;/*unity delay*/
    
    input.read(sig, samples);
    filter(sig, samples, del, f, sign);
    output.write (sig, samples + 1);
    
    delete [] sig;
    
    return 0;
}

/***EOF***/