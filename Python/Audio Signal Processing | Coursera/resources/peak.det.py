#peak detection in the frequency spectrum

import os
import sys
import numpy as np
import math
from scipy.signal import get_window
import matplotlib.pyplot as plt

sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../software/models/'))
import dftModel as DFT
import utilFunctions as UF

###TEST ONE: using a small DFT size###
(fs,x) = UF.wavread('../sounds/sine-440.wav')
M = 501 #window size (samples)
N = 512 #DFT size (samples)
t = -20 #threshold to compute peak detection

w = get_window('hamming',M)
x1 = x[.8*fs:.8*fs+M]
mX, pX = DFT.dftAnal(x1,w,N)

#get peak detection
#(see utilFunctions.py for more details)
ploc = UF.peakDetection(mX,t) #returns an array of the location of the peaks
pmag = mX[ploc] #get the magnitudes for peaks location

#plotting magnitude spectrum and overimposed peak locations
#(check it out)
freqaxis = fs*np.arange(N/2+1)/float(N) #plot the x-axis in Hz
plt.plot(freqaxis,mX)
plt.plot(fs*ploc/float(N),pmag,marker='x',linestyle='' )
#from the graph we can see the measure is not so accurate using N = 512
#because fs/N = 86, i.e. each bin is located at a distance of 86 Hz.

plt.show()


###TEST TWO: using a fourfold DFT size###
N = 2048
w = get_window('hamming',M)
x1 = x[.8*fs:.8*fs+M]
mX, pX = DFT.dftAnal(x1,w,N)
ploc = UF.peakDetection(mX,t) 
pmag = mX[ploc] 
freqaxis = fs*np.arange(N/2+1)/float(N)
plt.plot(freqaxis,mX)
plt.plot(fs*ploc/float(N),pmag,marker='x',linestyle='' )
plt.show()
#from the graph we can see the distance in Hz is reduced but the peak is not
#the peak we were expecting for.


###TEST THREE: using parabolic interpolation###
N = 2048
w = get_window('hamming',M)
x1 = x[.8*fs:.8*fs+M]
mX, pX = DFT.dftAnal(x1,w,N)
ploc = UF.peakDetection(mX,t) 
iploc,ipmag,ipphase = UF.peakInterp(mX,pX,ploc)
plt.plot(freqaxis,mX)
plt.plot(fs*iploc/float(N),ipmag,marker='x',linestyle='' )
plt.show()






