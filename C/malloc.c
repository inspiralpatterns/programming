#include <stdio.h>
#include <stdlib.h>


//questo codice effettua locazione dinamica di memoria
//e stampa l'elemento di ogni casella

int main ( ) {
    int *a;
    a = (int *) malloc (sizeof (int) * 10);
    //poiché malloc restituisce un void pointer, devo fare data casting a int
    
    for (int i = 0; i < 10; i++) {
        printf ("%d\n", a[i]);
    }
    
    return 0;
}