#include <iostream>

using namespace std;

int main (){
    float* pippo = new float[10];
    float* pp = pippo;
    
    pp += 4;
    cout << *pp << endl;
    
    delete [] pippo;
    
    return 0;
}