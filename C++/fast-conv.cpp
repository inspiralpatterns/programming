#include "dft.h"
#include "WavFile.h"

#include <iostream>
#include <cmath>

using namespace std;

//**FAST CONVOLUTION FUNCTION**
//use the DFT for fast convolution between two spectra signals
void convolution (float *impulse, float *input, float *output, int impulse_size, int input_size) {
    
    float *im_spec, *in_spec, *out_spec;      //spectral vectors 
    float *signal_in, *signal_out, *overlap;        //time-domain vectors 
    
    const int fft_size = 4096;           //transform size
    int overlap_size;
    
    overlap_size = impulse_size - 1;
    
    //allocating memory for spectral vectors
    im_spec = new float[2*impulse_size];
    in_spec = new float[2*input_size];
    out_spec = new float[2*(impulse_size+input_size)];
    
    //allocating memory for time-domain vectors
    signal_in = new float[impulse_size];
    signal_out = new float[(impulse_size+input_size)];
    overlap = new float[overlap_size];
    
    //initialize overlap vector
    for (int k = 0; k < impulse_size; k++) {
        overlap[k] = 0.f;
    }
    
    //get the impulse into the FFT input vector
    for (int i = 0; i < impulse_size; i++) {
        signal_in[i] = impulse[i];
    }
    
    //DFT for impulse
    dft (signal_in, im_spec, fft_size);
    
    //processing loop
    //n: to fill signal_in, range from 0 to impulse_size
    //i: pointers to input vector, range from 0 to input_size
    //j: pointer to spectra
    //k: pointer to output and overlap vectors
    
    for (int i = 0; i <= input_size;) {
        for (int n = 0; n <= impulse_size; n++) {
            //fill DFT input vector
            if (n <= impulse_size) {
                signal_in[n] = input[i];
                i += 1;
            }
        }
            
        //DFT for input signal time slice
        dft (signal_in, in_spec, fft_size);
         
        //spectra multiplication
        //(a + ib)(c + id) == (ac - bd) + i(ad + bc)
        for (int j = 0; j < 2*(impulse_size+input_size); j += 2){
            out_spec[j] = in_spec[j]*im_spec[j] - in_spec[j + 1]*im_spec[j + 1];
            out_spec[j + 1] = in_spec[j]*im_spec[j + 1] + in_spec[j + 1]*im_spec[j];
        }
          
        //IDFT for fast convolution
        idft (out_spec, signal_out, fft_size);
            
        //overlap-add
        for (int k = 0; k < input_size+impulse_size; k++) {
            if (k <= impulse_size) {
                output[k] = signal_out[k];
                output[k + impulse_size] = overlap[k];
            }
            else if (k <= input_size+impulse_size) {
                overlap[k - impulse_size] = signal_out[k + impulse_size];
            }
        }
    }
    
    //de-allocating vectors used for fast convolution
    delete [ ] im_spec;
    delete [ ] in_spec;
    delete [ ] out_spec;
    delete [ ] signal_in;
    delete [ ] signal_out;
    delete [ ] overlap;
}


int main (int argc, char **argv) {
    cout << "[fastConvolver, ver. 0.1]" << endl;
    cout << "(convolution through DFT)" << endl << endl;
    
    //argv[1] = nome del file della risposta ad impulso
    WavInFile input1 (argv[1]);
    int samples = input1.getNumSamples ();
    int sr = input1.getSampleRate ();
    int nchan = input1.getNumChannels ();
    int bits = input1.getNumBits ();
    
    int impulse_size = samples;
    
    //argv[2] = nome del file da convolvere
    WavInFile input2 (argv[2]);
    samples = input2.getNumSamples ();
    
    int input_size = samples;
    int out_size = impulse_size + input_size + 1;
    
    //argv[3] = nome del file in uscita
    WavOutFile output (argv[3], sr, bits, nchan);
    
    //allocating read/write memory
    float *impulse = new float[impulse_size];
    float* input = new float[input_size];
    float *out = new float[out_size];
    
    //reading input files
    input1.read(impulse, impulse_size);
    input2.read(input, input_size);
    
    cout << "Impulse size: " << impulse_size << " samples" << endl;
    cout << "Source size: "<< input_size << " samples" << endl;
    cout << "Estimated output size: "<< out_size << " samples" << endl;
    
    //convolution process
    convolution (impulse, input, out, impulse_size, input_size);
    
    //write the output file
    output.write (out, out_size);
    
    //de-allocating input/output memory
    delete [ ] impulse;
    delete [ ] input;
    delete [ ] out;

    return 0;
}