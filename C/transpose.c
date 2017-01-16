#include <stdio.h>
#include <string.h>

// creo una funzione che limiti il range dell'intervallo trasposto ai valori di un ottava
int octave (int interval ) {
    while (interval < 0) interval += 12;
    while (interval >= 12) interval -= 12;
    
    return interval;
}

int main ( ) {
    char note[3];
    char **p1, **p2;        //** perchŽ occorre creare dei puntatori di puntatori
                                     //mentre un solo * indica un array

    char *table[12] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    // in questo caso, si crea un array di string constant
    
    int interval;
    
    printf("Enter base note (in Capital, # for sharp): ");
    scanf("%s", &note[0]);
    printf("Enter the interval in semitones number: ");
    scanf("%d", &interval);
    
    //point p1 to the beginning of the array and p2 to its end
    p1 = table;
    p2 = (table +11);
    
    while (strcmp(*p1, note)) {
        p1++;
        if (p1 > p2) {
            printf("Note not found.\n");
            return 1;
        }
    }
    
    //add interval to the address of base note
    p1 += octave(interval);
    if (p1 > p2) p1 -= 12;
    
    printf("%s transpose by %d semitone(s) is %s.\n", note, interval, *p1);
    
    return 0;
}