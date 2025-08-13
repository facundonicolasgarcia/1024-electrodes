%% Load data
clear binned_z_score 
t_bin = 1; %s
signal_filename = strjoin(["binned_" num2str(t_bin, "%.2f") "s_z_score_A_RS_140819_LFP.mat"], "");

load('..\\A_electrode_positions.mat', 'positions_arr')
load(signal_filename, "binned_z_score");
size(binned_z_score)

%% Take the mean signal of sets of n electrodes and its temporal variance
% Here, n electrodes with consecutive ids are grouped together
clear nn ii ss

id = randperm(1024)-1; % ids of electrodes
exponents = 0:10;
ndata = 2^11-1;
nn = NaN(ndata, 1); % number of electrodes by set
ii = NaN(ndata, 1); % for a given n: ii=mod(id, n)
ss = NaN(ndata, 1); % here the standard deviations are stored
ee = NaN(ndata, 1);
c = 1;
for e=exponents
    disp(e);
    n = 2^e;
    jj = 0:2^(10-e)-1; % group ids
    for i=jj
        nn(c) = n;
        ii(c) = i;
        ee(c) = e;
        mu = mean(binned_z_score(:, floor(id/n)==i), 2);
        ss(c) = std(mu);
        c=c+1;
    end
end

%% Another way of doing it
% Here, n electrodes with equally spaced ids are grouped together

clear nn ii ss

exponents = 0:10;
ndata = 2^11-1;
nn = NaN(ndata, 1); % number of electrodes by set
ii = NaN(ndata, 1); % for a given n: ii=mod(id, n)
ss = NaN(ndata, 1); % here the standard deviations are stored
ee = NaN(ndata, 1);
c = 1;
for e=exponents
    disp(e);
    n = 2^e;
    id = 0:1023; % ids of electrodes
    jj = 0:2^(10-e)-1; % group number
    for i=jj
        nn(c) = n;
        ii(c) = i;
        ee(c) = e;
        mu = mean(binned_z_score(:, mod(id, 2^(10-e))==i), 2);
        ss(c) = std(mu);
        c=c+1;
    end
end

%% Plot results
figure
boxplot(ss, ee);

%%
figure
numexp = length(exponents);
smean = NaN(numexp);
sstd = NaN(numexp);
for i=1:numexp
    e=exponents(i);
    smean(i) = mean(ss(ee==e));
    sstd(i) = std(ss(ee==e));
end

errorbar(exponents, smean, sstd, '--o');

%% Plot histogram for each n
figure
for e=0:5
    disp(e);
    [cc, bb]=hist(log10(ss(ee==e)),20);
    plot(bb,cc,'-o');
    hold on
end

legend("e="+string(0:10))
%% Plot electrodes

load('..\\A_electrode_positions.mat', 'positions_arr')

n = 256;
nsets = 1024/n;
%color=floor(id/n); % consecutive electrode ids
color=mod(id, nsets); % equally spaced electrode ids
scatter(positions_arr(:,1), positions_arr(:,2), 100, ...
    color, 'filled', 'MarkerEdgeColor', 'k');

map = colormap('jet'); % 'turbo', 'jet', 'parula', etc.
% map = map(randperm(size(map,1)), :); % shuffle it
%map=jet(64);
%map = map(randperm(size(map,1)), :);
colormap(map);

%% Save data

data = [ee, ss];        % concatenate as columns
save('variance_vs_coarse1.dat', 'data', '-ascii');