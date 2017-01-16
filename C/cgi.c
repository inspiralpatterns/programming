#include <stdio.h>

void counter () {
    int i = 0;
    for (i >= 0;) {
        int counter = i;
        i += 1;
    }
}
int main () {
    printf("Content-type: text/html\n\n");
    printf("<html><title>Welcome</title><body>\n");
    printf("Welcome, you are visitor no. %d\n", counter);
    printf(</body></html>);

    return 1;
}