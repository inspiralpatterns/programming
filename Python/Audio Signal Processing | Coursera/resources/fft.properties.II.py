#compute the FFT over a triangular function
#and add the zero-phase windowing operation
#
#
import numpy as np

#import triangular function and FFT algorithm
from scipy.signal import triang
from scipy.fftpack import fft


x = triang(15)

#zero-phase windowing operation
fftbuffer = np.zeros(15)
fftbuffer[:8] = x[7:]
fftbuffer[8:] = x[:7]

X = fft(fftbuffer) #if not a power of 2, it computes the DFT without advantages
mX = abs(X) #magnitude spectrum
pX = np.angle(X) #phase spectrum


"""
zero-phase windowing allows to rearrange the input signal in order to benefit of
the fft propertiy (the magnitude spectrum doesn't change, instead the phase spectrum
is zero.
""")
