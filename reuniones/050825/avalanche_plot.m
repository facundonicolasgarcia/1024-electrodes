function avalanche_plot(durations, sizes, ax1, ax2, ax3)

    d_max = max(durations);
    d_min = min(durations);
    s_max = max(sizes);
    s_min = min(sizes);
    
    d_logbins = logspace(log10(d_min), log10(d_max), 100);
    s_logbins = logspace(log10(s_min), log10(s_max), 100);
    
    [dur_counts, dur_values] = hist(durations, d_logbins);
    [size_counts, size_values] = hist(sizes, s_logbins);
    
    
    hold(ax1, 'on')
    plot(ax1, dur_values(dur_counts ~= 0), dur_counts(dur_counts ~= 0), '--o');
    set(ax1,'xscale','log', 'yscale', 'log');
    grid(ax1, 'on')
    
    hold(ax2, 'on')
    plot(ax2, size_values(size_counts ~= 0), size_counts(size_counts ~= 0), '--o');
    set(ax2,'xscale','log', 'yscale', 'log');
    grid(ax2, 'on')
    
    hold(ax3, 'on')
    scatter(ax3, durations, sizes, '.');
    %hold on
    %plot(D, S, '--o');
    set(ax3,'xscale','log', 'yscale', 'log');
    grid(ax3, 'on')
end