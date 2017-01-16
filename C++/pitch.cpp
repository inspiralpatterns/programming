/***pitch.cpp
 *pitch extraction using short-time AMDF function frame-by-frame
 *block diagram:
 *a) input;
 *b) filtering;
 *c) windowing;
 *d) AMDF;
 *e) output pitch array;
 *
 *BUGS
 *a) pitch-period results incorrect;
 *b) why negative differences? They should be larger than zero;
 *
 ***/

#include <iostream>
#include <cmath>
#include "WavFile.h"

#define M_PHI 3.14159265

using namespace std;

float filter (float* sig, int len, float del, int f, int SR, long sign){
    
    /*calculating filter coefficients*/
    float k = cos(2.0 * M_PHI * f / SR);
    float b = (sqrt((2.f - k) * (2.f - k) - 1.0) - 2.f + k) * sign;
    float a = 1.0 + (b * sign);
    
    /*processing*/
    for (int i = 0; i < len + 1; i++){
    sig[i] = a * sig[i] - b * del;
    del = sig[i];/*feedback part of IIR implementation*/
    }
    
    return *sig;
}

float amdf (float* sig, float* diff, int N, int lag, int maxlag, int init_lag, float* tmp, int SR){
    int n;
    int index;/*store lag value at minimum found*/
    for (n = 0; n < N ; n++){
        do {
            tmp[lag] = sig[n] - sig[lag];/*difference between signals*/
            tmp[lag] = sqrt(tmp[lag] * tmp[lag]);/*get the magnitude*/
            tmp[lag] += tmp[lag - 1];/*· of magnitudes difference*/
            lag++;
        } while (lag <= maxlag);
        
        lag = init_lag;
        diff[n] = (1.f / N) * tmp[maxlag];/*heuristics for normalization*/
    }
    
    int min = diff[0];
    for (n = 0; n < N; n++){
        if (diff[n] < min) min = diff[n];
        index = n;
    }
    
    return (float) SR / (float) index;
}

int main (int argc, char** argv){
    /*input file information*/
    WavInFile input(argv[3]);
    int SR = input.getSampleRate ();
    int samples = input.getNumSamples ();
    
    /*define variables*/
    int N = 1024;/*frame in samples*/
    int maxlag = SR * (1.f /atof(argv[1]));/*maximun lag in samples*/
    int lag = SR * (1.f / atof(argv[2]));/*minimum lag in samples*/
    int init = lag;
    
    /*allocating array*/
    float* sig = new float[samples];/*input array*/
    float* diff = new float[N];/*difference array*/
    float* tmp = new float[maxlag + 1];/*store temporary single magnitude values*/
    
    /*reading file and create envelope*/
    input.read (sig, samples);
    
    /*processing*/
    for (int i = 0; i < samples; i += N){
        float f = amdf (sig + i, diff, N, lag, maxlag, init, tmp, SR);
        cout << "F0 = " << f << endl;
    }

    delete[] sig;
    delete[] diff;
    delete[] tmp;
    
    return 0;    
}
