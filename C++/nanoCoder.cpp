// nanoCoder.cpp
// 

#include "WavFile.h" // I/O wave file 16 bit

#include <stdexcept>
#include <iostream>
#include <cmath>

using namespace std;

const int FFTSIZE = 4096;
const int OLAP = 8;
const int HOPSIZE = FFTSIZE / OLAP;

const float TWOPI = M_PI * 2.;
const float sicvt = TWOPI / (double) FFTSIZE;

//windowing per portare a zero gli estremi
//il segnale sottoposto a FFT *dovrebbe* essere periodico
void makeWindow (float* out, int N, float a0, float a1, float a2) {
    // .5, .5, 0     --> hanning
    // .54, .46, 0   --> hamming
    // .42, .5, 0.08 --> blackman
    for (int i = 0; i < N; ++i) {
        out[i] = a0 - a1 * cos ((TWOPI * (float) i) / (N - 1)) + a2 * 
        cos ((2 * TWOPI * (float) i) / (N - 1)); // hamming, hann or blackman
    }
}

void fft (float *fftBuffer, long fftFrameSize, long sign) {
    float wr, wi, arg, *p1, *p2, temp;
    float tr, ti, ur, ui, *p1r, *p1i, *p2r, *p2i;
    long i, bitm, j, le, le2, k;

    for (i = 2; i < 2*fftFrameSize-2; i += 2) {
	for (bitm = 2, j = 0; bitm < 2*fftFrameSize; bitm <<= 1) {
	    if (i & bitm) j++;
	    j <<= 1;
	}
	if (i < j) {
	    p1 = fftBuffer+i;
	    p2 = fftBuffer+j;
	    temp = *p1;
	    *(p1++) = *p2;
	    *(p2++) = temp;
	    temp = *p1;
	    *p1 = *p2;
	    *p2 = temp;
	}
    }
    for (k = 0, le = 2; k < (long)(log(fftFrameSize)/log(2.)); k++) {
	le <<= 1;
	le2 = le>>1;
	ur = 1.0;
	ui = 0.0;
	arg = M_PI / (le2>>1);
	wr = cos(arg);
	wi = sign*sin(arg);
	for (j = 0; j < le2; j += 2) {
	    p1r = fftBuffer+j;
	    p1i = p1r+1;
	    p2r = p1r+le2;
	    p2i = p2r+1;
	    for (i = j; i < 2*fftFrameSize; i += le) {
		tr = *p2r * ur - *p2i * ui;
		ti = *p2r * ui + *p2i * ur;
		*p2r = *p1r - tr;
		*p2i = *p1i - ti;
		*p1r += tr;
		*p1i += ti;
		p1r += le;
		p1i += le;
		p2r += le;
		p2i += le;
	    }
	    tr = ur*wr - ui*wi;
	    ui = ur*wi + ui*wr;
	    ur = tr;
	}
    }
}

// rect to amp-freq
void convert (const float* cbuffer, float* amp, float* freq, float* oldPhi,
              int N, int hop, float R) {
    float osamp = N / hop;
    float freqPerBin = R / (float) N;
    float expct = TWOPI * (float) hop / (float) N;
    for (int i = 0; i < N; ++i) {
        amp[i] = 2. * sqrt (cbuffer[2 * i] * cbuffer[2 * i] + cbuffer[2 * i + 1] * cbuffer[2 * i + 1]);
        float phase = atan2 (cbuffer[2 * i + 1], cbuffer[2 * i]);
        float tmp = phase - oldPhi[i];
        oldPhi[i] = phase;
        tmp -= (float) i * expct;
        int qpd = (int) (tmp / M_PI);
        if (qpd >= 0) qpd += qpd & 1;
        else qpd -= qpd & 1;
        tmp -= M_PI * (float) qpd;
        tmp = osamp * tmp / (2. * M_PI);
        tmp = (float) i * freqPerBin + tmp * freqPerBin;
        freq[i] = tmp;
    }
}

// amp-freq to rect
void unconvert (const float* amp, const float* freq, float* oldPhi, float* cbuffer, int N, int hop, float R) {
    float osamp = N / hop;
    float freqPerBin = R / (float) N;
    float expct = TWOPI * (float) hop / (float) N;

    for (int i = 0; i < N; ++i) {
        float tmp = freq[i];

        tmp -= (float)i * freqPerBin;
        tmp /= freqPerBin;
        tmp = TWOPI * tmp / osamp;
        tmp += (float) i * expct;
        oldPhi[i] += tmp;
        
        float r = (float) rand () / RAND_MAX;
        float p = 0.01 * oldPhi[i];
        
        //@Axel: how can I perform phase locking??
        //       This should be the solution from Puckette95 but does not work
        float phase = (oldPhi[i]); // - oldPhi[i - 1] - oldPhi[i + 1]);

        cbuffer[2 * i] = amp[i] * cos (phase);
        cbuffer[2 * i + 1] = amp[i] * sin (phase);
    }
}

void process (float* window, float* sum_workspace, float* workspace1, float* workspace2, float* sum_amp, float* amp1,
	      float* freq1, float* amp2, float* freq2, float* sum_phi, int fftsize,
	      int hop, int sr, float a_morph, float freq_morph) {
    //transform
    fft (workspace1, fftsize, -1);	//carrier
    fft (workspace2, fftsize, -1);	//modulator
    
    for (int i = 0; i < fftsize; i++) {
	//car to pol
	amp1[i] = 2 * sqrt (workspace1[2 * i]*workspace1[2 * i] +
				      workspace1[2 * i + 1]*workspace1[2 * i + 1]);
	freq1[i] = atan2 (workspace1[2 * i + 1], workspace1[2 * i]);
	amp2[i] = 2 * sqrt (workspace2[2 * i]*workspace2[2 * i] +
				      workspace2[2 * i + 1]*workspace2[2 * i + 1]);
	freq2[i] = atan2 (workspace2[2 * i + 1], workspace2[2 * i]);
	
	//xsynth
	sum_amp[i] = amp1[i];
	sum_phi[i] = freq2[i];
	
	//pol to car
	sum_workspace[2 * i] = sum_amp[i] * cos (sum_phi[i]);
	sum_workspace[2 * i + 1] = sum_amp[i] * sin (sum_phi[i]);
    }
    
    /*// cart to pol coordinates
    convert (workspace1, amp1, freq1, old_phi1, fftsize, hop, sr); 
    convert (workspace2, amp2, freq2, old_phi2, fftsize, hop, sr);
    
    //carrier spectral flattening
    float sigma1, sigma2, flatness;
    
    for (int i = 0; i < fftsize; i++){
	sigma1 += (1 / fftsize) * log (amp1[i]);
	sigma2 += amp1[i];
    }
    
    flatness = exp (sigma1) / sigma2;
    
    for (int i = 0; i < fftsize; i++) {
	amp1[i] /= flatness;
    }
    
    //spectral morphing
    for (int i = 0; i < fftsize; i++) {
	amp1[i] = amp1[i] + amp2[1] * a_morph;
	freq1[i] = pow ((freq1[i] - freq2[i]), freq_morph);
    }
    
    
    //pol to car coordinates  fasi per la sintesi!!!!
    unconvert (amp1, freq1, old_phi1, workspace1, fftsize, hop, sr);
    */
    //inverse transform
    fft (sum_workspace, fftsize, 1); // inverse fft
}


int main (int argc, char* argv[]) {
    cout << "[nanoCoder, v. 0.1]" << endl;
    cout << "spectral morphing by phase vocoder analysis" << endl;
    
    try {
	if (argc != 6) {
		cout << "error: syntax is 'nanoCoder in1.wav in2.wav out.wav a_morph freq_morph'" << endl;
		return 0;
	}

	// argv[1] == nome del file in input
	WavInFile input1 (argv[1]);
	int sr = input1.getSampleRate ();
	int nchan = input1.getNumChannels ();
	int samples1 = input1.getNumSamples ();
	int bits = input1.getNumBits ();

	if (nchan != 1 || bits != 16) {
		cout << "error: 16 bit mono files supported only" << endl;
		return 0;
	}
	
	WavInFile input2 (argv[1]);
	int samples2 = input2.getNumSamples ();
	
	if (nchan != 1 || bits != 16) {
	    cout << "error: 16 bit mono files supported only" << endl;
	    return 0;
	}

	// argv[3] == nome del file in output
	WavOutFile output (argv[3], 44100, 16, 1);
	
	int samples = 0;
	if (samples1 < samples2){
	    samples = samples2;
	}
	else samples = samples1;
	cout << "sample max: " << samples << endl;
	
	//argv[4] == morphing delle ampiezze
	float a_morph = atof (argv[4]);
	
	//argv[5] == morphing delle frequenze
	float freq_morph = atof (argv[5]);
	
	//morphing range control
	if (a_morph < 0 || freq_morph < 0) {
	    cout << "error: range 0 - 1" << endl;
	    return 0;
	}
	
	if (a_morph > 1 || freq_morph > 1) {
	    cout << "error: range 0 - 1" << endl;
	    return 0;
	}
	
	// memory allocation	
	float* window = new float[FFTSIZE];
	makeWindow (window, FFTSIZE, .5, .5, 0);	//hanning function

	float* sum_workspace = new float[FFTSIZE * 2];
	float* workspace1 = new float[FFTSIZE * 2];
	float* workspace2 = new float[FFTSIZE * 2];
	float* amp1 = new float[FFTSIZE];
	float* freq1 = new float[FFTSIZE];
	float* old_phi1 = new float[FFTSIZE];
	float* amp2 = new float[FFTSIZE];
	float* sum_amp = new float[FFTSIZE];
	float* freq2 = new float[FFTSIZE];
	float* old_phi2 = new float[FFTSIZE];
	float* sum_phi = new float[FFTSIZE];
	memset (sum_amp, 0, sizeof (float) * FFTSIZE);
	memset (sum_workspace, 0, sizeof (float) * FFTSIZE * 2);
	memset (sum_phi, 0, sizeof (float) * FFTSIZE);
	
	float* input_data1 = new float[samples];
	float* input_data2 = new float[samples];
	int outsamples = samples;
	float* output_data = new float[outsamples];
	memset (output_data, 0, sizeof (float) * outsamples);

	// reading
	input1.read (input_data1, samples1);
	input2.read (input_data2, samples2);
	cout << "inputs read" << endl;

	float norm = 1. / (FFTSIZE * OLAP);
	
	cout << "processing..." << endl;
	int pointer = 0;
	while (pointer < samples) {
	    for (int i = pointer; i < int (pointer + FFTSIZE); i++) {
		workspace1[2 * i - pointer] = input_data1[i] * window[i - pointer];
		workspace1[2 * (i - pointer) + 1] = 0;
		
		workspace2[2 * i - pointer] = input_data2[i] * window[i - pointer];
		workspace2[2 * (i - pointer) + 1] = 0;
	    }
		
	    process (window, sum_workspace, workspace1, workspace2,sum_amp, amp1, freq1, amp2, freq2,
		     sum_phi, FFTSIZE, HOPSIZE, sr, a_morph, freq_morph);
	    
		
	    //overlap add
	    for (int i = pointer; i < int (pointer + FFTSIZE); i++) {
		output_data[i] += (sum_workspace[2 * i - pointer] * window[i - pointer] * norm);
	    }

	pointer += HOPSIZE;
	}
	
	cout << "completed" << endl;
	cout << "writing..." << endl;

	output.write (output_data, outsamples);
	cout << "done" << endl;

	// memory deallocation
	delete [] sum_workspace;
	delete [] workspace1;
	delete [] workspace2;
	delete [] amp1;
	delete [] freq1;
	delete [] old_phi1;
	delete [] amp2;
	delete [] freq2;
	delete [] old_phi2;
	delete [] sum_phi;
	delete [] sum_amp;
	delete [] input_data1;
	delete [] input_data2;
	delete [] output_data;
	delete [] window;
    
    } catch (exception& e) {
	    cout << e.what () << endl;
    }
    
    return 0;
}

// EOF


