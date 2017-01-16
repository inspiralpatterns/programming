#compute the FFT over a real audio signal
#
#
import numpy as np
from scipy.fftpack import fft
import sys, os, math
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),'../software/models/'))
import utilFunctions as UF

M = 501
#compute the duration of the first and the second half of the signal
hM1 = int(math.floor((M+1)/2))
hM2 = int(math.floor(M/2))

(fs,x) = UF.wavread('../sounds/soprano-E4.wav') #read the input signal
x1 = x[5000:5000+M] * np.hamming(M) #fragment selection and windowing

#FFT buffer and zero-phase windowing
N = 1024 #FFT size (a power of 2) independently of M
fftbuffer = np.zeros(N)
#center the signal around zero in the FFT buffer
fftbuffer[:hM1] = x1[hM2:]
fftbuffer[N-hM2:] = x1[:hM2]

X = fft(fftbuffer)
mX = 20*np.log10(abs(X)) #show the spectrum in dB
pX = np.angle(X)
pX = np.unwrap(pX) #phase unwrapping

"""
we need only half of the magnitude spectrum values because negative frequencies
don't exist in real world but they are introduced by the FFT computation.
"""

