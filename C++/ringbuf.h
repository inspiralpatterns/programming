/*circular buffer definition
 */

using namespace std;

class RingBuffer {
    public:
        /*constructor*/
        RingBuffer (int samples) {
        /*create array of float where audio to be stored*/
        if (samples <= 0) {
            cout << "Error! Samples value MUST BE not negative and not null" << endl;
        }
        else {
            cout << "Constructing buffer" << endl;
            float* buffer = new float[samples];
            memset (buffer, 0, sizeof (int)*samples);
            size = samples;
            rp = 0;
            wp = 0;
            }
        }
        
        /*destructor*/
        ~RingBuffer () {
            /*de-allocate memory*/
            cout << "Destructing buffer" << endl;
        }
        
        int Read (float* ptr, int samples);    /*reading function*/
        int Write (float* ptr, int samples);   /*writing function*/
        
    private:
       float buffer;
       int size;
       int *rp;      /*reading pointer*/
       int *wp;      /*writing pointer*/
    
};




