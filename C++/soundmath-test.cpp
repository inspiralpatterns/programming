#include "soundmath.h"      //tradizione nella differenza tra librerie di sistema e personali
#include <iostream>
#include <ctime>            //per funzione rand (funzione randomica)

using namespace std;

const int SIZE = 16;

void print (float* vector, int len) {
    for (int i = 0; i < len; ++i) {
        cout << vector[i] << " ";
    }
    cout << endl;           //stampa un invio a capo nel terminale
}

int main () {
    srand (time (NULL));
    // seme randomico che viene dato dall'orario.
    // NULL indica un puntatore nullo.
    float* input1 = new float [SIZE];
    float* input2 = new float [SIZE];
    float* output = new float [SIZE];
    
    for (int i = 0; i < SIZE; ++i) {
        input1[i] = (((float) rand () / RAND_MAX) * 2) - 1;
        // casting: si passa da un tipo all'altro per facilitare la scrittura.
        // In questo caso, si passa il rand da un INT a un FLOAT.
        // La prima cosa da capire in C++  la tipizzazione.
        
        input2[i] = (((float) rand () / RAND_MAX) * 2) - 1;
        // rand  una funzione che non ha valori in uscita
        //  una tradizione che le costanti definite vengono scritte in maiuscolo.
    }
    
    print (input1, SIZE);
    print (input2, SIZE);
    
    cout << "sum" << endl;
    sumF_v (input1, input2, output, SIZE);
    print (output, SIZE);
    
    cout << "sub" << endl;
    subF_v (input1, input2, output, SIZE);
    print (output, SIZE);
    
    cout << "mul" << endl;
    mulF_v (input1, input2, output, SIZE);
    print (output, SIZE);
    
    cout << "div" << endl;
    divF_v (input1, input2, output, SIZE);
    print (output, SIZE);
    
    cout << "mean = " << meanF_v (input1, SIZE) << endl;
    cout << "min = " << minF_v (input1, SIZE) << endl;
    cout << "max = " << maxF_v (input1, SIZE) << endl;
    // il codice viene eseguito da dentro a fuori, e da destra a sinista
    
    energyF_v (input1, output, SIZE);
    print (output, SIZE);
    
    cout << "RMS = " << meanF_v (output, SIZE) << endl;
    // utilizziamo il vettore output giˆ scritto con i valori di energy.
    
    cout << "Interp" << endl;
    interpF_v (output, 0, 1, SIZE);
    print (output, SIZE);
    
    interpF_v (output, 1, 0, SIZE);
    print (output, SIZE);
    
    cout << "bartlett" << endl;
    bartlettF_v (output, 0, 1, SIZE);
    print (output, SIZE);
    
    
    
    return 0;
}
