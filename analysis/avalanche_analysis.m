%% Ejemplo avalanchas

close all
clear all
clc

threshold = 500;

data_path = sprintf('weighted_activity_%.2f.mat', threshold);
fig_path = sprintf('avalanches_%.2f.fig', threshold);
activity = load(data_path).activity;

num_times = length(activity);

%% Activity plot
plot(activity(1:100000));
ylabel('Active electrodes')
xlabel('Time')

%% Computation of avalanche sizes and durations
[durations, sizes] = avalanche_hunter(activity);
%% Figures

[dur_counts, dur_values] = hist(durations, 20);
[size_counts, size_values] = hist(sizes, 20);

figure(1)
subplot(2, 2, 1)
loglog(size_values,size_counts,'-o')
xlabel('Size')
grid on

subplot(2, 2, 2)
loglog(dur_values,dur_counts,'-o')
xlabel('Duration')
grid on

subplot(2, 2, [3 4])
plot(durations,sizes-threshold*durations,'x')
ylabel('Size-threshold*Duration')
xlabel('Duration')
grid on

%% Save figure

savefig(fig_path);