clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP4_array8_LFP.mat", "lfp");

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
threshold = -20;
[peak_amp, peak_loc] = peaks(-signal);
idx = -peak_amp<threshold; % indexes where the peak passes the threshold
active = zeros(size(peak_amp));
active(idx) = 1;

%% Calcular avalanchas

windowSizes = 2:8;
durations = {};
sizes = {};
dur_values = {};
dur_counts = {};
size_values = {};
size_counts = {};
D = {};
S = {};

for i = 1:length(windowSizes)
    ids = [];
    for j=0:windowSizes(i)-1
        ids = [ids (1:windowSizes(i))+j*8];
    end

    activity = sum(active(:, ids), 2);
    [dur, siz] = avalanche_hunter(activity);
    durations{i} = dur;
    sizes{i} = siz;

    [dur_v, ~, dur_idx] = unique(dur);
    dur_c = accumarray(dur_idx, 1);
    [size_v, ~, size_idx] = unique(siz);
    size_c = accumarray(size_idx, 1);

    dur_values{i} = dur_v;
    dur_counts{i} = dur_c;
    size_values{i} = size_v;
    size_counts{i} = size_c;

    [d, s] = mean_by_group(dur, siz);
    D{i} = d;
    S{i} = s;
end

% %% Plotear avalanchas
% %[D, S] = mean_by_group(durations, sizes);
% figure;
% ax1 = subplot(131);
% ax2 = subplot(132);
% ax3 = subplot(133);
% 
% for i = 1:length(windowSizes)
%     avalanche_plot(durations{i}, sizes{i}/windowSizes(i)^2, ax1, ax2, ax3)
% end
% 
% xlabel(ax1, "Duración (1/\Deltat)");
% ylabel(ax1, "P(Duración)");
% 
% xlabel(ax2, "Tamaño (1/L^2)");
% ylabel(ax2, "Número de avalanchas");
% 
% xlabel(ax3, "Duración (1/\Deltat)");
% ylabel(ax3, "Tamaño medio (1/L^2)");
% 
% legend(ax1, string(windowSizes*400)+'\mum');

%% Plotear avalanchas
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

for i = 1:length(windowSizes)
        hold(ax1, 'on')
        plot(ax1, dur_values{i}/windowSizes(i)^2, dur_counts{i}*windowSizes(i)^2, '--o');
        
        hold(ax2, 'on')
        plot(ax2, size_values{i}/windowSizes(i)^2, size_counts{i}*windowSizes(i)^2, '--o');

        hold(ax3, 'on')
        plot(ax3, D{i}/windowSizes(i), S{i}/windowSizes(i)^2, '--o')
end

set(ax1,'xscale','log', 'yscale', 'log');
grid(ax1, 'on')
xlabel(ax1, "Duración/(\Deltat\timesL^2)");
ylabel(ax1, "Número de avalanchas\timesL^2");

set(ax2,'xscale','log', 'yscale', 'log');
grid(ax2, 'on')
xlabel(ax2, "Tamaño/L^2");
ylabel(ax2, "Número de avalanchas\times L^2");

set(ax3,'xscale','log', 'yscale', 'log');
grid(ax3, 'on')
xlabel(ax3, "Duración/(\Deltat\timesL)");
ylabel(ax3, "Tamaño medio/L^2");

legend(ax1, string(windowSizes*400)+'\mum');