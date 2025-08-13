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

%%
positions_file = fullfile("A_electrode_positions.mat");
load(positions_file, 'positions_arr');

%% Calculate skewness of each electrode

skw = skewness(data, 1, 1);
%%
figure
max_skw = 3;
small_skw = abs(skw)<max_skw;
scatter(positions_arr(small_skw,1), positions_arr(small_skw,2), 40, skw(small_skw), 'filled')
colormap(parula)     % or any other colormap: jet, hot, viridis (if installed)
colorbar
xlabel('x')
ylabel('y')
axis equal
%% Calculate standard deviation of each electrode
figure;
sd = std(data, 1, 1, 'omitnan');

plot(sd);
hold on
array_lims = (0:16)*64+1;
for i=array_lims
    xline(i, '--', 'black');
end

%% Plot k signals of extreme skewness
arr_ids = floor((0:1023)/64)+1;
map = arr_ids~=9 & arr_ids~=10;

k = 3;  % number of greatest values
[~, sortedIdx] = sort(skw.*map, 'descend');
topKIdx = sortedIdx(1:k);

figure;
plot((1:num_times)*timestep, data(:,topKIdx))

%% Save Skewness

save("skewness.mat", "skw");

%% Compute 100 more skewed signal's correlation matrix

load("events1.mat", "events")

k = 100;  % number of greatest values
arr_ids = floor((0:1023)/64)+1;
map = arr_ids~=9 & arr_ids~=10;
[~, sortedIdx] = sort(skw.*map, 'descend');
topKIdx = sortedIdx(1:k);

%%
skewed_signals = data;%(:, topKIdx);
CM = corr(skewed_signals);

imagesc(CM);
colorbar; % adds the color scale
axis equal tight; % makes the pixels square and fits the axes