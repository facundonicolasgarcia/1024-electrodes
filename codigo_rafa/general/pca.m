path=
load(path, "lfp");
nsamples = size(lfp, 1);
fs=500;

%% Centrar datos y hacer SVD
Xc = lfp - repmat(mean(lfp, 1), nsamples, 1);

elec=1:64; % electrodos sobre los que hacer la SVD
[U, S, V] = svd(Xc(:,elec), 'econ');

%% Valores singulares

figure;
loglog(diag(S));

%% Proyecciones sobre las componentes principales
c1=1;
c2=2;
c3=3;
pc1 = U(:, c1)*S(c1, :)*V;
pc2 = U(:, c2)*S(c2, :)*V;
pc3 = U(:, c3)*S(c3, :)*V;

elec = [28 29 36 37];
figure
t=(1:nsamples)/fs;
ax1 = subplot(4,1,1);
plot(ax1, t, lfp(:,elec));

ax2 = subplot(4,1,2);
plot(ax2, t, pc1(:,elec));

ax3 = subplot(4,1,3);
plot(ax3, t, pc2(:,elec));

ax4 = subplot(4,1,4);
plot(ax4, t, pc3(:,elec));

linkaxes([ax1, ax2, ax3, ax4], 'x');
legend(ax1, string(elec));

%% Filtrar componente 2
c=[1 3:64];
pc = U(:, c)*S(c, :)*V;
elec = [1 2 3 9 10 11 17 18 19]; % electrodos en un cuadrado 3x3
figure
t=(1:nsamples)/fs;
plot(t, pc(:,elec));
legend(string(elec));

%% Señales graficadas como superficie
% figure
% [X, Y]=meshgrid(t/fps, 1:64);
% surf(X, Y, pc1(1:nsamples, :)');

%% Señales graficadas en forma de imagen
figure
vmin=-50;
vmax=50;
imagesc(t, 1:64, pc1');
clim([vmin vmax]);
colorbar;

%% Espectro de las componentes principales

[ps, f] = pspectrum(U(:, 1:5), fs);
figure;
colors = lines(5); % or any colormap
set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren')
loglog(f, ps);

legend(string(1:5));