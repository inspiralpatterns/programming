#include <stdio.h>

int main ( ) {
    int *a, i;       //creo un array e di conseguenza il puntatore al suo primo elemento
    int n = 10;
    
    for (i = 0; i < n; i++) {
        *(a + i) = i;               //utilizzando l'aritmetica dei puntatori, prendo il puntatore al primo elemento e
                                        //ne incremento il passo, andando a scrivere nelle caselle successive dell'array.
        printf("%d ", *(a + i));
    }
    printf("\n");
    return 0;
}