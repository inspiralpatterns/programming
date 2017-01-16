#include <stdio.h>
#include <stdlib.h>

//atoi converte una constant string in intero e restituisce un dato di tipo 'int'

int main ( ) {
    int i;
    int size = 256;
    char* buffer = new char[size];
    
    printf("Insert a number: ");
    fgets(buffer, 256, stdin);
    
    i = atoi (buffer);
    printf("%d", i);
    
    printf("\n");
    return 0;
}