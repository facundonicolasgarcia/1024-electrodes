function [] = subsample_mean(signal, space_mask, time_mask, mean_path)
    m = mean(signal(time_mask, space_mask), 2);
    save(mean_path, "m");
end