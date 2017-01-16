#include "soundmath.h"
#include <iostream>
#include <cstdio> // lettura e scrittura di file binari

using namespace std;

const int BSIZE = 1024; // buffer size

int main (int argc, char** argv) {
    
    //mixer input.pcm weight1 input2.pcm weight2 output.pcm
    //ex: mixer pippo.pcm .5 pluto.pcm .5 output.pcm
    //argc = 6
    //argv[0] = mixer
    //argv[1] = input.pcm
    //CHAR** è un PUNTATORE DI UN PUNTATORE
    
    
    if (argc != 6) {
        cout << "syntax: mixer input1.pcm weight1 input2.pcm weight2 output.pcm" << endl;
        exit (0);
    }
    
    FILE* input1 = fopen (argv[1], "rb");
    float weight1 = atof (argv[2]); // converte da una stringa a un float
    
    FILE* input2 = fopen (argv[3], "rb");
    float weight2 = atof (argv[4]);
    
    FILE* output = fopen (argv[5], "wb");
    // richiamo alla Reference di fopen dal sito www.cplusplus.com
    
    float* input1buff = new float [BSIZE];
    float* input2buff = new float [BSIZE];
    float* outputbuff = new float [BSIZE];
    
    // condizione di stop errata (va considerato il file più lungo)
    while (!feof (input1) && !feof (input2)){
        if (feof (input1)) {
            memset (input1buff, 0, sizeof (float) * BSIZE);
        } else {
            fread ((void*) input1buff, sizeof (float) * BSIZE, 1, input1);
            mulF_v (input1buff, dB2lin (weight1), input1buff, BSIZE);
            //moltiplica vettore con scalare in-place
            
        // (void*) indica un casting, ovvero un passaggio dal float precedente a un tipo 'vuoto'.
        //E' generica, ma occorre sempre definire il tipo di dati.
        }
        
        if (feof (input2)) {
            memset (input2buff, 0, sizeof (float) * BSIZE);
        } else {
            fread ((void*) input2buff, sizeof (float) * BSIZE, 1, input2);
            mulF_v (input2buff, dB2lin (weight2), input2buff, BSIZE);
            // è possibile sovrascrivere dal momento che in c++ tutte le operazioni
            //sono in ordine.
        }
        
        sumF_v (input1buff, input2buff, outputbuff, BSIZE);
        
        fwrite ((void*) outputbuff, sizeof (float) * BSIZE, 1, output);
        
        }
    
    delete [] input1buff;
    delete [] input2buff;
    delete [] outputbuff;
    
    fclose (input1);
    fclose (input2);
    fclose (output);
    
    return 0;
}