'''
Creates array with 1024*2023/2 rows (one per pair of electrodes) and 3 columns:
electrode1, electrode2: electrodes' global ID's.
distance: distance between electrodes in the schematic representation.
'''

import numpy as np

monkey = 'A'
positions_path = rf".\{monkey}_electrode_positions.npy"
output_path = rf".\{monkey}_electrode_distances.npy"
positions = np.load(positions_path)

n_rows = 1024*1023//2
row_type = np.dtype([('electrode1', np.uint16), ('electrode2', np.uint16), ('distance', np.float64)])
distances = np.empty(n_rows, row_type)

index = 0
for i in range(1023):
    for j in range(i+1, 1024):
        
        v_1 = positions[i]
        v_2 = positions[j]
        d = np.linalg.norm(v_1-v_2)

        distances[index] = np.array((i, j, d), dtype=row_type)
        index+=1

np.save(output_path, distances)
