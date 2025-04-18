clear
close all
clc

%%
path = "..\hdf5\A_RS_140819\LFP.h5";
filename = strrep(path, '\', '\\');

dataset = '/LFP';

info = h5info(filename, dataset);

num_times=info.Dataspace.Size(1);
num_electrodes=info.Dataspace.Size(2);

%% load the .h5 file
array = h5read(filename, dataset);

%% compute spatial average and fluctuations
avg=mean(array, 2);
fluctuation=array-repmat(avg, 1, size(array,2));

%% compute activity
threshold = 500;
activity=sum((abs(fluctuation)>threshold).*abs(array), 2);

%% plot
plot(activity(1:end));

%% save activity
filename = sprintf('weighted_activity_%.2f.mat', threshold);
save(filename, "activity");