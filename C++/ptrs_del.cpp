/***ringDelay.cpp
 *delay with circular buffer
 *pointers to pointers version
 ***/

#include <iostream>
#include <cstring>

#include "WavFile.h"

#define SR 44.1
#define buffersize 1024

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
        float** rp;
        float** wp;
        
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
        
        /*setting pointers*/
        rp = &ringbuffer;
        wp = &ringbuffer;
        cout << ringbuffer << endl;
        cout << *rp << endl;
        cout << *wp << endl;
        
        /*processing*/
        for (int j = 0; j < samples + del; j += buffersize){
            for (int i = 0; i < buffersize; i++){
                input.read(_data, buffersize);/*QUESTION
                                               *how to update (e.g. read from buffersize to buffersize*2)?
                                               *need pointer?*/
                if (i < del){
                    **wp = _data[i];
                }
                else {
                    **wp = _data[i];
                    _data[i - del] = **rp + _data[i - del];
                    _data[i - del] /= 2; /*normalize*/
                    *rp = &ringbuffer[(i - del) + 1];/*QUESTION
                                                      *segmentation fault when here*/
                }
                *wp = &ringbuffer[i + 1];
            }
        }
        
        //writing output file
        output.write(_data, samples + del);

        delete[] _data;
        delete[] ringbuffer;
    }
    
    return 0;
}