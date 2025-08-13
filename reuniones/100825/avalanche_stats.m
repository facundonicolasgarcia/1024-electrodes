function [dur_v, dur_c, size_v, size_c, D, S] = avalanche_stats(durations, sizes)
    [dur_v, ~, dur_idx] = unique(durations);
    dur_c = accumarray(dur_idx, 1);
    
    [size_v, ~, size_idx] = unique(sizes);
    size_c = accumarray(size_idx, 1);
    
    [D, S] = mean_by_group(durations, sizes);
end