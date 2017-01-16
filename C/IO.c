#include <stdio.h>

int main ( ) {
    int a, b, c;
    printf("\n please type a number: ");
    scanf("%d", &a);        //scanf waits for an integer and puts it at the address of variable 'a'
    
    printf("\n please type a second number: ");
    scanf("%d", &b);
    
    c = a + b;
    printf("%d = %d + %d\n", c, a, b);
    return 0;
}