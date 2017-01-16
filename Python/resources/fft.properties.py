#compute the FFT over a triangular function
#
#
import numpy as np

#import triangular function and FFT algorithm
from scipy.signal import triang
from scipy.fftpack import fft


x = triang(15)
X = fft(x) #if not a power of 2, it computes the DFT without advantages
mX = abs(X) #magnitude spectrum
pX = np.angle(X) #phase spectrum

"""
over the simmetricity: the magnitude spectrum shows an implicit simmetricity
(the positive part of the signal is shifted to the origin and the negative one is added after).

over the phase: it is not zero as expected because there has been a shift operation
on the input signal of half the triangular function.
"""

