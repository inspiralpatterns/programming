#include "dft.h"
#include "WavFile.h"
#include <iostream>
#include <cmath>

//STFT implementation
int stft (float *input, float *window, float* output, int fft_size, int input_size, int overlap) {
    //allocate memory
    float *signal, *spectrum;
    signal = new float[fft_size];
    spectrum = new float[2*fft_size];
    
    //define variables
    int hopsize = fft_size / overlap;       //passo di lettura del file in input
    int posin, posout;
    
    //fill signal vector of *input samples
    for (int posin = 0, posout = 0; posin < input_size; posin += hopsize){
        for (int i = 0; i < fft_size; i++) {
            if (posin < input_size) {
                signal[i] = input[i + posin];
                //windowing slice with envelope
                signal[i] *= window[i];      
            }
            else signal[i] = 0;         //zero-padding
        }
        
        //Fourier transform onto the slice
        dft(signal, spectrum, fft_size);
        
        //fill output vector
        for (int i = 0; i < (2*fft_size), posout < (2*input_size); i++, posout++) {
            output[posout] = spectrum[i];
        }
    }
    cout << "...spectrum created" << endl;
    
    //de-allocate memory
    delete [ ] signal;
    delete [ ] spectrum;
    
    return posout;
}


//ISTFT implementation
int istft (float *input, float *window, float* output, int fft_size, int input_size, int overlap) {
    //allocate memory
    float *signal, *spectrum;
    signal = new float[fft_size];
    spectrum = new float[fft_size];
    
    //define variables
    int hopsize = fft_size / overlap;
    int posin, posout;
    int out_size = input_size*hopsize/fft_size;
    
    //fill spectrum vector of *input samples
    for (int posin = 0, posout = 0; posout < out_size; posout += hopsize){
        for (int i = 0; i < fft_size; i++, posin++) {
            spectrum[i] = input[posin];
        }
        
        //inverse Fourier transform onto the spectrum
        idft(spectrum, signal, fft_size);
        
        //windowing and overlap-add
        for (int i = 0; i < fft_size; i++) {
            if (posout + i < out_size) output[posout + i] += signal[i] * window[i];
        }
    }
    cout << "...resynthesis" << endl;
    
    //de-allocate memory
    delete [ ] signal;
    delete [ ] spectrum;
    
    return out_size;
}


int main (int argc, char **argv) {
    cout << "STFT version 0.1" << endl << endl;
    
    try {
        //main variables
        int const fft_size = 128;
        cout << "DFT size: " << fft_size << endl;
        int const overlap = 4;
        int hopsize = fft_size / overlap;
        cout << "hopsize: " << hopsize << " samples" << endl;
        
        //defining input-output files
        WavInFile source (argv[1]);
        int input_size = source.getNumSamples ( );
        cout << "input size: " << input_size << " samples" << endl;
        int sr = source.getSampleRate ( );
        int nchan = source.getNumChannels ( );
        int bits = source.getNumBits ( );
        
        WavOutFile output (argv[2], sr, bits, nchan);
        int out_size = (int) (input_size + fft_size);
        cout << "estimated output: " << out_size << " samples" << endl;
        
        //allocating memory
        float *in, * spec, *window, *out;
        in = new float[input_size];
        spec = new float[2*input_size];
        window = new float[fft_size];
        out = new float[out_size];
        
        //read input file
        source.read (in, input_size);
        cout << "reading input: done" << endl;
        
        //make window function (Hann version)
        for (int i = 0; i < fft_size; i++){
            window[i] = 0.5 - (0.5 * cos (2*acos(-1)*(i / (fft_size - 1))));
            switch (i) {
            case (fft_size - 1):
                cout << "window function: done" << endl;
            }
        }
        
        //processing
        cout << "STFT process:" << endl;
        cout << "...working" << endl;
        stft (in, window, spec, fft_size, input_size, overlap);
        cout << "...done" << endl;
        
        cout << "Inverted STFT process: " << endl;
        cout << "...working" << endl;
        istft(spec, window, out, fft_size, input_size, overlap);
        cout << "...done" << endl;
        
        //write out file
        cout << "writing data" << endl;
        output.write (out, out_size);
        
        //de-allocating memory
        delete [ ] in;
        delete [ ] out;
        delete [ ] spec;
        delete [ ] window;
    } catch (exception& e) {
        cout << e.what () << endl;
    }
    
    return 0;
}

// EOF