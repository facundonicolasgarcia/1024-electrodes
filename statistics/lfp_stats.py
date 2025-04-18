import h5py
import numpy as np
import stats


h5_path = r'..\hdf5\A_RS_140819\LFP.h5'

with h5py.File(h5_path, 'r') as f:
    dset = f['LFP']

    for i in range(dset.shape[0]):
        # Get the current row
        row = dset[i, :]

        # Check if the row is empty (all NaN values)
        if np.all(np.isnan(row)):
            print(f"Row {i} is empty.")
        else:
            print(f"Row {i} is not empty.")