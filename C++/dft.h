#include <iostream>
#include <cmath>

using namespace std;

const double twopi = 2 * acos(-1);
//acos(-1) = 3.141529 rad

//DFT EXPRESSION ARGUMENTS:
//i == pointer to *out
//k == 0, 1, 2...(N - 1)  frequency points ~ bins
//N = DFT size
// n == 0, 1, 2...(N -1) pointer to *in

void dft (float *in, float *out, int N) {
    for (int i = 0, k = 0; k < N; i++, k++) {
        
        //CALCOLO DEI COEFFICIENTI SPETTRALI
        //create complex values per each input signal sample
        //e^-i2¹kn/N == [cos(2¹kn/N) - sin(2¹kn/N)]
        for (int n = 0; n < N; n++) {
            out[2*i] += in[n]*cos(k*twopi*n/N);        //real part
            out[2*i+1] -= in[n]*sin(k*twopi*n/N);      //imag part
        }
        
        //normalize each output signal sample
        out[2*i] /= N;
        out[2*i+1] /= N;
    }
}

//IDFT EXPRESSION ARGUMENTS:
//i == pointer to *in
//n == pointer to *out
//k == frequency points ~ bins
//takes an input spectrum signal made of N complex spectral coefficient pairs
//outputs a real sign made of N real samples

void idft (float *in, float *out, int N) {
    for (int n = 0; n < N; n++) {
        for (int i = 0, k = 0; k < N; k++, i++) {
            out[n] += in[2*1]*cos(twopi*k*n/N) - in[2*i + 1]*sin(twopi*k*n/N);
        }
    }
}

///EOF