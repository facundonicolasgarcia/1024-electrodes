load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP2_array4_LFP.mat", "lfp");

fs = 500; % example sampling frequency
lowcut = 0.1;
highcut = 50;

[b, a] = butter(4, [lowcut highcut]/(fs/2), 'bandpass');
filtered_lfp = filtfilt(b, a, lfp(:,1));

%%
N = round(0.020 * fs);           % fs in Hz
kernel = ones(1, N) / N;
filtered = conv(lfp(:,1), kernel, 'same');

N = round(1 * fs);           % fs in Hz
kernel = ones(1, N) / N;
filtered = filtered-conv(lfp(:,1), kernel, 'same');

%%
signal = filtered;
threshold = std(signal);
m = mean(signal);

activity=zeros(size(signal));
active = abs(signal-m) > threshold;
activity(active) = signal(active);
%activity = sum(activity, 2);

[durations, sizes] = avalanche_hunter(activity);

[D, S] = mean_by_group(durations, sizes);

d_max = max(durations);
d_min = min(durations);
s_max = max(sizes);
s_min = min(sizes);

d_logbins = logspace(log10(d_min), log10(d_max), 50);
s_logbins = logspace(log10(s_min), log10(s_max), 50);

[dur_counts, dur_values] = hist(durations, d_logbins);
[size_counts, size_values] = hist(sizes, s_logbins);

figure;
subplot(131);
loglog(dur_values(dur_counts ~= 0)/freq, dur_counts(dur_counts ~= 0), '--o');
grid on

subplot(132);
loglog(size_values(size_counts ~= 0), size_counts(size_counts ~= 0), '--o');
grid on

subplot(133);
loglog(D/freq, S, '--o');
grid on