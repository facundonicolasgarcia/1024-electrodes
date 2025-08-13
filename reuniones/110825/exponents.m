close all
clear
%%
threshold = -15;
dt = 1;
load(sprintf("sizes_%g.mat", threshold), "sizes");
load(sprintf("durations_%g.mat", threshold), "durations");

%%
ft = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});
%%

[dur_v, dur_c, size_v, size_c, D, S] = avalanche_stats(durations{dt}, sizes{dt});
PD = fit(log10(dur_v(1:5))', log10(dur_c(1:5)), ft, 'StartPoint', [1e4, -2]);
PD2 = fit(log10(dur_v(13:21))', log10(dur_c(13:21)), ft, 'StartPoint', [1e4, -2]);
PS = fit(log10(size_v(1:20))', log10(size_c(1:20)), ft, 'StartPoint', [1e4, -1.5]);
DS = fit(log10(D(2:5)), log10(S(2:5)), ft, 'StartPoint', [3, 2]);
DS2 = fit(log10(D(13:21)), log10(S(13:21)), ft, 'StartPoint', [3, 2]);

%% Plotear avalanchas
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

hold(ax1, 'on')
plot(ax1, dur_v, dur_c, '--o');
dd = linspace(0, 1, 20);
plot(ax1, 10.^dd, 10.^PD(dd));
dd = linspace(log10(10), log10(21), 20);
plot(ax1, 10.^dd, 10.^PD2(dd));
legend(ax1, ["" sprintf("\\alpha=%.2f", -PD.b) sprintf("\\alpha=%.2f", -PD2.b)])

hold(ax2, 'on')
plot(ax2, size_v, size_c, '--o');
ss = linspace(0, log10(20), 20);
plot(ax2, 10.^ss, 10.^PS(ss));
legend(ax2, ["" sprintf("\\tau=%.2f", -PS.b)])

hold(ax3, 'on')
plot(ax3, D, S, '--o');
dd = linspace(0, 1, 20);
plot(ax3, 10.^dd, 10.^DS(dd));
dd = linspace(log10(5), log10(21), 20);
plot(ax3, 10.^dd, 10.^DS2(dd));
legend(ax3, ["" sprintf("\\gamma=%.2f", DS.b) sprintf("\\gamma=%.2f", DS2.b)])

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