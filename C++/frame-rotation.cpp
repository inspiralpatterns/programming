#include <iostream>

using namespace std;

int main (int argc, char **argv){
    cout << "Define samples index based on input index, hopsize and fft size" << endl;
    int posin, new_index;
    int fft, hopsize;
    
    if  (argc != 4) cout << "Syntax: posin fft hopsize" << endl;
    
    posin = atoi(argv[1]);
    fft = atoi(argv[2]);
    hopsize = atoi(argv[3]);
    
    int mod = hopsize % fft;
    
    new_index = posin + hopsize;
    if (new_index >= fft) new_index -= fft;
    
    cout << "New index: " << new_index << endl;
    
    return 0;
}