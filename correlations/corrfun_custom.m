%% Parameters of the input file
thresholds = 0:0.2:2;
dr = 1600; %micras
t_bin = 0.01; %s
sesion = "A_RS_140819_LFP";

%% Load necessary variables
load('..\\A_electrode_positions.mat', 'positions_arr')
input_filename = strjoin(["binned_" num2str(t_bin, "%.2f") "s_z_score_" sesion ".mat"], "");
load(input_filename, "binned_z_score");

%% Calculate corrfuns for the different thresholds
X = positions_arr;
[~, r_total, ~] = twopointcorr(X(:, 1), X(:, 2), dr);

mcorrfuns=NaN(length(thresholds), length(r_total));
for i=1:length(thresholds)
    [mcorrfun] = mean_corrfun(binned_z_score, thresholds(i), dr, r_total, positions_arr);
    mcorrfuns(i,:) = mcorrfun;
end

%% Save the results with the corresponding input variables
filename = strjoin(["g(r)_dt" num2str(t_bin, "%.2f") "_dr" num2str(dr, "%d") "_" sesion ".mat"], "");
save(filename, "thresholds", "r_total", "mcorrfuns", "t_bin", "dr", "sesion");