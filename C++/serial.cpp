#include <iostream>
#include <cstdlib>

//create a class and define what member variables and functions are private and what are not
class Dodecaphonic {
    protected:
        int series[12];     //tone row array
        int mod12 (int note) {
            while (note >= 12) note -= 12;
            while (note < 0) note += 12;
            return note;
        }                       //modulus hidden function
        
    public:
        //default constructor
        Dodecaphonic ( ) {
            for (int i = 0; i < 12; i++) series[i] = 0;
        }                   
        
        //constructor from an array
        //(riempie l'array series con il vettore di note, riscalato opportunamente dalla funzione mod12)
        Dodecaphonic (int* notes ) {
            for (int i = 0; i < 12; i++) series[i] = mod12(notes[i]);
        }
        
        //it lets the user read the content at a specific location in the array
        int get (int index) {
            return series[mod12(index)];
        }
        
        //it allows a specific note could be written in a specific location in the array
        //driven by a specific index
        void set (int note, int index) {
            series[mod12(index)] = mod12(note);
        }
        
        //basic operations on the series
        Dodecaphonic transpose (int interval);
        Dodecaphonic invert ( );
        Dodecaphonic retrograde ( );
};


//updating the class functions
Dodecaphonic Dodecaphonic::transpose (int interval) {
    Dodecaphonic transp;
    for (int i = 0; i < 12; i++) {
        transp.set(mod12(series[i] + interval), i);
    }
    return transp;
}

Dodecaphonic Dodecaphonic::invert ( ){
    Dodecaphonic inv;
    for (int i = 0; i < 12; i++) {
        inv.set(mod12(inv.get(i-1) +  series[i-1] - series[i]), i);
    }
    return inv;
}

Dodecaphonic Dodecaphonic::retrograde ( ){
    Dodecaphonic retr;
    for (int i = 0; i < 12; i++) {
        retr.set(int (series[i]), 11 - i);
    }
    return retr;
}

int main (int argc, char** argv) {
    Dodecaphonic row, res;
    int interval, n;
    
    //prompt the user about correct syntax if there were any mistakes in the command-line arguments
    if (argc != 14 || argv[1][0] != '-') {
        printf("syntax: %s [-oN | -rN | -iN | -irN] " "note1 note2...note12 (in pitch)\n.", argv[0]);
        return 1;
    }
    
    //initialize the row object
    //(a ogni passaggio del contatore, si scrive nel vettore la stringa convertita in intero
    //che  indicata dal puntatore a stringa, ovvero argv)
    for (n = 0; n < 12; n++) {
        row.set(atoi(argv[n + 2]), n);
    }
    
    //compare for operations on the row series
    switch (argv[1][1]) {
        case 'o':           //original and/or transposed version
            interval = atoi(argv[1] + 2);
            res = row.transpose(interval);
            break;
        case 'r':           //retrograde version
            interval = atoi(argv[1] + 2);
            res = row.transpose(interval).retrograde( );
            break;
        case 'i':
        if (argv[1][3] != 'r') {            //inverted version
            interval = atoi(argv[1] + 2);
            res = row.transpose(interval).invert( );
            }
            else {
                interval = atoi(argv[1] + 2);
                res = row.transpose(interval).invert( ).retrograde( );
            }
            break;
        default:
            printf("unrecognized option.\n");
            return 1;
    }
    
    //print the resulted series
    for (n = 0; n < 12; n++){
        printf("%d  ", res.get(n));
    }
    
    printf("\n");
    return 0;
}



//proposte di miglioramento:
//1. inserire una tabella per conversione da pitch a note name e viceversa





