#include <stdio.h>
int main ( ) {
    int i;
    printf("enter a number: ");
    scanf("%d", &i);
    
    switch (i) {
        case 1:
            printf("one\n");
            break;
        case 2:
            printf("two\n");
            break;
        case 3:
            printf("three\n");
            break;
        default:
            printf("no matches found\n");
            break;
    }
    
    return 0;
}