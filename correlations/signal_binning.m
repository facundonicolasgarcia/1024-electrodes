clear

%% Load data
path = "..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');
dataset = '/LFP';
info = h5info(filename, dataset);
num_times = info.Dataspace.Size(1);

%% Create z_score of signal
signal = h5read(filename, dataset, [1 1], [977289 1024]);
z_score=(signal-mean(signal, 1))./std(signal, 1, 1);

%% Get a new signal by averaging inside bins of a given timespan

f = 500; % [Hz]
t_bin = 0.01; % [s]
points_bin = t_bin*f; % datapoints in a single bin
points_all = size(z_score, 1); % datapoints of the whole signal
n_bins = ceil(points_all / points_bin);
n_electrodes = size(z_score, 2);

binned_z_score = zeros(n_bins, n_electrodes);
for b=0:n_bins-1
    ini = b*points_bin+1;
    fin = min((b+1)*points_bin, points_all);
    binned_z_score(b+1, :) = mean(z_score(ini:fin, :), 1);
end

%% Save the obtained signal

filename=strjoin(["binned_" num2str(t_bin) "s_z_score_A_RS_140819_LFP.mat"], "");
save(filename, "binned_z_score");