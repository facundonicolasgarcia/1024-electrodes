function y = binnedArray(x, binWidth)

    nBins = ceil(size(x, 1) / binWidth);
    y = zeros(nBins, size(x, 2));
    
    for i = 1:nBins
        idx_start = (i - 1) * binWidth + 1;
        idx_end = min(i * binWidth, length(x));
        y(i, :) = sum(x(idx_start:idx_end, :), 1);
    end

end