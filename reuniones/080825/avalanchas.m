clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
signal = (lfp-repmat(mean(lfp, 1), size(lfp, 1), 1))./repmat(std(lfp,1,1), size(lfp, 1), 1);

%% Funcion definir power law a ajustar

ft = fittype('a*x^(-b)', 'independent', 'x', 'coefficients', {'a', 'b'});

%% Parametros
fs = 500;
t=(1:size(lfp, 1))/fs;

threshold = -.5;
dt = 2;

%%

% calcular activaciones
[peak_amp, peak_loc] = peaks(-signal);
idx = -peak_amp<threshold;
active = zeros(size(peak_amp));
active(idx) = 1;

% calcular distribuciones
activity = sum(binnedArray(active, dt),2);
[dur, siz] = avalanche_hunter(activity);


[dur_v, ~, dur_idx] = unique(dur);
dur_c = accumarray(dur_idx, 1);
PD = fit(dur_v(dur_v<10)', dur_c(dur_v<10), ft, 'StartPoint', [1e4, 2]);

[size_v, ~, size_idx] = unique(siz);
size_c = accumarray(size_idx, 1);
PS = fit(size_v(size_v<64)', size_c(size_v<64), ft, 'StartPoint', [1e4, 1.5]);


[D, S] = mean_by_group(dur, siz);

%% Plotear avalanchas
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

hold(ax1, 'on')
plot(ax1, dur_v, dur_c, '--o');
dd = logspace(0, 1, 20);
plot(ax1, dd, PD(dd));
legend(ax1, ["Distribución" sprintf("\\alpha=%.2f", PD.b)])

hold(ax2, 'on')
plot(ax2, size_v, size_c, '--o');
ss = logspace(0, log10(64), 20);
plot(ax2, ss, PS(ss));
legend(ax2, ["Distribución" sprintf("\\tau=%.2f", PS.b)])

hold(ax3, 'on')
plot(ax3, D, S, '--o')

set(ax1,'xscale','log', 'yscale', 'log');
grid(ax1, 'on')
xlabel(ax1, "Duración/\Deltat");
ylabel(ax1, "Número de avalanchas");

set(ax2,'xscale','log', 'yscale', 'log');
grid(ax2, 'on')
xlabel(ax2, "Tamaño");
ylabel(ax2, "Número de avalanchas");

set(ax3,'xscale','log', 'yscale', 'log');
grid(ax3, 'on')
xlabel(ax3, "Duración/\Deltat");
ylabel(ax3, "Tamaño medio");
