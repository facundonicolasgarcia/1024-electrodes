clc
clear all   
close all

%% Load data
t_bin = 1; %s
signal_filename = strjoin(["binned_" num2str(t_bin, "%.2f") "s_z_score_A_RS_140819_LFP.mat"], "");

load('..\\A_electrode_positions.mat', 'positions_arr')
load(signal_filename, "binned_z_score");

%% Binarize signal
ntimes = size(binned_z_score, 1);
threshold = 0;



%% Compute g(r) for every instant

dr=1;
subsamples = [100 500 1000];

X = positions_arr;
[~, r_total, ~] = twopointcorr_logscale(X(:, 1), X(:, 2), dr);

% Initialize the corrfun array
nradii = length(r_total);
corrfun = NaN(ntimes, nradii, length(subsamples));

%% Get active electrodes

% Create subsample mask
for i=1:length(subsamples)
    disp(i);
    n=subsamples(i);
    idx = randperm(1024, n); % Random, non-repeating indices
    mask = false(ntimes, 1024);   % Initialize logical mask
    mask(:, idx) = true;     % Set selected positions to true
    active_electrodes = binned_z_score.*mask>threshold;
    
    for t=1:ntimes
        X = positions_arr(active_electrodes(t,:),:);
        if size(X, 1) >= 3
            [corrfun_temp, r, ~] = twopointcorr_logscale(X(:, 1), X(:, 2), dr);
            corrfun(t,1:length(r), i) = corrfun_temp;
        else
            %disp("not ok");
        end
    end
end
disp(size(corrfun))

%% Plot
mcorrfun = mean(corrfun, 1, "omitnan");
figure(1)
for i=1:length(subsamples)
    loglog(r_total, mcorrfun(1,:,i), "--o");
    hold on
end
legend(["100" "500" "1000"]);

xlabel("Distancia ($\mu m$)", Interpreter="latex");
ylabel("$g(r)$", Interpreter="latex");
