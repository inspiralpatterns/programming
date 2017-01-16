#include<stdio.h>

//definizione della funzione principale che conterrˆ i puntatori alle altre funzioni
//I puntatori a funzione vengono dichiarati con la forma:

//return-type (*pointer-name) (arguments in)

void message_printer (int times, void (*callback) (char *msg), char* user_mess) {
    int i;
    for (i = 0; i < times; i++) {
        callback(user_mess);
    }
}

//definizione delle due funzioni di callback richiamate all'interno della funzione principale
//callbacks: funzioni che verranno richiamate dal codice e non dall'utente

void my_important_message (char *mess) {
    printf("VERY important: %s \n", mess);
}

void my_warning_message (char* mess) {
    printf("VERY important: %s \n", mess);
}


//la funzione principale viene implementata richiamando le funzioni secondarie

int main ( ) {
    message_printer(10, my_important_message, "functions can be pointers");
    message_printer(1, my_warning_message, "but be careful with them");
    
    return 0;
}

