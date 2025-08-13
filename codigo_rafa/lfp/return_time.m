clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");

%% Parametros

fs = 500;
low = 50;

%% Filtrar señal

%filtered = lowpass(lfp, low, fs);
filtered = lfp;
%% Calculo de curva threshold vs return time

thresholds = 0:-10:-100;
ret_times=zeros(size(thresholds));

for i=1:size(thresholds, 2)
    disp(i);
    thr=thresholds(i);
    active = filtered<repmat(thr, size(filtered, 1), 1);
    
    dur = [];
    siz = [];
    for j=1:64
        [d, s] = avalanche_hunter(active(:,j));
        dur = [dur d];
    end
    
    ret_times(i) = mean(dur);
end

%%
figure
plot(thresholds, ret_times/fs, '--s');
xlabel("Threshold (\muV)");
ylabel("Mean return time (s)");