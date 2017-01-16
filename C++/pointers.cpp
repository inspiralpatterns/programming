/***pointers.cpp
 *study on control pointers to array by pointers to pointers
 ***/

#include <iostream>

using namespace std;


int main (){
    int* array1 = new int[10];
    int* array2 = new int[10];
    
    int** ptr1;
    int** ptr2;

    ptr1 = &array1;
    ptr2 = &array2;
    
    
    cout << array1 << endl;     /* = 0x7f846bc049c0*/
    cout << array1[1] << endl;  /* = 1879048192*/
    cout << *ptr1 << endl;      /* = 0x7f846bc049c0*/
    
    for (int i = 0; i < 10; i++){
        **ptr1 = i +1;
        **ptr2 = (i + 1) * (i + 1);
        cout << *array1 << "   ";
        cout << *array2 << endl;
        *ptr1 = &array1[i + 1];
        *ptr2 = &array2[i + 1];
    }

    return 0;
}