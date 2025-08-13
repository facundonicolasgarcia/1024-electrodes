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

%% Exponentes de L=8
ft = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});

dur_v = dur_values{end};
dur_c = dur_counts{end};
size_v = size_values{end};
size_c = size_counts{end};
D_ = D{end};
S_ = S{end};
PD = fit(log10(dur_v(1:5))', log10(dur_c(1:5)), ft, 'StartPoint', [1e4, -2]);
PS = fit(log10(size_v(1:20))', log10(size_c(1:20)), ft, 'StartPoint', [1e4, -1.5]);
DS = fit(log10(D_(2:5)), log10(S_(2:5)), ft, 'StartPoint', [3, 2]);

%%
lambda1=-2;
lambda2=0;
delta1 = -.0;
delta2 = .0;

tau = -PS.b;
a=lambda1+delta1;
b=-tau*(lambda1+delta1)+lambda2+delta2;

figure;
hold on
for i=1:length(L)
    plot(log10(size_values{i})+log10(L(i))*a, log10(size_counts{i}/sum(size_counts{i}))+log10(L(i))*b, '--o');
end
hold off

%%
lambda1=-1;
lambda2=0;

alpha = -PD.b;
a=lambda1;
b=-tau*lambda1+lambda2;

figure;
hold on
for i=1:length(L)
    plot(log10(dur_values{i})+log10(L(i))*a, log10(dur_counts{i}/sum(dur_counts{i}))+log10(L(i))*b, '--o');
end
hold off

%%

lambda1=-1;
lambda2=0;

alpha = -PD.b;
a=lambda1;
b=-tau*lambda1+lambda2;
X = cell(numel(dur_values), 1);
Y = cell(numel(dur_values), 1);

for i=1:numel(dur_values)
    X{i} = log10(dur_values{i})+log10(L(i))*a;
    Y{i} = log10(dur_counts{i}/sum(dur_counts{i}))+log10(L(i))*b;
end
distancia_funciones(X, Y, 50)

%%
lambda1 = -1;
lambda2 = 0;
delta1 = -.5:.01:.5;
delta2 = -.5:.01:.5;
n = 50;
dist_dur = scaling(dur_values, dur_counts, L, n, -alpha, lambda1, lambda2, delta1, delta2);

[mn, linear_idx] = min(dist_dur, [], 'all');
[i, j] = ind2sub([size(dist_dur)], linear_idx);

figure;
hold on
imagesc(delta1, delta2, dist_dur');
colormap(flipud(gray));
colorbar;
clim([mn 1]);

scatter(delta1(i), delta2(j), 'x', 'red');
legend('\delta_1 = '+string(delta1(j))+',   \delta_2 = '+string(delta1(i)));
hold off

xlabel('\delta_1');
ylabel('\delta_2');

%%
lambda1 = -2;
lambda2 = 0;
delta1 = -.5:.01:.5;
delta2 = -.5:.01:.5;
n = 50;
dist_size = scaling(size_values, size_counts, L, n, -tau, lambda1, lambda2, delta1, delta2);

[mn, linear_idx] = min(dist_size, [], 'all');
[i, j] = ind2sub([size(dist_size)], linear_idx);

figure;
hold on
imagesc(delta1, delta2, dist_size');
colormap(flipud(gray));
colorbar;
clim([mn 1]);

scatter(delta1(i), delta2(j), 'x', 'red');
legend('\delta_1 = '+string(delta1(j))+',   \delta_2 = '+string(delta1(i)));
hold off

xlabel('\delta_1');
ylabel('\delta_2');