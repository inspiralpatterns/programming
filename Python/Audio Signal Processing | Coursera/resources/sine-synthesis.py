#sinusoidal model applied to synthesis

import os
import sys
import numpy as np
import math
from scipy.signal import get_window
from scipy.signal import blackmanharris, triang
from scipy.fftpack import ifft
import matplotlib.pyplot as plt
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../software/models/'))
import dftModel as DFT
import utilFunctions as UF

(fs,x) = UF.wavread('../sounds/oboe-A4.wav')
Ns = 512 #Ns = FFT synthesis size (samples)
hNs = Ns/2
H = Ns/4 #hopsize (samples)
M = 511 #window size (samples)
t = -70 #threshold
w = get_window('hamming',M)
x1 = x[.8*fs:.8*fs+M]
mX,pX = DFT.dftAnal(x1,w,Ns) #DFT over the signal
ploc = UF.peakDetection(mX,t) #peak detection over the frequency spectrum
iploc,ipmag,ipphase = UF.peakInterp(mX,pX,ploc) #parabolic interpolation
ipfreq = fs*iploc/float(Ns) #frequency in Hz for the peak locations

Y = UF.genSpecSines_p(ipfreq,ipmag,ipphase,Ns,fs)
#in this case, the frequency spectrum generated is based on the frequency
#for the peak locations of the audio input signal
#(directly in the freq-domain)
y = np.real(ifft(Y))

#undo the Blackman-Harris windowing and application of a triangular function
sw = np.zeros(Ns)
ow = triang(Ns/2)
sw[hNs-H:hNs+H] = ow
bh = blackmanharris(Ns)
bh = bh / sum(bh)
sw[hNs-H:hNs+H] = sw[hNs-H:hNs+H] / bh[hNs-H:hNs+H] #synthesis window

yw = np.zeros(Ns)
yw[:hNs-1] = y[hNs+1:]
yw[hNs-1:] = y[:hNs+1]
yw *= sw

freqaxis = fs*np.arange(Ns/2+1)/float(Ns) #plot the x-axis in Hz
plt.plot(freqaxis,mX)
plt.plot(fs*iploc/float(Ns),ipmag,marker='x',linestyle='' )
plt.show()

plt.plot(y) #Blackman-Harris windowed signal
plt.show()

plt.plot(yw) #output signal
plt.show()



