function [alpha, tau, gamma] = calc_exp(dur, siz)
    [dur_v, ~, dur_idx] = unique(dur);
    dur_c = accumarray(dur_idx, 1);
    [size_v, ~, size_idx] = unique(siz);
    size_c = accumarray(size_idx, 1);
    [D, S] = mean_by_group(dur, siz);


    ft = fittype('a*x^(-b)', 'independent', 'x', 'coefficients', {'a', 'b'});
    ft1 = fittype('a*x^b', 'independent', 'x', 'coefficients', {'a', 'b'});
    try
        alpha = fit(dur_v(dur_v>1 & dur_v<10)', dur_c(dur_v>1 & dur_v<10), ft, 'StartPoint', [1e4, 2]).b;
    catch
        alpha = 0;
    end
    try
        tau = fit(size_v(size_v>4 & size_v<30)', size_c(size_v>4 & size_v<30), ft, 'StartPoint', [1e4, 1.5]).b;
    catch
        tau = 0;
    end
    try
        gamma = fit(D(S<64), S(S<64), ft1, 'StartPoint', [3, 2]).b;
    catch
        gamma = 0;
    end
end