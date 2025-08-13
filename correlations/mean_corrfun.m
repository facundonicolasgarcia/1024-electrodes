function [mcorrfun] = mean_corrfun(signal, threshold, dr, r_total, positions)
    thresholded_signal = signal > threshold;
    n_times = size(signal, 1);
    corrfun_arr = NaN(length(r_total), n_times); % ensemble de funciones g(r)

    for t=n_times
        X = positions(thresholded_signal(t, :), :); % posiciones de electrodos activos
        if size(X, 1)>=2 % calculo g(r) sólo si hay al menos 2 electrodos activos
            [corrfun_tmp, ~, ~] = twopointcorr(X(:, 1), X(:, 2), dr);
            corrfun_arr(1:length(corrfun_tmp), t)=corrfun_tmp;
        end
    end

    mcorrfun = squeeze(mean(corrfun_arr, 2, "omitnan"));
end