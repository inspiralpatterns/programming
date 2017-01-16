#include <stdio.h>
#include <string.h>

int main ( ) {
    int note, i;
    //create string for storing the user input
    char key[3];
    //create an array to match the string with
    char* scale[12] = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"};
    
    //prompt the user for key
    printf("Enter the key (in Capital): ");
    scanf("%s", &key[0]);       //oppure: scaf("%s", key). In questo caso, key[0]
                                            //serve per indicare l'inizio della stringa al puntatore
    
    //match the pitch and translate note name
    for (i = 0; i <12; i++) {
        if (strcmp(scale[i], key) == 0){
        note = i;
        printf("It's a %s major scale\n", key);
        break;
        }
        else note = -1;         //note not found 
    }
    
    if (note >= 0){
        for (i = 0; i < 7; i++) {
            printf("%s", scale[note%12]);
            if (i != 2) note += 2;
            else note += 1;
        }
        printf("\n");
        return 0;
        }
        else{
            printf("%s is an invalid key\n", key);
            return 1;
        }   
    }