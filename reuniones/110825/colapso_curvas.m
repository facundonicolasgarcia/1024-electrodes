close all
clear
%% Parámetros
threshold = -15;
dt = 1;

%%
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
active = lfp < threshold;
active = active_array(active);
%% Calcular avalanchas

L = 2:8;
dur_values = cell(size(L));
dur_counts = cell(size(L));
size_values = cell(size(L));
size_counts = cell(size(L));
D = cell(size(L));
S = cell(size(L));

for i = 1:length(L)
    ids = zeros(L(i)^2, 1);
    for j=0:L(i)-1
        ids(j*L(i)+1:(j+1)*L(i)) = (1:L(i))+j*8;
    end

    activity = sum(active(:, ids), 2);
    [durations, sizes] = avalanche_hunter(activity);
    [dur_v, dur_c, size_v, size_c, D_tmp, S_tmp] = avalanche_stats(durations, sizes);
    dur_values{i} = dur_v;
    dur_counts{i} = dur_c;
    size_values{i} = size_v;
    size_counts{i} = size_c;
    D{i} = D_tmp;
    S{i} = S_tmp;
end