#include <stdio.h>
#include <string.h>

//due modi per definire le strutture:

//modalitˆ 1
struct note1 {
    char *name1;
    char *duration1;
    char *intensity1;
};

//modalitˆ 2
typedef struct note2 {
    char name2[3];
    char duration2[3];
    char intensity2[3];
} note2;


int main ( ) {
    struct note1 first = {"Db", "5/4", "mp"};
    
    printf("\n");
    printf("First note has these characteristics:\n");
    printf("name: %s\n", first.name1);
    printf("duration: %s\n", first.duration1);
    printf("intensity: %s\n", first.intensity1);

    
    note2 second;
    strcpy (second.name2, "Ab");
    strcpy (second.duration2, "3/8");
    strcpy (second.intensity2, "ff");
    
    printf("\n");
    printf("Second note has these characteristics:\n");
    printf("name: %s\n", second.name2);
    printf("duration: %s\n", second.duration2);
    printf("intensity: %s\n", second.intensity2);
    
    return 0;
}
