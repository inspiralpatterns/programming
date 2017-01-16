#include <stdio.h>
#include <stdlib.h>

//mod12 controlla che il valore rientri nel range delle classi di altezze 0-11
int mod12 (int note) {
    while (note >= 12) note -= 12;
    while (note < 0) note += 12;
    return note;
}

int main (int argc, char** argv) {
    int series [12] [12];
    int n, m, i;
    
    //create pitch-to-note translation table
    char* table [12] = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"};
    
    //check the correct input and prompt the user to enter input syntax
    if (argc != 13) {
        printf("syntax: note1 note2...noteN");
        return 1;
    }
    
    
    for (n = 0; n < 12; n++) {
        series [0] [n] = mod12(atoi(argv[n+1]));
    }
    
    for (m = 1; m < 12; m++) {
        series [m][0] = mod12(series[m-1][0] + series[0][m-1] - series[0][m]);
    }
    
    for (m = 1; m < 12; m++) {
        for (n = 1; n < 12; n++) {
            series [m][n] = mod12(series[0][n] + series[m][0] - series[0][0]);
        }
    }
    
    for (m = 0; m < 12; m++) {
        for (n = 0; n < 12; n++) printf("%s", table[series[m][n]]);
    }
    
    return 0;
}