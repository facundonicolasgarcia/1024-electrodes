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
%% Plot signal of some electrodes
figure;
times = (1:num_times)*timestep;
plot(times,data(:,257));
hold on
plot(times,data(:,258));

%%
dif = data(:,257)-data(:,258);
figure;
plot(dif);

%%
[ps, f] = pspectrum(dif(~isnan(dif)), 500);
figure;
loglog(f, ps);

%%
figure;
pcolor(S);
shading flat; % removes grid lines
colorbar;
axis equal tight;


%%

fft1 = fft(data(:,257), 500);
fft2 = fft(data(:,258), 500);

tfunc = fft1./fft2;
%%
figure
L=numel(fft1);
f=(0:L-1)*500/L;
scatter(f, abs(fft1));
hold on
scatter(f, angle(fft1));
scatter(f, abs(fft2));
scatter(f, angle(fft2));
%%
figure
L=numel(tfunc);
f=(-(L-1)/2:(L-1)/2)*500/L;
scatter(f, abs(tfunc));
%hold on
%scatter(f, angle(tfunc));

%%
signal1 = data(:,257);
signal2 = data(:,258);
signal1 = signal1(~isnan(signal1));
signal2 = signal2(~isnan(signal2));
fdata1 = bandstop(signal1,[215 285], 500);
fdata2 = bandstop(signal2,[215 285], 500);
figure
plot(fdata1);
hold on
plot(fdata2);

%% Plot distribution of the signal

figure;
[counts, bins] = hist(signal, 100);
plot(bins, counts, '--o');

%% Load raw data

path = 'C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\raw\NSP1_aligned.mat';
path = strrep(path, '\', '\\');
load(path);