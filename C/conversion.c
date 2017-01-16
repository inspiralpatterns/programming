//tabella di conversione da Fahreneit a Celsius

#include <stdio.h>

int main ( ) {
    for (int fahr = 0; fahr < 300; fahr += 10) {
        printf("%4d %6.lf\n", fahr, (5.0/9.0)*(fahr - 32));
    }
    return 0;
}