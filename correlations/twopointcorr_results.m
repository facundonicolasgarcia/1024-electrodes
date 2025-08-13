clc
clear all   
close all

%% Load data
t_bin = 1; %s
signal_filename = strjoin(["binned_" num2str(t_bin, "%.2f") "s_z_score_A_RS_140819_LFP.mat"], "");

load('..\\A_electrode_positions.mat', 'positions_arr')
load(signal_filename, "binned_z_score");

%% Binarize signal
threshold = 0;
f=4;
mask = subsample_mask(f, 0, 0);
active_electrodes = binned_z_score(:,mask)>threshold;
size(active_electrodes)

%% Compute g(r) for every instant

dr=1600;

% Call the twopointcorr on the positions of all electrodes to have the
% maximum number of r bins
X = positions_arr;
[~, r_total, ~] = twopointcorr(X(:, 1), X(:, 2), dr);

% Initialize the corrfun array
ntimes = size(active_electrodes, 1);
nradii = length(r_total);
corrfun = NaN(ntimes, nradii);

for t=1:ntimes
    %fprintf("%d/%d\n", t, ntimes);        
    X = positions_arr(active_electrodes(t,:),:);
    if size(X, 1) >= 3
        [corrfun_temp, r, ~] = twopointcorr(X(:, 1), X(:, 2), dr);
        corrfun(t,1:length(r)) = corrfun_temp;
    else
        %disp("not ok");
    end
end



%% Save results
save(sprintf("results\\g(r)_dt%.2f_thr%.2f_dr%d_f%d.mat", t_bin, threshold, dr, f), "r_total", "corrfun", "t_bin", "dr", "X");