function [durations, sizes] = loadResults(metaFile, threshold)
%LOADRESULTS Load durations and sizes for a given threshold
%
%   [durations, sizes] = LOADRESULTS(metaFile, threshold)
%   loads the arrays for the specified threshold from metadata file metaFile.
%
%   metaFile   - path to the metadata .mat file (e.g., 'results.mat')
%   threshold  - numeric threshold value to search for
%
%   durations, sizes - arrays loaded from their respective files

    % Load metadata
    data = load(metaFile, 'thresholds', 'files_durations', 'files_sizes');

    % Find index of requested threshold
    idx = find(data.thresholds == threshold, 1);
    if isempty(idx)
        error('Threshold %g not found in %s.', threshold, metaFile);
    end

    % Load the specific files
    durData = load(data.files_durations{idx}, 'durations_new');
    szData  = load(data.files_sizes{idx}, 'sizes_new');

    durations = durData.durations_new;
    sizes     = szData.sizes_new;
end
