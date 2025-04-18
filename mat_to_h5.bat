SETLOCAL
set source_dir=C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\
set h5_path=C:\Users\facun\Facundo\neurociencia\codigo_tesina\hdf5\A_RS_140819\LFP.h5
python mat_to_h5.py source_dir h5_path --dataset_name "LFP"
ENDLOCAL
REM This batch file sets the source directory and HDF5 file path, then calls a Python script to convert .mat files to .h5 format.