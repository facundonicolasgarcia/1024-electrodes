%% Load data
clear all 
t_bin = 1; %s

signal_file = fullfile("events.mat");
positions_file = fullfile("A_electrode_positions.mat");
load(signal_file, "events");
load(positions_file, 'positions_arr');

%%
r0 = 400;
% Call the twopointcorr on the positions of all electrodes to have the
X = positions_arr;
[~, r_total, corrfun0] = twopointcorr2d(X(:, 1), X(:, 2), r0);

%figure(2);
%loglog(r_total(corrfun0 ~= 0), corrfun0(corrfun0 ~= 0), '--o');
%hold on

subsample_ratios = [1 .8 .6 .4];
for subsample_ratio = subsample_ratios
    mask = randperm(1024, ceil(1024*subsample_ratio));
    %mask = true(1024, 1);
    active_electrodes = events(1:1000,mask);
    
    % Plot electrode positions
    %figure(1);
    %Y = positions_arr(mask, :);
    %scatter(Y(:, 1), Y(:, 2));
    %hold on
    
    % Compute g(r) for every instant
    
    % Initialize the corrfun array
    ntimes = size(active_electrodes, 1);
    nradii = length(r_total);
    corrfun = NaN(ntimes, nradii);
    rw = NaN(ntimes, nradii);
    
    for t=1:ntimes
        fprintf("%d/%d\n", t, ntimes);        
        X = positions_arr(active_electrodes(t,:),:);
        if size(X, 1) >= 3
            %[corrfun_temp, r, ~] = twopointcorr_logscale(X(:, 1), X(:, 2), r0, logstep, 1024, false);
            [corrfun_temp, r, ~] = twopointcorr2d(X(:, 1), X(:, 2), r0);
    
            corrfun(t,1:length(r)) = corrfun_temp;
        else
            %disp("not ok");
        end
    end
    
    % Mean corrfun
    
    mean_corrfun = mean(corrfun, 1, "omitnan");
    
    % Plot corrfun
    figure(2);
    semilogx(r_total(mean_corrfun ~= 0), mean_corrfun(mean_corrfun ~= 0)-1, '--o');
    hold on
end

figure(2);
legend(string(100*subsample_ratios)+"%")
%%
figure(2);
yline(0);
%% Save results

results = [double(r_total'), mean_corrfun']; % concatenate as columns
results_file = fullfile("..", "results", "radial_distribution", sprintf("g(r)_%d.dat", subsample_ratio*100));
save(results_file, 'results', '-ascii');

results_loglog = [double(log10(r_total(mean_corrfun~=0))'), log10(mean_corrfun(mean_corrfun~=0)')]; % concatenate as columns
results_file = fullfile("..", "results", "radial_distribution", sprintf("g(r)_%d_loglog.dat", subsample_ratio*100));
save(results_file, 'results_loglog', '-ascii');

%% Save electrode positions

positions_file = fullfile("..", "results", "radial_distribution", sprintf("positions_%d.dat", subsample_ratio*100));
Y = double(Y);
save(positions_file, 'Y', '-ascii');






