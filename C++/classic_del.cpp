/*del.cpp
 *fixed-time delay
 */

#include <iostream>
#include "WavFile.h"

using namespace std;

int main (int argc, char** argv){
    if (argc != 4) {
        cout << "syntax: del time (ms) infile.wav outfile.wav" << endl;
        return 1;
    }
    else {
        //declaring variables 
        float SR = 44.1;
        float dtime = atof(argv[1]);
        int del = dtime*SR;
        
        //input file
        WavInFile input(argv[2]);
        int sr = input.getSampleRate ();
        int bits = input.getNumBits ();
        int nchan = input.getNumChannels ();
        int samples = input.getNumSamples ();
        
        //output file
        WavOutFile output(argv[3], sr, bits, nchan);
        
        //allocating memory
        float* input_data = new float[(samples + del)];
        memset (input_data, 0, sizeof (float) * (samples + del));
        float* output_data = new float[(samples + del)];
        memset (output_data, 0, sizeof (float) * (samples + del));
        
        //reading input file
        input.read (input_data, samples);
        cout << "processing..." << endl;
        
        //processing
        for (int i = 0; i < (samples + del) ; i++){
            if (i < del) output_data[i] = input_data[i];
            else output_data[i] = input_data[i] + input_data[i - del];
            //normalize
            output_data[i] /= 2;
        }
        
        //writing output file
        output.write(output_data, (samples + del));
        cout << "done" << endl;
        
        delete[] input_data;
        delete[] output_data;
    }
    
    return 0;
}