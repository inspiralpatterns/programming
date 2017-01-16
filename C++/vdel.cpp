/***vdel.cpp
 *variable delay with circular buffer
 *and different reading and writing pointers.
 *quote from: https://ccrma.stanford.edu/~jos/pasp/Variable_Delay_Lines.html
 
 *linear interpolation: out = frac * del[rpi+1] + (1 - frac) * del[rpi]
 *                      frac = rp - rpi
 *phasor frequency: pf = (1 - semitone_ratio) * (dt/1000))
 *
 *BUGS
 *a) if interval == 0, the compiler quits the program (abort trap: 6);
 *b)
 ***/

#include <iostream>
#include <cmath>
#include "WavFile.h"

#define SR 44100
#define TWOPI 6.2829

using namespace std;

void phasor (double* table, int len){
    int pos;
    for (pos = 0; pos < len; pos++){
        table[pos] = (double) pos / (double) len;
    }
}

void mkwindow (double* table, int len, float a0, float a1, float a2) {
    for (int i = 0; i < len; ++i) {
        table[i] = a0 - a1 * cos ((TWOPI * (float) i) / (len - 1)) + a2 * 
        cos ((2 * TWOPI * (float) i) / (len - 1));
    }
}

int main (int argc, char** argv){
    cout << "[pattern's shifter, v. 0.1beta]" << endl;
    cout << "Making silly pitch shifting FOR FREE!" << endl << endl;
    
    if (argc != 4) {
        cout << "Error! Usage: interval infile.wav outfile.wav" << endl;
        cout << "(negative intervals for downward shifting)" << endl;
        return -1;
    }
    
    /*declaring variables*/
    int interval = atof(argv[1]);
    double dtime = 100.f;/*assuming delay time = 0.1 sec;*/
    int dt = dtime*SR/1000;/*dtime in samples*/
    double out, frac, pf, ratio;
    int next;
    double psamples = 44100.f;
    
    /*input file*/
    WavInFile input(argv[2]);
    int sr = input.getSampleRate ();
    int bits = input.getNumBits ();
    int nchan = input.getNumChannels ();
    int samples = input.getNumSamples ();
    
    /*output file*/
    WavOutFile output(argv[3], sr, bits, nchan);

    /*allocating memory*/
    float* sig = new float[samples + dt];/*input and output vector*/
    memset (sig, 0, sizeof (float)*(samples + dt));
    float* del = new float[dt];
    
    /*calculating phasor frequency*/
    ratio = pow(2.0, 1/12.0);
    ratio = pow (ratio, interval);
    cout << "ratio: " << ratio << endl;
    pf = (1 - ratio) * (dt / 1000.0);
    cout << "phasor frequency: " << pf << endl << endl;
    psamples /= pf;
    psamples = abs (psamples);
    psamples = floor (psamples);
    
    /*create a phasor*/
    double* table = new double[(int) psamples];
    phasor (table, (int) psamples);
    
    /*create an envelope*/
    double* envelope = new double[(int) psamples];
    //mkwindow (envelope, (int) psamples, .5, .5, 0);/*hann function*/
    
    int rpi;/*reading position index*/
    int wp = 0;/*writing position index*/
    double rp;/*fractional reading position index*/
    int pos = 0;
    
    /*reading input file*/
    input.read(sig, samples);
    
    /*processing*/
    for (int k = 0; k < samples + dt; k++){
        /*calculate reading position*/
        if (interval < 0){
            rp = (double) wp - (double) dt * table[pos];
            pos = (pos != psamples - 1 ? pos + 1 : 0);/*read the phasor table from beginning to end*/
        }
        else {
            rp = (double) wp - (double) dt * table[((int)psamples-1) - pos];
            pos = (pos != psamples - 1 ? pos + 1 : 0);/*read the phasor table from end to beginning*/
        }
        
        /*modulus operations for reading position right range*/
        if (rp < 0) rp += (double) dt;
        else {
            if (rp >= dt - 1) rp -= (double) dt - 1;
            else rp = rp;
        }
        
        /*calculate reading position indexes*/
        rpi = floor(rp);
        
        /*calculate fractional part of them*/
        frac = rp - (double) rpi;
        if (rpi == dt - 1) next = 0;
        else next = rpi + 1;
        
        out = (frac * del[next] + (1.0 - frac) * del[rpi]);/*linear interpolation*/
        del[wp] = sig[k];
        sig[k] = out;
        
        /*updating writing pointer*/
        if (wp > dt - 1) wp = 0;
        else wp++;
    }
    
    /*writing output file*/
    output.write(sig, samples + dt);
    
    delete [] sig;
    delete [] del;
    delete [] table;
    delete [] envelope;
    
    return 0;
}

/*EOF*/