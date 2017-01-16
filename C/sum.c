#include <stdio.h>

int sum(int a, int b) {
    int result;
    result = a + b;
    
    return result;
}

int main( ){
    int x,y,z,w;
    printf("Enter 4 values:\nx = ");
    scanf("%d", &x);
    printf("y = ");
    scanf("%d", &y);
    printf("z = ");
    scanf("%d", &z);
    printf("w = ");
    scanf("%d", &w);
    
    int a = sum(x+y, z*w);
    printf("%d\n", a);
    
    return 0;
}