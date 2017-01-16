
#include <stdio.h>              //include header

int main ( ) {
    printf("\"Hello world\"\n");  //print message

    float total = 5.341;
    printf("Total = %10.4f\n", total); //%d is a ANSI C format specifier, it means: print a value as a signed decimal integers
    
    int i, j;
    scanf("%d %d", &i, &j);  //store strings of character into variables specifying their addresses
    printf("I = %d\n", i);
    printf("J = %d\n", j);
    return 0;                         //return statement
}
