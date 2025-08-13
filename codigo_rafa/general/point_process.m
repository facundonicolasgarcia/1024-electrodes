%% Load data
path = "..\..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');
dataset = '/LFP';
info = h5info(filename, dataset);
num_times = info.Dataspace.Size(1);
data = h5read(filename, dataset);
timestep = 1/500; % in seconds

%% Remove artifacts

data_corrected = filloutliers(data, "previous", "mean", 1);

%% Z-Score signal

% z-score:  1 if signal < mean-2*std dev (for each electrode)
%           0 else

mean_lfp = mean(data, 1, "omitnan");
std_lfp = std(data, 1, 1, "omitnan");

%threshold = mean_lfp-2*std_lfp;
%threshold = prctile(data, 50, 1);
threshold = -100;
events = data < repmat(threshold, num_times, 1);

%% Plot thresholds

figure
plot(threshold);

%% Plot bad electrode signal
y = data(:, threshold<-200);
plot((0:num_times-1)*timestep, y);
legend("Electrode " + string(find(threshold<-200)));
%% Plot signal + point process for an electrode
figure
yline(0, '-');
hold on
y = data(:, 1);
plot((0:length(y)-1).*timestep,y);
event_times = find(events(:,1));
scatter((event_times-1).*timestep, event_times*0, 'o', 'filled');
yline(threshold(1), '--')
%% Save raster and thresholds

save("events.mat", "events", "threshold");

%% 

%% Z-Score signal

% z-score:  1 if signal < mean-2*std dev (for each electrode)
%           0 else

mean_lfp = mean(data, 1, "omitnan");

threshold = mean_lfp;
%threshold = prctile(data, 50, 1);
events = data < repmat(threshold, num_times, 1);

save("events1.mat", "events", "threshold");