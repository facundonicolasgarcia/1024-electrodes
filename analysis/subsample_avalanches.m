function [] = subsample_avalanches(mean_path, avalanches_path, threshold)
    load(mean_path, "m");
    m=m(~isnan(m));
    activity=(m>threshold).*(m-threshold);
    [durations, sizes] = avalanche_hunter(activity);
    save(avalanches_path, "activity", "durations", "sizes");
end