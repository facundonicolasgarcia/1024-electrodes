% find max and min of each electrode

clear
close all
clc

%%
path = "..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');

dataset = '/LFP';

info = h5info(filename, dataset);

num_times=info.Dataspace.Size(1);
num_electrodes=info.Dataspace.Size(2);

%% load the .h5 file
array = h5read(filename, dataset);

%% get max and min of each electrode
maxs = max(array, [], 1);
mins = min(array, [], 1);

%% Save data
save('maxs.mat', "maxs");
save('mins.mat', "mins");

%% Plot max and min of electrodes
figure(1)
plot(maxs(1:1024))
hold on
plot(mins(1:1024))

%% Plot lfp signal of some electrodes
figure(2)
subplot(2,1,1)
plot(array(:, 401))
subplot(2,1,2)
plot(array(:, 432))

%% Calculate the fourier transform
signal1 = array(:, 432);
fft1 = fft(signal1(~isnan(signal1)));

signal2 = array(:, 216);
fft2 = fft(signal2(~isnan(signal2)));

%% Plot modulus the fourier transform
figure(3)
subplot(2,1,1)
plot(smoothdata(sqrt(real(fft1).^2+imag(fft1).^2)), LineStyle="none", Marker=".")
subplot(2,1,2)
plot(smoothdata(sqrt(real(fft2).^2+imag(fft2).^2)), LineStyle="none", Marker=".")

%% Power spectrum

electrode = 1;
signal = h5read(filename, dataset, [1, electrode], [num_times, 1]);
signal = signal(~isnan(signal)); % elimina las entradas NaN (son sólo los últimos elementos)

ps = pspectrum(signal);

loglog(ps);