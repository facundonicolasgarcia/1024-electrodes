clear all
close all
clc

% Información del archivo .h5
path = "..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');
dataset = '/LFP';
info = h5info(filename, dataset);

num_times = info.Dataspace.Size(1); % cantidad de tiempos de muestreo

%% Cargar la señal del electrodo elegido
electrode = 1;
signal = h5read(filename, dataset, [1, electrode], [num_times, 1]);
signal = signal(~isnan(signal)); % elimina las entradas NaN (son sólo los últimos elementos)
n_max = log10(length(signal)); % máximo valor para la "box length"

%% Cálculo de F(n)
%plot_fun = @(xp,A,ord) polyval(A,log(xp));
pts = floor(logspace(1, n_max, 100));
[A,F] = DFA_fun(signal,pts);
A(1)

%% Gráfica de F(n) vs n en loglog
F_powerlaw = @(x) (log10(F(1))+(x-log10(pts(1)))); % curva para ruido 1/f en loglog
F_brown = @(x) (log10(F(1))+1.5*(x-log10(pts(1)))); % curva para ruido Browneano en loglog

x0 = log10(pts(1));
x1 = log10(pts(end));
x = [x0, x1];

scatter(log10(pts),log10(F))
hold on
plot( x, arrayfun(F_powerlaw, x), '--' )
plot( x, arrayfun(F_brown, x), '--' )
legend('data', '1/f', 'Brownian');
hold off
