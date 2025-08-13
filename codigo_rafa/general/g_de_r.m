%% Load data
clear all 

signal_file = fullfile("events.mat");
positions_file = fullfile("A_electrode_positions.mat");
load(signal_file, "events");
load(positions_file, 'positions_arr');

%% Calculate G(r)

mask = filter_arrays(1);

P = events;
%P = ones(10, 64);
nbins = 16;
x=positions_arr(:, 1);
y=positions_arr(:, 2);
Rmax = hypot(max(x)-min(x), max(y)-min(y));
dr = Rmax/nbins;
[G, N_r, N_a] = rad_dist(P, x, y, nbins, dr);

%%
figure
loglog((1:nbins+1)*dr, G(1:nbins+1));