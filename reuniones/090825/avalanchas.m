clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
signal = lfp;

%% Definir power law a ajustar

ft = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});

%% Parametros
fs = 500;
t=(1:size(lfp, 1))/fs;

threshold = -15;
dt = 1;

%%

% calcular activaciones
active = signal < threshold;
active2 = active_array(active);

% calcular distribuciones
activity = sum(binnedArray(active2, dt),2);
[dur, siz] = avalanche_hunter(activity);


[dur_v, ~, dur_idx] = unique(dur);
dur_c = accumarray(dur_idx, 1);
PD = fit(log10(dur_v(1:5))', log10(dur_c(1:5)), ft, 'StartPoint', [1e4, -2]);

[size_v, ~, size_idx] = unique(siz);
size_c = accumarray(size_idx, 1);
PS = fit(log10(size_v(1:20))', log10(size_c(1:20)), ft, 'StartPoint', [1e4, -1.5]);

[D, S] = mean_by_group(dur, siz);
DS = fit(log10(D(1:5)), log10(S(1:5)), ft, 'StartPoint', [3, 2]);


%% Plotear avalanchas
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

hold(ax1, 'on')
plot(ax1, dur_v, dur_c, '--o');
dd = linspace(0, 1, 20);
plot(ax1, 10.^dd, 10.^PD(dd));
legend(ax1, ["Distribución" sprintf("\\alpha=%.2f", -PD.b)])

hold(ax2, 'on')
plot(ax2, size_v, size_c, '--o');
ss = linspace(0, log10(20), 20);
plot(ax2, 10.^ss, 10.^PS(ss));
legend(ax2, ["Distribución" sprintf("\\tau=%.2f", -PS.b)])

hold(ax3, 'on')
plot(ax3, D, S, '--o')
plot(ax3, 10.^dd, 10.^DS(dd));
legend(ax3, ["" sprintf("\\gamma=%.2f", DS.b)])

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

%% Plotear segunda derivada de avalanchas

x = log10(dur_v(1:end-2));
dx1 = diff(log10(dur_v(1:end-1)))';
dx2 = diff(log10(dur_v(2:end)))';

pdf = dur_c/sum(dur_c);
dy1 = diff(log10(pdf(1:end-1)));
dy2 = diff(log10(pdf(2:end)));

D2y = (dy1./dx1-dy2./dx2)./(dx1-dx2);

figure;
plot(x, log10(abs(D2y)), '--o');
