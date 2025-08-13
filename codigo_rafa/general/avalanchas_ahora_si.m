close all
clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP8_array15_LFP.mat", "lfp");

%% Parametros

fs = 500;
low = 50;
high = 0.001;

%% Filtrar señal

signal = lowpass(lfp, low, fs);
signal = highpass(signal, high, fs);

%signal = lfp;
%% Binarizar señal

threshold = 50;
active = -signal>repmat(threshold, size(signal, 1), 1);

%%
t=(1:size(lfp, 1))/fs;
figure
imagesc(t, 1:64, active');

%% Tiempo medio de retorno
dur = [];
siz = [];
for i=1:64
    [d, s] = avalanche_hunter(active(:,i));
    dur = [dur d];
    siz = [siz s];
end

figure
histogram(dur/500);

%% Remove redundant activity
% remove activation within a refractary time of the first activation

active2 = zeros(size(active));
rt=.02; % in s
window = round(rt*fs);

for elec = 1:64
    disp(elec);
    time=0; % time since the begining of an activation
    for i=1:size(active, 1)
        a=active(i,elec);
        if (~a & time>0)
            active2(i-time, elec) = 1; % active in the beginning
        %    active2(i-time:i-1, elec) = 1/time;
            time=0;
        elseif a && time==window
            active2(i-time+1, elec) = 1; % active in the beginning
        %     active2(i-time+1:i, elec) = 1/time;
            time=0;
        elseif active(i,elec)
            time=time+1;
        end
        
    end
end

%%
t=(1:size(lfp, 1))/fs;
figure
imagesc(t, 1:64, active2');
%% Actividad
activity = sum(active, 2);
activity2 = sum(active2, 2);
figure
plot(t, activity);
hold on
plot(t, activity2);
%% Avalanchas

[durations, sizes] = avalanche_hunter(activity);
[durations2, sizes2] = avalanche_hunter(activity2);

%[D, S] = mean_by_group(durations, sizes);
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);
avalanche_plot(durations/fs, sizes, ax1, ax2, ax3)
avalanche_plot(durations2/fs, sizes2, ax1, ax2, ax3)

xlabel(ax1, "Duración (s)");
ylabel(ax1, "# de avalanchas");

xlabel(ax2, "Tamaño (# electrodos)");
ylabel(ax2, "# de avalanchas");

xlabel(ax3, "Duración (s)");
ylabel(ax3, "Tamaño (# de electrodos)");

legend(ax1, ["Redundante" "Corregido"]);

%% Avalanchas con subsampling
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);

sample_ratios = [1 2 4 8];
for s=sample_ratios
    mask=subsample_mask(s);
    mask=mask(1:64);
    active3 = active2(:, mask);
    activity3 = sum(active3, 2);
    [durations3, sizes3] = avalanche_hunter(activity3);
    avalanche_plot(durations3/fs, sizes3, ax1, ax2, ax3)
end

xlabel(ax1, "Duración (s)");
ylabel(ax1, "# de avalanchas");

xlabel(ax2, "Tamaño (# electrodos)");
ylabel(ax2, "# de avalanchas");

xlabel(ax3, "Duración (s)");
ylabel(ax3, "Tamaño (# de electrodos)");

legend(ax1, "1/"+string(sample_ratios));

%%

figure;
interv = 1e4:1.1e4;
plot(t(interv), signal(interv, 1:2));

