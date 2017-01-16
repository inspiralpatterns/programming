#include <iostream> // libreria Input/Output C++
#include <cmath>
#include <fstream>

using namespace std;

int main ()  {

	int n = 128;
	float s[n];
	float sr = 44100;
	float fx = 440;
	float dur = 10;

	for (int i = 0; i < n; i = i + 1) {
		s[i] = sin (2. * M_PI * ((float) i / n));
		cout << s[i] << endl;
	}

	return 0;
}
