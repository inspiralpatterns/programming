#DFT analysis and function test code
#
#
import numpy as np
from scipy.signal import get_window
import os,sys
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),'../software/models/'))
import utilFunctions as UF
import dftModel as DFT

(fs,x) = UF.wavread('../sounds/piano.wav')

M = 511 #envelope size in samples
w = get_window('hamming', M) #envelope function(windowing)

time = 0.2 #fragment to analyze
x1 = x[int(time*fs):int(time*fs)+M] #conversion from second to samples

N = 1024
mX, pX = DFT.dftAnal(x1,w,N) #analyis

y = DFT.dftSynth(mX,pX,w.size)*sum(w) #synthesis (with normalization factor)




