function [uniqueX, meanY] = mean_by_group(X, Y)
    % Ensure X and Y are column vectors
    X = X(:);
    Y = Y(:);

    % Find unique values and group indices
    [uniqueX, ~, groupIdx] = unique(X);

    % Preallocate meanY
    meanY = accumarray(groupIdx, Y, [], @mean);
end
