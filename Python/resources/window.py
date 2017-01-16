#create a window function for STFT
#and get the frequency spectrum

#1.package declaration
import numpy as np
from scipy.signal import get_window
from scipy.fftpack import fft
import math
import matplotlib.pyplot as plt

#2.make window function 
M = 63 #window size in samples
window = get_window('hanning', M) #compute the window function
#calculation for zero-phase windowing
#it means half (h) of the buffer dimension
hM1 = int(math.floor((M+1)/2))
hM2 = int(math.floor(M/2))

#3.instance variables for the FFT
N = 512 #FFT size
hN = N/2
fftbuffer=np.zeros(N)
#zero-phase windowing section
fftbuffer[:hM1] = window[hM2:]
fftbuffer[N-hM2] = window[:hM2] #NB:python buffer index starts from 0 so: [:hM2]
                                #means that he refers to all the values except the last one

#calculate frequency and phase spectrum
X = fft(fftbuffer)
absX = abs(X)
absX[absX<np.finfo(float.eps)]= np.finfo(float).eps #check if all values are not zeros
                                                    #(eps is the minimum value in python)
mX = 20*np.log10(absX)
pX = np.angle(X)


#place back the data for an asier visualization
mX1 = np.zeros(N)
pX1 = np.zeros(N)
mX1[:hN] = mX[hN:]
mX1[N - hN:] = mX[:hN]
pX1[:hN] = pX[hN:]
pX1[N - hN:] = pX[:hN]

