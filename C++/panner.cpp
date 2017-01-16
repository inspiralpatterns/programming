#include "soundmath.h"
#include <iostream>
#include <cstdio> // lettura e scrittura di file binari

using namespace std;

const int BSIZE = 1024; // buffer size

int main (int argc, char** argv) {
    //panner output.pcm, gain, *.pcm (numero variabile di inlet)
    
    
    
    if (argc < 4) {
        cout << "syntax: panner output.pcm gain_dB file1.pcm file2.pcm ..." << endl;
        exit (0);
    }
    
    int fnum = argc - 3; // numero di file da mixare
    
    float gain_linear = dB2lin (atof (argv[2]));
    
    FILE** input_files = new FILE*[fnum];
    
    int maxsamples = 0;
    int* samples = new int[fnum];
    
    for (int i = 0; i < argc; i++) {
        input_files[i] = fopen (argv[i + 3], "rb");
        fseek (input_files [i], 0, SEEK_END); // posiziona alla fine del file
        fpos_t val = 0;
        fgetpos (input_files[i], &val);
        rewind (input_files[i]);
        
        samples[i] = val / sizeof (float);
        if (maxsamples < samples[i] ) {
            maxsamples = samples[i];  //max dei campioni
        }           
        
        
        
    }
    
    cout << "max lenght = " << maxsamples << endl;
    
    float* output = new float[2 * maxsamples]; // alloco vettore di uscita
    
    float pan_incr = 1. / (fnum - 1);
    float pan = 0;
    
    float norm = 1. / fnum;
    
    for (int i = 0; i < fnum; i++){
        float* input = new float[sampples[i]];
        fread (input, sizeof (float) * samples[i], 1, input_files[i]);
        
        //bisogna moltiplicare per numeri pari e dispari per effettuare la stereofonia
        
        for (int j = 0; j < samples[i]; j++)Ê{
            output[2 * j] += ((1. - pan) * input[j] * norm);  // interleave sui due canali
            output[2 * j + 1] += ( pan * input [j] * norm);// la funzione += somma su se stesso
              
        }
        
        delete [ ] input;
        fclose (input_files[i]);
        
        cout << argv [i+3] << " = " << samples[i]
        << "samples," <<  pan << " l/r" << endl;
        // assumiamo che il campione sia float
        // il computer restituisce i valori in bytes
        
        pan += pan_incr;
        
    }
    
    mulF_v (output, gain_linear, output, 2 * maxsamples); // riscalatura in-place
    FILE* outputfile = fopen (argv[1], "wb");
    fwrite (output, sizeof (float) 2 * maxsamples, 1, outputfile);
    fclose (outputfile);
    
    delete [ ] output;
    delete [ ] samples;
    
    
    return 0;
}