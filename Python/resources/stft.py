#example of STFT over an audio signal
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import get_window
import os,sys
sys.path.append(os.path.join(os.paht.dirname(os.path.realpath(__file__)), '../software/models'))
import utilFunctions as UF
import stft as STFT

inputFile = '../sounds/flute-A4.wav'
window = 'hamming'
M = 801
N = 1024
H = 400

(fs,x) = UF.wavread(inputFile)
w = get_window(window, M)
mX, pX = STFT.stftAnal(x, fs, w, N, H)

#look at stft_function.py in /models