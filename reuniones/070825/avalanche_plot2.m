function avalanche_plot2(dur_values, dur_counts, size_values, size_counts, D, S, ax1, ax2, ax3)
    
    hold(ax1, 'on')
    plot(ax1, dur_values, dur_counts, '--o');
    set(ax1,'xscale','log', 'yscale', 'log');
    grid(ax1, 'on')
    
    hold(ax2, 'on')
    plot(ax2, size_values, size_counts, '--o');
    set(ax2,'xscale','log', 'yscale', 'log');
    grid(ax2, 'on')
    
    hold(ax3, 'on')
    plot(ax3, D, S, '--o')
    set(ax3,'xscale','log', 'yscale', 'log');
    grid(ax3, 'on')

    
end