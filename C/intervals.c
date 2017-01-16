#include <stdio.h>

//permette di calcolare l'intervallo tra due note, ne esprime la grandezza in semitoni e ne indica il nome
// possible bugs:


int main( ) {
    char note1, note2, dummy;
    int pc1, pc2, interval;
    printf("Please enter two natural notes.\nFirst note: ");
    scanf("%c%c", &note1, &dummy);
    printf("Second note: ");
    scanf("%c", &note2);
    switch(note1) {
        case 'C': case 'c':
            pc1 = 0;
            break;
        case 'D': case 'd':
            pc1 = 2;
            break;
        case 'E': case 'e':
            pc1 = 4;
            break;
        case 'F': case 'f':
            pc1 = 5;
            break;
        case 'G': case 'g':
            pc1 = 7;
            break;
        case 'A': case 'a':
            pc1 = 9;
            break;
        case 'B': case 'b':
            pc1 = 11;
            break;
        default:
            printf("%c is not a natural note.\n", note1);
    }
    switch(note2) {
        case 'C': case 'c':
            pc2 = 0;
            break;
        case 'D': case 'd':
            pc2 = 2;
            break;
        case 'E': case 'e':
            pc2 = 4;
            break;
        case 'F': case 'f':
            pc2 = 5;
            break;
        case 'G': case 'g':
            pc2 = 7;
            break;
        case 'A': case 'a':
            pc2 = 9;
            break;
        case 'B': case 'b':
            pc2 = 11;
            break;
        default:
            printf("%c is not a natural note.\n", note2);
    }
    
    //calculate the interval
    interval = pc2 - pc1;
    if (interval < 0) interval += 12;           //keep the interval modulus 12
    else if (interval > 11) interval -= 12;
    printf("%d semitones up or %d down.\n", interval, interval ? 12 - interval : 0);
    switch (interval) {
        case 1:
            printf("minor 2nd, major 7th.\n");
            break;
        case 2:
            printf("major 2nd, minor 7th.\n");
            break;
        case 3:
            printf("minor 3rd, major 6th.\n");
            break;
        case 4:
            printf("major 3rd, minor 6th.\n");
            break;
        case 5:
            printf("perfect 4th or 5th.\n");
            break;
        case 6:
            printf("tritone (augmented 4th).\n");
            break;
        case 7:
            printf("perfect 5th or 4th.\n");
            break;
        case 8:
            printf("minor 6th, major 3rd.\n");
            break;
        case 9:
            printf("major 6th, minor 3rd.\n");
            break;
        case 10:
            printf("minor 7th, major 2nd.\n");
            break;
        case 11:
            printf("major 7th, minor 2nd.\n");
            break;
        default:
            printf("this is a unison.\n");
            break;
        
        return 0;
    }
    
    
}