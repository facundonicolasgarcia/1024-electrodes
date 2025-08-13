clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");

% Parametros

fs = 500;
t=(1:size(lfp, 1))/fs;

%% Filtrar señal
%low = 50;
%high = 0.001;
%signal = lowpass(lfp, low, fs);
%signal = highpass(signal, high, fs);
%mn = repmat(mean(signal, 1), size(signal, 1), 1);
%st = repmat(std(signal, 1, 1), size(signal, 1), 1);
%signal = (signal-mn)./st;
signal = lfp;

%% Array de activaciones
threshold = -50;
[peak_amp, peak_loc] = peaks(-signal);
idx = -peak_amp<threshold; % indexes where the peak passes the threshold
active = zeros(size(peak_amp));
active(idx) = 1;

%% Calcular avalanchas

binWidths = [1 2 4 8];
durations = {};
sizes = {};

for i = 1:length(binWidths)
    activity = sum(binnedArray(active, binWidths(i)),2);
    [dur, siz] = avalanche_hunter(activity);
    durations{i} = dur;
    sizes{i} = siz;
end

%% Plotear avalanchas
%[D, S] = mean_by_group(durations, sizes);
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

for i = 1:length(binWidths)
    avalanche_plot(durations{i}, sizes{i}, ax1, ax2, ax3)
end

xlabel(ax1, "Duración/\Deltat");
ylabel(ax1, "P(Duración)");

xlabel(ax2, "Tamaño");
ylabel(ax2, "P(Tamaño)");

xlabel(ax3, "Duración/\Deltat");
ylabel(ax3, "Tamaño medio");

legend(ax1, string(1e3*binWidths/fs)+'ms');