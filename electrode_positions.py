'''
Creates positions array and ID array. Index is the electrode ID - 1.
positions_arr: array with 1024 rows and 2 columns: x, y.
ID_array: array with 1024 rows and 4 columns: electrode_ID, NSP_ID, array_ID, within_array_ID.
'''

import odml
import numpy as np

monkey = 'A'

# Import metadata
if monkey=='L':
    file_path = r"C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\L_RS_090817\metadata_L_RS_090817.odml"
elif monkey=='A':
    file_path = r"C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\metadata_A_RS_140819.odml"
file_content = odml.load(file_path)

# Initialize arrays
positions_arr = np.empty((1024, 2), np.float32)

ID_type = np.dtype([('electrode_ID', np.uint16), ('NSP_ID', np.uint16), ('array_ID', np.uint16), ('within_array_ID', np.uint16)])
ID_array = np.empty(1024, ID_type)

for array in file_content['Arrays'].sections:

    array_id = array.properties['Array_ID'].values[0]
    for electrode in array.sections:
        
        electrode_ID = electrode.properties['Electrode_ID'].values[0]
        NSP_ID = electrode.properties['NSP_ID'].values[0]
        within_array_id = electrode.properties['within_array_electrode_ID'].values[0]
        x = electrode.properties['schematic_X_position'].values[0]
        y = electrode.properties['schematic_Y_position'].values[0]

        row = electrode_ID-1
        positions_arr[row] = np.array((x, y), dtype=np.float32)
        ID_array[row] = np.array((electrode_ID, NSP_ID, array_id, within_array_id), dtype=ID_type)

# Save arrays
np.save(rf".\{monkey}_electrode_positions.npy", positions_arr)
np.save(rf".\{monkey}_electrode_ID.npy", ID_array)
