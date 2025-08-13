function avalanche_plot(durations, sizes, ax1, ax2, ax3)
    
    [dur_values, ~, dur_idx] = unique(durations);
    dur_counts = accumarray(dur_idx, 1);
    [size_values, ~, size_idx] = unique(sizes);
    size_counts = accumarray(size_idx, 1);
    
    
    hold(ax1, 'on')
    plot(ax1, dur_values, dur_counts/sum(dur_counts, 'all'), '--o');
    set(ax1,'xscale','log', 'yscale', 'log');
    grid(ax1, 'on')
    
    hold(ax2, 'on')
    plot(ax2, size_values, size_counts, '--o');
    set(ax2,'xscale','log', 'yscale', 'log');
    grid(ax2, 'on')
    
    hold(ax3, 'on')
    [D, S] = mean_by_group(durations, sizes);
    plot(ax3, D, S, '--o')
    %scatter(ax3, durations, sizes, '.');
    set(ax3,'xscale','log', 'yscale', 'log');
    grid(ax3, 'on')
end