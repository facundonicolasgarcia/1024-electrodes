clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP2_array4_LFP.mat", "lfp");

frames = size(lfp, 1); % number of time steps
freq = 500; % in Hz
t = (0:frames-1)/freq;

%% Plot timeseries as an image

figure
vmin=-50;
vmax=50;
imagesc(t, 1:64, lfp');
clim([vmin vmax]);
colorbar;

xlabel("Time (s)");
ylabel("Electrode ID");

%% Center the data and perform SVD
interv = true(frames, 1);
Xc = lfp - repmat(mean(lfp, 1), frames, 1);
[U, S, V] = svd(Xc(interv,:), 'econ');

%% Plot principal timeseries
components = 1:3;

for c=components
    pc = U(:, c)*S(c, :)*V;
    figure
    vmin=-50;
    vmax=50;
    imagesc(t(interv), 1:64, pc');
    clim([vmin vmax]);
    colorbar;
    xlabel("Time (s)");
    ylabel("Electrode ID");
    title(sprintf("Component %d", c));
end

%% Plot singular values

figure
loglog(diag(S), '--s');
xlabel('Rank');
ylabel('Singular Value');

%% See how different components behave for a set of electrodes
elec=27:30;
c1=1;
c2=2;
c3=3;
spc1 = U(:, c1)*S(c1, :)*V;
spc2 = U(:, c2)*S(c2, :)*V;
spc3 = U(:, c3)*S(c3, :)*V;

figure
t=(1:frames)/freq;
ax1 = subplot(3,1,1);
plot(ax1, t(interv), spc1(:,elec));

ax2 = subplot(3,1,2);
plot(ax2, t(interv), spc2(:,elec));

ax3 = subplot(3,1,3);
plot(ax3, t(interv), spc3(:,elec));

linkaxes([ax1, ax2, ax3], 'x');
legend(ax1, string(elec));

%% Plot spectrum of different components

[ps, f] = pspectrum(U(:, 1:5), freq);
figure;
colors = lines(5);
set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren')
loglog(f, ps);

legend(string(1:5));

%% Short-time Fourier transform

[s,f,t] = stft(lfp(:,1),freq,Window=hann(256,'symmetric'));

%%
figure
sdb = mag2db(abs(s));
mesh(t,f/1000,sdb);

cc = max(sdb(:))+[-60 0];
ax = gca;
ax.CLim = cc;
view(2)
colorbar

%%
c=1;
pc = U(:, c)*S(c, :)*V;
pc_dev = std(pc, 1, 2);
figure;
plot(t, pc_dev);
yline(0);
%%
signal = pc;
threshold = prctile(signal, 1);

activity=zeros(size(signal));
active = signal>threshold;
activity(active) = signal(active);
activity = sum(activity, 2);

[durations, sizes] = avalanche_hunter(activity);

[D, S] = mean_by_group(durations, sizes);

d_max = max(durations);
d_min = min(durations);
s_max = max(sizes);
s_min = min(sizes);

d_logbins = logspace(log10(d_min), log10(d_max), 50);
s_logbins = logspace(log10(s_min), log10(s_max), 50);

[dur_counts, dur_values] = hist(durations, d_logbins);
[size_counts, size_values] = hist(sizes, s_logbins);

figure;
subplot(131);
loglog(dur_values(dur_counts ~= 0)/freq, dur_counts(dur_counts ~= 0), '--o');
grid on

subplot(132);
loglog(size_values(size_counts ~= 0), size_counts(size_counts ~= 0), '--o');
grid on

subplot(133);
loglog(D/freq, S, '--o');
grid on
