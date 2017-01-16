#include <stdio.h>

//this code get the multiplication between two complex values entered by the user

struct complex {
    float real;
    float imag;
};

struct complex mult (struct complex a, struct complex b ) {
    struct complex c;
    c.real = (a.real * b.real) - (a.imag * b.imag);
    c.imag = (a.real * b.imag) + (a.imag * b.real);
    return c;
}

int main ( ) {
    //create variables to assign complex variables with
    float real, imag;
    char dummy;
    //create objects from the complex structure
    struct complex a, b, c;
    
    //get complex numbers as inputs
    printf("Please enter the first complex number (real,imag): ");
    scanf("%f%c%f", &real, &dummy, &imag);
    
    //le variabili della struttura non possono essere utilizzate come semplici variabili
    //è possibile però assegnarle tramite placeholders.
    a.real = real;
    a.imag = imag;
    
    printf("Please enter the second complex number (real,imag): ");
    scanf("%f%c%f", &real, &dummy, &imag);
    b.real = real;
    b.imag = imag;
    
    //multiplication between complex values
    c = mult (a, b);
    printf("Their product is %6.3f + i%6.3f \n", c.real, c.imag); 

    return 0;
}