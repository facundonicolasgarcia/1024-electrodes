'''
Script for combining the .mat files into a single .h5 file

Usage:
    python mat_to_h5.py <source_dir> <h5_path> [--dataset_name <dataset_name>]
'''

import os
import argparse
import scipy.io
import numpy as np
import h5py

def get_max_ncols(mat_files):
    max_cols = 0
    for mat_file in mat_files:
        data = scipy.io.loadmat(mat_file)['lfp'].T
        cols = data.shape[1]
        max_cols = max(max_cols, cols)
    return max_cols

def init_h5_array(h5_path, dtype=np.float32, dataset_name='data', shape=(1024, None)):
    print(f"Initializing HDF5 file at {h5_path} with shape {shape} and dtype {dtype}")
    with h5py.File(h5_path, 'w') as f:
        f.create_dataset(
            dataset_name,
            shape=shape,
            chunks=(1, shape[1]),
            dtype=dtype,
            compression='gzip'
        )

def insert_array(h5_path, mat_file, dataset_name='data', shape=(1024, None)):
    # Load the .mat file and extract the data
    print(f"Loading .mat file: {mat_file}")
    mat_data = scipy.io.loadmat(mat_file)
    array = mat_data['lfp'].T
    electrode_id = mat_data['Electrode_ID'][0].astype(int).T
    array_id = mat_data['Array_ID'][0, 0].astype(int).T

    print(f"Adding data from Array {array_id} to HDF5 file...")
    with h5py.File(h5_path, 'a') as f:
        dset = f[dataset_name]
        num_cols = shape[1]

        # Insert the data into the HDF5 file row by row. Uses Electrode_ID-1 (id_ - 1) as index.
        for i, id_ in enumerate(electrode_id):
            new_row = array[i, :]
            new_row_padded = np.full((1, num_cols), np.nan, dtype=dset.dtype)
            new_row_padded[0, :len(new_row)] = new_row
            print(f"\tInserting row {i} at index {id_-1}.")
            dset[id_-1,:] = new_row_padded

def manage_files(source_dir, h5_path, dataset_name='data'):
    # Get all .mat files in the source directory
    mat_files = [f for f in os.listdir(source_dir) if f.endswith('.mat')]
    mat_file_paths = [os.path.join(source_dir, f) for f in mat_files]

    # Get the maximum number of columns from all .mat files
    max_cols = get_max_ncols(mat_file_paths)

    # Initialize the HDF5 file
    init_h5_array(h5_path, dtype=np.float32, dataset_name=dataset_name, shape=(1024, max_cols))

    # Process each .mat file and insert data into the HDF5 file
    for mat_path in mat_file_paths:
        insert_array(h5_path, mat_path, dataset_name=dataset_name, shape=(1024, max_cols))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Convert multiple .mat files to one .h5 file.")
    parser.add_argument('source_dir', help='Path to the folder containing .mat files')
    parser.add_argument('h5_path', help='Path to the output .h5 file')
    parser.add_argument('--dataset_name', help='Optional name of the dataset in the .h5 file. Default is "lfp"', default='lfp')

    args = parser.parse_args()
    manage_files(args.source_dir, args.h5_path, args.dataset_name)
