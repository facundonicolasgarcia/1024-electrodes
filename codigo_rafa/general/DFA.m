%% Load data

clear all
close all
clc

% Información del archivo .h5
path = "..\..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');
dataset = '/LFP';
info = h5info(filename, dataset);

data = h5read(filename, dataset);

num_times = info.Dataspace.Size(1); % cantidad de tiempos de muestreo
timestep = 1/500; % in seconds

%% Compute DFA for many subsamples
data = data(1:977000,:);
n_pts = 20;
max = 5;
pts = floor(logspace(1, max, n_pts));
subsampling_factors = 2.^(0:2:6);
ids = 1;


i=0;
colors = jet(numel(subsampling_factors));

figure
for s=subsampling_factors
    i=i+1;
    disp(s);
    
    mask = subsample_mask(s) & filter_arrays(ids);
    mean_signal = mean(data(:, mask), 2, "omitnan");
    [~,F] = DFA_fun(mean_signal,pts,1);
    
    loglog(pts, F, '--o', 'Color', colors(i,:), 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', colors(i,:))
    hold on
end

legend("1/" + subsampling_factors);