#include <stdio.h>
#include <string.h>

int main( ) {
    char a[10] = "vivala";
    char b[10] = "merda";
    printf("%s\n", a);
    printf("%s\n", b);
    
    char c[15];
    strcpy(c, a);
    strcat(c, b);
    printf("%s\n", c);
    
    return 0;
}