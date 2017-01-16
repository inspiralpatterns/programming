#include "WavFile.h"
#include "dft.h"
#include <iostream>
#include <cmath>

using namespace std;

int main (int argc, char **argv ){
    const int N = 8092;
    float * in, *out, *spec;
    
    
    WavInFile input (argv[1]);
    int sr = input.getSampleRate ( );
    int nchan = input.getNumChannels ( );
    int samples = input.getNumSamples ( );
    int bits = input.getNumBits ( );
    
    WavOutFile output (argv[2], sr, bits, nchan);
    
    in = new float[samples];
    out = new float[samples];
    spec = new float[samples*2];
    
    //reading input file
    input.read (in, samples);
    
    //processing
    cout << "processing..." << endl; cout.flush ( );
    dft (in, spec, N);
    idft (spec, out, N);
    
    //writing output data
    output.write (out, samples);
    
    delete [ ] in;
    delete [ ] out;
    delete [ ] spec;
    
    return 0;
}