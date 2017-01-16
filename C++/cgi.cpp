#include <iostream>

using namespace std;


int main () {
    int counter = 0;
    int i;
    counter += 1;       //it counts the web page contact number
    i += counter;        //refresh count variable every connection
    
    cout <<"Content-type: text/html" << endl << endl;   //HTTP header
    cout <<"<html><title>Welcome</title><body>" << endl;
    cout <<"Welcome, you are visitor no. " << counter << endl;
    cout <<"</body></html>";

    return i;
}