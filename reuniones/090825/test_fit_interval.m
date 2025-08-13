clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
signal = lfp;

%% Parametros
fs = 500;
t=(1:size(lfp, 1))/fs;

threshold = -14;
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

[size_v, ~, size_idx] = unique(siz);
size_c = accumarray(size_idx, 1);

[D, S] = mean_by_group(dur, siz);

%% Definir power law a ajustar

ft = fittype('a*x^(-b)', 'independent', 'x', 'coefficients', {'a', 'b'});
ft1 = fittype('a*x^b', 'independent', 'x', 'coefficients', {'a', 'b'});

%%

ft = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});
ft1 = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});

%%
% PD = fit(dur_v(dur_v>=2 & dur_v<=8)', dur_c(dur_v>=2 & dur_v<=8), ft, 'StartPoint', [1e4, 2]);
% PS = fit(size_v(size_v>=3 & size_v<=20)', size_c(size_v>=3 & size_v<=20), ft, 'StartPoint', [1e4, 1.5]);
% DS = fit(D(2:8), S(2:8), ft1, 'StartPoint', [4, 2]);

max_dur = logspace(log10(5), max(log10(dur_v)));
max_siz = logspace(log10(20), max(log10(size_v)));

alpha = zeros(size(max_dur));
tau = zeros(size(max_siz));
gamma = zeros(size(max_siz));

%%
for i=1:length(max_dur)
    alpha(i) = -fit(log10(dur_v(dur_v<=max_dur(i)))', log10(dur_c(dur_v<=max_dur(i))), ft, 'StartPoint', [1e4, 2]).b;
    gamma(i) = fit(log10(D(D<=max_dur(i))), log10(S(D<=max_dur(i))), ft1, 'StartPoint', [4, 2]).b;
end
%%
for i=1:length(max_siz)
    tau(i) = -fit(log10(size_v(size_v<=max_siz(i)))', log10(size_c(size_v<=max_siz(i))), ft, 'StartPoint', [1e4, 1.5]).b;
end

%%

figure
subplot(311);
plot(max_dur, alpha, '--o');
subplot(312);
plot(max_dur, gamma, '--o');
subplot(313);
plot(max_siz, tau, '--o');

%%
%%
% PD = fit(dur_v(dur_v>=2 & dur_v<=8)', dur_c(dur_v>=2 & dur_v<=8), ft, 'StartPoint', [1e4, 2]);
% PS = fit(size_v(size_v>=3 & size_v<=20)', size_c(size_v>=3 & size_v<=20), ft, 'StartPoint', [1e4, 1.5]);
% DS = fit(D(2:8), S(2:8), ft1, 'StartPoint', [4, 2]);

max_dur = 12;
max_siz = 20;

alpha = zeros(size(max_dur));
tau = zeros(size(max_siz));
gamma = zeros(size(max_siz));

%%
for i=1:6
    x = dur_v(i:end);
    y = dur_c(i:end);
    alpha(i) = -fit(log10(x(x<=max_dur))', log10(y(x<=max_dur)), ft, 'StartPoint', [1e4, 2]).b;
    
    y = S(i:end);
    gamma(i) = fit(log10(x(x<=max_dur))', log10(y(x<=max_dur)), ft1, 'StartPoint', [4, 2]).b;
end
%%
for i=1:length(1:6)
    x = size_v(i:end);
    y = size_c(i:end);
    tau(i) = -fit(log10(x(x<=max_siz))', log10(y(x<=max_siz)), ft, 'StartPoint', [1e4, 1.5]).b;
end

%%

figure
subplot(311);
plot(1:6, alpha, '--o');
subplot(312);
plot(1:6, gamma, '--o');
subplot(313);
plot(1:6, tau, '--o');