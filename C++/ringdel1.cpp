/***ringDelay.cpp
 *delay with circular buffer
 *pointers to array version
 ***/


#include <iostream>
#include <cstring>

#include "WavFile.h"

#define SR 44.1
#define buffersize 44100

using namespace std;

int main (int argc, char** argv){
    cout << "[ringDelay v 0.1]" << endl;
    cout << "fixed-delay based on a circular buffer" << endl;
    
    if (argc != 4) {
        cout << "syntax: del time (ms) infile.wav outfile.wav" << endl;
        return 1;
    }
    else {
        /*declaring variables*/ 
        float dtime = atof(argv[1]);
        int del = dtime*SR; /*delay in samples*/
        
        /*input file*/
        WavInFile input(argv[2]);
        int sr = input.getSampleRate ();
        int bits = input.getNumBits ();
        int nchan = input.getNumChannels ();
        int samples = input.getNumSamples ();
        
        /*output file*/
        WavOutFile output(argv[3], sr, bits, nchan);
        
        /*allocating memory*/
        float* ringbuffer = new float[buffersize];/*circular buffer*/ 
        float* _data = new float[samples + del];
                
        /*processing*/
        for (int j = 0; j < samples + del; j += buffersize){
            for (int i = 0; i < buffersize; i++){
                input.read(_data, buffersize);/*QUESTION
                                               *how to update (e.g. read from buffersize to buffersize*2)?
                                               *need pointer?*/
                if (i < del){
                    ringbuffer[i] = _data[i];
                }
                else {
                    ringbuffer[i] = _data[i];
                    _data[i] += ringbuffer[i - del];
                    _data[i] /= 2; /*normalize*/
                }
            }
        }
        
        //writing output file
        output.write(_data, samples + del);

        delete[] _data;
        delete[] ringbuffer;
    }
    
    return 0;
}