close all
clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
signal = lfp;

%%

mn = -100;
mx = 0;
n = 100;
threshold = mn:(mx-mn)/n:mx;
dt = 1:3;

%%

fname_meta = 'results.mat';

if ~isfile(fname_meta)
    thresholds = [];
    files_durations = {};
    files_sizes = {};
    save(fname_meta, 'thresholds', 'files_durations', 'files_sizes');
end

load(fname_meta, 'thresholds', 'files_durations', 'files_sizes');

%%
for i=1:length(threshold)
    disp("Threshold = "+string(threshold(i)));
    if any(thresholds == threshold(i))
        disp('Already computed.');
        continue
    end

    % calcular activaciones
    active = signal < threshold(i);
    active = active_array(active);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    durations = {};
    sizes = {};
    for j=1:length(dt)
        disp("    dt = "+string(dt(j)))
        activity = sum(binnedArray(active, dt(j)), 2); %%%%%%%%%%%%%%%%%%%
        [dur, siz] = avalanche_hunter(activity);        %%%%%%%%%%%%%%%%%%
        durations{1, j} = dur;
        sizes{1, j} = siz;
    end

    % Save heavy arrays separately
    dur_file = sprintf('durations_%g.mat', threshold(i));
    sz_file  = sprintf('sizes_%g.mat', threshold(i));
    save(dur_file, 'durations');
    save(sz_file, 'sizes');

    % Update metadata
    thresholds(end+1) = threshold(i);
    files_durations{end+1} = dur_file;
    files_sizes{end+1} = sz_file;
    save(fname_meta, 'thresholds', 'files_durations', 'files_sizes');
end
