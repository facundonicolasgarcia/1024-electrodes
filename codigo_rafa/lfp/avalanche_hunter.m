function [durations,sizes] = avalanche_hunter(activity)

    % ------------------------------------------------------------
    % DESCRIPTION:
    %   avalanche_hunter returns the durations and sizes of the avalanches of
    %   an activity series. An avalanche is a time interval where the activity
    %   is non-zero for all times.
    %
    %   INPUTS
    %   activity: one-dimensional array. Index represents time.
    %
    %   OUTPUTS
    %   durations: one-dimensional array.
    %   sizes: one-dimensional array.
    
    
    num_times = length(activity);
    durations = [];
    sizes = [];
    ava_index = 0; % ava stands for avalanche
    ava_start=1;
    ava_end=1;

    while ava_start<=num_times
    
        % Jump inactive periods
        while (ava_start<=num_times) && (activity(ava_start) == 0)
            ava_start = ava_start + 1;
        end
        
        ava_end = ava_start;
        
        % Find the biggest active time window
        while (ava_end<=num_times) && (activity(ava_end)>0)
            ava_end = ava_end+1;
        end
        
        duration=ava_end-ava_start;
        if duration > 0
            ava_index=ava_index+1;
            durations(ava_index)=duration;
            sizes(ava_index)=sum(activity(ava_start:ava_end-1));
        end
    
        ava_start=ava_end+1;
    end
end