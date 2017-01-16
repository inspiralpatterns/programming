#include <stdio.h>

int main ( ) {
    //prompt for input and gets the key from the terminal
    int note;
    int i;
    printf("Enter a note (in pitch-class number,: 0 - 11): ");
    scanf("%d", &note);
    if (note < 0) {
        printf("Only positive number.\nEnter a note again (0 - 11): ");
        scanf("%d", &note);
    }
    if (note > 11) note = note - 12;
    
    //match the root and name it
    for (int i = 0; i < 7; i++) {
        if (note%12 == 0) printf("C");
        else if (note%12 == 1) printf("Db");
        else if (note%12 == 2) printf("D");
        else if (note%12 == 3) printf("Eb");
        else if (note%12 == 4) printf("E");
        else if (note%12 == 5) printf("F");
        else if (note%12 == 6) printf("Gb");
        else if (note%12 == 7) printf("G");
        else if (note%12 == 8) printf("Ab");
        else if (note%12 == 9) printf("A");
        else if (note%12 == 10) printf("Bb");
        else if (note%12 == 11) printf("B");
    
        if (i != 2) note += 2;          //build the scale
        else note = note + 1;       //catch the semitone in major scale
    }
    
    printf("\n");
    
    return 0;
}