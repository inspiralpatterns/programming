#include <stdio.h>


void culo (int times, void (*call) ( ), void (*back) ( ), char *mess1, char *mess2){
    int i;
    for (i = 0; i < times; i++) {
        call(mess1);
        back(mess2);
    }
}

void cazzo (char *mess1) {
    printf("Che cazzo stai a di, %s! \n", mess1);
}

void tette (char *mess2) {
    printf("Sei veramente un %s. \n", mess2);
}

int main ( ) {
    int times;
    printf("Quanto sei arrabbiato da 1 a 10? ");
    scanf("%d", &times);
    culo(times, cazzo, tette, "figlio di merda", "culo");
    
    return 0;
}