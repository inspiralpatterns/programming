#include <iostream>

using namespace std;

struct Osc {
    //dataspace: dati della struttura (le variabili di ogni oggetto)
    float* table;
    float phase;
    float index;
    int length;
    int vecsize;
    float rate;
    float* output;
    
    //methodspace: cosa è possibile fare all'interno della struttura
    
    //initializing function - the 'constructor'
    Osc (float* tab, float phi = 0.f, int len = 1, int vsize = 512, int sr = 44100) {
        table = tab;
        phase = phi;
        length = len;
        vecsize = vsize;
        index = 0.f;
        rate = sr;
        output = new float[vecsize];
    }
    
    //deallocating function: the 'destructor'
    ~Osc ( ) {
        delete [ ] output;
    }
    
    //process function: it generates the audio signal
    float *Proc(float amp, float freq) {
        float incr = freq * length / rate;
        for (int i = 0; i < vecsize; i++) {
            output[i] = amp * table[(int)index];
            index += incr;
            while (index >= length) index -= length;        //guard-point
            while (index < 0) index += length;
        }
        return output;
    }
    
};


int main ( ){
    Osc bing(new float [256]);
    
    float* fp_out;
    float* output(bing.Proc(0.5f, 440.f));
    cout << output << endl;
    
    return 0;
}










