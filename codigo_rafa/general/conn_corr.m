%% Load data

signal_file = fullfile("events");
positions_file = fullfile("..", "data", "A_electrode_positions.mat");
load(signal_file, "binned_z_score");
load(positions_file, 'positions_arr');

%% Calculate the spatial fluctuations
spatial_mean = mean(binned_z_score, 2);
u = binned_z_score-spatial_mean;
nbins = 100;
x=positions_arr(:, 1);
y=positions_arr(:, 2);
Rmax = hypot(max(x)-min(x), max(y)-min(y));
dr = Rmax/nbins;

[C, N] = connectedCorrelation(u, x, y, nbins, dr);

%% Compute the correlation distance

r_corr = max(rr(C>0));
r_corr

%% Plot
rr = (0:nbins)*dr;
subplot(1,2,1);
plot(rr, C, '--o');
xlabel("$r (\mu m)$", Interpreter="latex");
ylabel("$C(r)$", Interpreter="latex");
%xline(r_corr, '--', Color="red");
xline(0);
yline(0);

subplot(1,2,2);
plot(rr, N);
xlabel("$r (\mu m)$", Interpreter="latex");
ylabel("número de pares de electrodos", Interpreter="latex");

%% Compute correlations for different window sizes

%map=true(1024, 1);
%map=and(x>1e4, x<1.2e4);
map = filter_arrays(9:14);
u_ = u(:, map);
x_ = x(map);
y_ = y(map);

%nbins = 100;
dr = 400;
Rmax = hypot(max(x_)-min(x_), max(y_)-min(y_));
%dr = Rmax/nbins;
nbins = ceil(Rmax/dr);

[C_, N_] = connectedCorrelation(u_, x_, y_, nbins, dr);
rr_ = (0:nbins)*dr;

%% Compute the correlation distance for reduced window size

r_corr_ = min(rr_(C_<0 & ~isnan(C_)));
r_corr_

%% Plot results for reduced window size

subplot(1,2,1);
plot(rr_, C_, '--o');
xlabel("$r (\mu m)$", Interpreter="latex");
ylabel("$C(r)$", Interpreter="latex");
%xline(r_corr_, '--', Color="red");
xline(0);
yline(0);

subplot(1,2,2);
plot(rr_, N_, '--o');
xlabel("$r (\mu m)$", Interpreter="latex");
ylabel("número de pares de electrodos", Interpreter="latex");
%% Save results

results = [double(rr_'), C_, N_]; % concatenate as columns
results_file = fullfile("..", "results", "connected_correlation", "spatial_correlation_selectedArrays.dat");
save(results_file, 'results', '-ascii');

%% 

function map=filter_arrays(ids)
    map = floor((0:1023)/64) == ids(1)-1;
    for i = ids(2:end)
        map = map | floor((0:1023)/64) == i-1;
    end
end