load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP1_array1_LFP.mat", "lfp");
fps = 500;
nframes = size(lfp,1);
%%
elec = 10;
signal = lfp(:,elec);

figure;
plot((1:nframes)/fps, signal);

%%

filt_signal = bandpass(signal, [1, 30], fps);

%%
figure
plot((1:nframes)/fps, signal);
hold on
plot((1:nframes)/fps, filt_signal);


%% 

[ps, f] = pspectrum(signal, fps);

%%
figure;
loglog(f, ps);
