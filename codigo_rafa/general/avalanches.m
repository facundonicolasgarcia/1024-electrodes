%% Load events data

load("events.mat", "events", "threshold");

%%
timestep = 1/500;
%% Compute activity signal

activity = sum(events, 2);

%% Plot activity
figure
plot((0:length(activity)-1)*timestep,activity, '-')
hold on
event_times = find(events(:,1));
scatter((event_times-1).*timestep, event_times*0, 'o', 'filled');
%% Compute avalanche sizes and durations

[durations, sizes] = avalanche_hunter(activity);

%% Histograms

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
loglog(dur_values(dur_counts ~= 0)*timestep, dur_counts(dur_counts ~= 0), '--o');
grid on

subplot(132);
loglog(size_values(size_counts ~= 0), size_counts(size_counts ~= 0), '--o');
grid on

subplot(133);
loglog(D*timestep, S, '--o');
grid on

%% Save results

save("activity.mat", "activity");

%% Avalanches under subsampling

subsampling_factors = 2.^(0:1:3);

figure
i=0;
colors = jet(numel(subsampling_factors)); 
for s=subsampling_factors
    i=i+1;
    disp(s);
    
    mask = subsample_mask(s) & filter_arrays(1);
    activity = sum(events(:, mask), 2);
    
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

    subplot(131);
    loglog(dur_values(dur_counts ~= 0)*timestep, dur_counts(dur_counts ~= 0), '--o', 'Color', colors(i,:), 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', colors(i,:));
    hold on

    subplot(132);
    loglog(size_values(size_counts ~= 0), size_counts(size_counts ~= 0), '--o', 'Color', colors(i,:), 'MarkerFaceColor',colors(i,:), 'MarkerEdgeColor', colors(i,:));
    hold on

    subplot(133);
    loglog(D(1:1:end)*timestep, S(1:1:end), 'o', 'Color', colors(i,:), 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', colors(i,:));
    hold on
end

subplot(1, 3, 1);
legend("1/" + string(subsampling_factors));