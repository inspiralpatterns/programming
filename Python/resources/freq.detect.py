#fundamental frequency detection over an entire signal
#(the candidate frequencies are estimated over specific peaks on each
#frequency spectrum of the STFT).
#the function f0.Detection uses the two-way mismatch algorithm to
#perform fundamental estimation in the frequency domain.

import numpy as np
from scipy.signal import get_window
import sys, os, time
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../software/models/'))
import dftModel as DFT
import utilFunctions as UF
import stft as STFT
import harmonicModel as HM
import sineModel as SM

(fs,x) = UF.wavread('../sounds/sawtooth-440.wav')
w = get_window('blackman',1001)
N = 2048
t = -50
minf0 = 300
maxf0 = 500
f0et = 1
H = 1000

f0 = HM.f0Detection(x,fs,w,N,H,t,minf0,maxf0,f0et) #based on TWM algorithm




