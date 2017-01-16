#include "WavFile.h"
#include "dft.h"
#include <iostream>
#include <cmath>

using namespace std;

int pva (float *input, float *output, float *window, int fft_size, int input_size, int hopsize, int sr){
    //allocate memory
    float *signal, *spectrum, old_phi;
    signal = new float[fft_size];
    spectrum = new float[2*fft_size];
    old_phi = new float[fft_size];
    
    //define variables
    int hopsize = fft_size / overlap;       // passo di lettura del file in input
    int posin, posout;                            // puntatori dei vettori in ingresso e uscita al processo
    float phase, delta, mag;
    float pi = (twopi / 2);
    float binfreq = twopi*k/N               //bin center frequency, k: 0, 1, 2...N-1
    float scale = 
    
    for (posin = posout = 0; posin < input_size; posin += hopsize) {
        for (int i = 0; i < fft_size; i++) {
            if (posin < input_size) signal[i] = input[i + hopsize] * window[i];
            else signal[i] = 0;
        }
        
        dft(signal, spectrum, fft_size);
        
        for (k = 0, i = 0; i < (2*fft_size); i++, k++) {
            //cartesian to polar spectral coordinates
            mag = (float) (2 * sqrt (spectrum[2*i] * spectrum[2*i] + spectrum[2*i + 1] * spectrum[2*i + 1]));
            phase = (float) atan2 (spectrum[2*i + 1] / spectrum[2*i]);
            
            delta = phase - old_phi[k];          //phase difference calculation
            old_phi[k] = phase;                     //refresh to the last calculated phase
            
            //phase unwrapping
            while (delta > pi) delta -= twopi;
            while (delta < -pi) delta += twopi;
            
            //construct amp-freq pair
            spectrum[2*i] = mag;
            spectrum[2*i + 1] = delta
        }
        
        
    }
    
    
    
    
    
    return posout;
}






int main {
    
    return 0;
}