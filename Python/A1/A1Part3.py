"""
A1-Part-3: Python array indexing

Write a function that given a numpy array x, returns every Nth element in x, starting from the 
first element.  

The input arguments to this function are a numpy array x and a positive integer N such that N < number of 
elements in x. The output of this function should be a numpy array.

If you run your code with x = np.arange(10) and N = 2, the function should return the following output: 
array([0, 2, 4, 6, 8]).
"""
def hopSamples(x,N):
    """
    Inputs:
        x: input numpy array
        N: a positive integer, (indicating hop size)
    Output:
        A numpy array containing every Nth element in x, starting from the first element in x.
    """
    ## Your code here
    import numpy as np
    y = np.array([])
    
    for i in range (0, np.size(x)):
        if x[i] % N == 0:
            y = np.append(y, x[i])   
        
    return y
    