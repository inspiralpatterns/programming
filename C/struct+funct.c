#include <stdio.h>

struct complex {
    float real;
    float imag;
    
    //define a function pointer that accepts a structure pointer as argument
    void (*incr) (struct complex *p);
};

//la funzione si aspetta un puntatore a stuttura come parametro in entrata
//il puntatore a struttura si rivolge poi a ognuna delle sue variabili interne incrementandole
void incr (struct complex *p) {
    (*p).real++;
    (*p).imag++;
}

int main ( ) {
    //initialize the structure with the function whose it points at
    struct complex a = {0, 0, incr};
    
    //overwrite the incremented value for the structure into the structure itself
    a.incr(&a);
    
    return 0;
}

