import numpy as np

class Meanvar:
    '''
    Class to compute the mean and variance of a dataset using West's method.
    This class allows for recursive updates to the mean and variance for each index.
    For example, if each input is a time series at a position x, the object contains a spatial mean and variance for each time.
    The data points can be weighted, and the class can handle NaN values in the data.
    '''
    def __init__(self, mean=None, wsum=None, t=None, n=0):
        '''
        mean: mean of the data
        wsum:sum of the weights
        t: mean of the squared deviations from the mean
        n: number of samples
        '''
        self.mean = mean
        self.wsum = wsum
        self.t = t
        self.n = n
    
    def recursive_update(self, x:np.ndarray, w:np.ndarray=None) -> None:
        not_nan_mask = not np.isnan(x)
        x_filled = np.where(np.isnan(x), 0, x) # Fill NaN values with 0. Does not affect the statistics since n is not updated for these values

        new_wsum = self.wsum + w
        new_mean = self.mean + (x - self.mean) * w / new_wsum
        new_t = self.t + w * self.wsum * (x - self.mean) * (x - self.mean) / new_wsum

        self.mean = new_mean
        self.wsum = new_wsum
        self.t = new_t
        self.n[not_nan_mask] += 1
        return

    def update(self, x:np.ndarray, w:np.ndarray=None) -> None:
        if self.mean is None:
            self.mean = x
            self.wsum = w if not None else np.ones_like(x)
            self.t = np.zeros_like(x)
            n = 1
            return

        recursive_update(self, x, w)
        return

    def get_mean(self):
        return self.mean
    
    def get_var(self):
        return self.s