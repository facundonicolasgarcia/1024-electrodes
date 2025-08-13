clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP8_array15_LFP.mat", "lfp");

% Parametros

fs = 500;
t=(1:size(lfp, 1))/fs;

%% Filtrar señal
low = 50;
high = 0.001;
%signal = lowpass(lfp, low, fs);
%signal = highpass(signal, high, fs);
%mn = repmat(mean(signal, 1), size(signal, 1), 1);
%st = repmat(std(signal, 1, 1), size(signal, 1), 1);
%signal = (signal-mn)./st;
signal = lfp;

%% Crear distintos arrays de activación

%% 1 - Señal binarizada
threshold = -50;
active = signal<repmat(threshold, size(signal, 1), 1);

%% 2 - Señal binarizada intervalos de activacion divididos por duracion
active2 = zeros(size(active));
rt=.02; % in s
window = round(rt*fs);

for elec = 1:64
    disp(elec);
    time=0; % time since the begining of an activation
    for i=1:size(active, 1)
        a=active(i,elec);
        if (~a & time>0)
            active2(i-time:i-1, elec) = 1/time;
            time=0;
        % elseif a && time==window
        %     active2(i-time+1:i, elec) = 1/time;
        %     time=0;
        elseif active(i,elec)
            time=time+1;
        end
        
    end
end

%% 3 - Sólo el primer instante de una activación
active3 = zeros(size(active));
rt=.02; % in s
window = round(rt*fs);

for elec = 1:64
    disp(elec);
    time=0; % time since the begining of an activation
    for i=1:size(active, 1)
        a=active(i,elec);
        if (~a & time>0)
            active3(i-time, elec) = 1; % active in the beginning
            time=0;
        elseif a && time==window
            active3(i-time+1, elec) = 1; % active in the beginning
            time=0;
        elseif a
            time=time+1;
        end
        
    end
end

%% 4 - Picos
[peak_amp, peak_loc] = peaks(-signal);
idx = -peak_amp<threshold; % indexes where the peak passes the threshold
active4 = zeros(size(peak_amp));
active4(idx) = 1;

%% Calcular avalanchas

binWidth = 2e-3*fs;

activity = sum(binnedArray(active, binWidth),2);
activity2 = sum(binnedArray(active2, binWidth),2);
activity3 = sum(binnedArray(active3, binWidth),2);
activity4 = sum(binnedArray(active4, binWidth),2);

[durations, sizes] = avalanche_hunter(activity);
[durations2, sizes2] = avalanche_hunter(activity2);
[durations3, sizes3] = avalanche_hunter(activity3);
[durations4, sizes4] = avalanche_hunter(activity4);

%% Plotear avalanchas
%[D, S] = mean_by_group(durations, sizes);
figure;
ax1 = subplot(131);
ax2 = subplot(132);
ax3 = subplot(133);
avalanche_plot(durations/fs*binWidth, sizes, ax1, ax2, ax3)
avalanche_plot(durations2/fs*binWidth, sizes2, ax1, ax2, ax3)
avalanche_plot(durations3/fs*binWidth, sizes3, ax1, ax2, ax3)
avalanche_plot(durations4/fs*binWidth, sizes4, ax1, ax2, ax3)

xlabel(ax1, "Duración (s)");
ylabel(ax1, "# de avalanchas");

xlabel(ax2, "Tamaño (# electrodos)");
ylabel(ax2, "# de avalanchas");

xlabel(ax3, "Duración (s)");
ylabel(ax3, "Tamaño (# de electrodos)");

legend(ax1, ["Redundante" "1/duración" "Inicio" "Pico"]);
