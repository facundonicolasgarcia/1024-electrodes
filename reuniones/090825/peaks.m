function [peak_amp, peak_loc] = peaks(signal)
    peak_loc = zeros(size(signal));
    peak_amp = -inf(size(signal));
    for j=1:size(signal,2)
        [pks, locs]=findpeaks(signal(:,j));
        peak_loc(locs, j) = 1;
        peak_amp(locs, j) = pks;
    end
end