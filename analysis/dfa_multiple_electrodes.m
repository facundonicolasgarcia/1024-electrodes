clear all
close all
clc

% Información del archivo .h5
path = "..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');
dataset = '/LFP';
info = h5info(filename, dataset);

%% Some parameters
num_times = info.Dataspace.Size(1); % cantidad de tiempos de muestreo
n_max=5;
pts = floor(logspace(1, n_max, 5));
electrodes=1:64:1024;

%% Compute dfa for the given electrodes
F = zeros(length(electrodes), length(pts));
disp("Starting loop")
for i=1:length(electrodes)
    electrode=electrodes(i);
    disp(electrode);
    [A, f] = do_dfa(electrode, filename, dataset, num_times, pts);
    F(i, :) = f;
    graficar_dfa(pts, F);
end
%% Funciones

function [A, F] = do_dfa(electrode, filename, dataset, num_times, pts)
    signal = h5read(filename, dataset, [1, electrode], [num_times, 1]);
    signal = signal(~isnan(signal));    
    [A,F] = DFA_fun(signal,pts,1);
end

function [] = graficar_dfa(pts, F)
    plot(log10(pts),log10(F))
end