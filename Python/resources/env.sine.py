#compute the FFT over an enveloped sinusoid
#of fixed frequency f and plot the frequency spectrum

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import get_window
import sys
sys.path.append('../software/models')
import dftModel as DFT


fs = 44100
f = 5000.0
M = 101
x = np.cos(2*np.pi*f*np.arange(M)/float(fs))
N = 512
w = get_window('hamming', M)
mX, pX = DFT.dftAnal(x, w, N)

plt.plot(np.arange0, fs/2, fs/float(N), mX - max(mX))
plt.show()


