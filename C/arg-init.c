#include <stdio.h>


//questa funzione accetta parametri dalla linea di comando
//e stampa ognuno di essi su di una nuova linea

int main (int argc, char **argv) {
    for (int i = 0; i < argc; i++){
        printf("%s\n", argv[i]);
    }
    
    return 0;
}

