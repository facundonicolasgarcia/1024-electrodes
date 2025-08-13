close all
clear

%% Funcion definir power law a ajustar

ft = fittype('a+b*x', 'independent', 'x', 'coefficients', {'a', 'b'});

%% 

load("results.mat", "thresholds", "files_durations", "files_sizes");

alpha = zeros(length(thresholds), 3);
tau = zeros(length(thresholds), 3);
gamma = zeros(length(thresholds), 3);
N_ava = zeros(length(thresholds), 3);


%% Compute alphas and taus for every threshold and dt

for i=1:length(thresholds)
    disp("Umbral = "+string(thresholds(i)));
    load(files_durations{i}, "durations");
    load(files_sizes{i}, "sizes");

    for j=1:3
        disp("    dt = "+string(j))
        [dur_v, dur_c, size_v, size_c, D, S] = avalanche_stats(durations{j}, sizes{j});
        
        % calcular exponentes y guardarlos en array
        try
            alpha(i, j) = -fit(log10(dur_v(1:5))', log10(dur_c(1:5)), ft, ...
                'StartPoint', [1e4, -2]).b;
        catch ME
            disp(ME);
            alpha(i, j) = 0;
        end
        try
            tau(i, j) = -fit(log10(size_v(1:20))', log10(size_c(1:20)), ft, ...
                'StartPoint', [1e4, -1.5]).b;
        catch ME
            disp(ME);
            tau(i, j) = 0;
        end
        try
            gamma(i, j) = fit(log10(D(1:5)), log10(S(1:5)), ft, ...
                'StartPoint', [3, 2]).b;
        catch ME
            disp(ME);
            gamma(i, j) = 0;
        end

        
    end
end

%% Plot |alpha-2| vs threshold and dt

figure;
dt=1:3;
imagesc(thresholds, dt, abs(alpha-2)');
xlabel("Umbral (\muV)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\alpha-2|';
colormap('gray');

[~, linear_idx] = min(abs(alpha-2), [], 'all');
[i, j] = ind2sub(size(alpha), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |tau-3/2| vs threshold and dt

figure;
imagesc(thresholds, dt, abs(tau-1.5)');
xlabel("Umbral (\muV)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\tau-3/2|';
colormap('gray');

[~, linear_idx] = min(abs(tau-1.5), [], 'all');
[i, j] = ind2sub(size(tau), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |gamma-2| vs threshold and dt

figure;
imagesc(thresholds, dt, abs(gamma-2)');
xlabel("Umbral (\muV)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\gamma-2|';
colormap('gray');

[~, linear_idx] = min(abs(gamma-2), [], 'all');
[i, j] = ind2sub(size(gamma), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |(alpha-1)-gamma*(tau-1)| vs threshold and dt
% 
% figure;
% imagesc(thresholds, dt, abs((alpha-1)-gamma.*(tau-1))');
% xlabel("Umbral (\muV)");
% ylabel("\Deltat");
% c = colorbar;
% c.Label.String = '|(\alpha-1)-\gamma(\tau-1)|';
% colormap('gray');
% 
% [~, linear_idx] = min(abs((alpha-1)-gamma.*(tau-1)), [], 'all');
% [i, j] = ind2sub(size(gamma), linear_idx);
% tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
% title(tit);
% 
% %% Plot |alpha-2|^2+|tau-3/2|^2 vs threshold and dt
% 
% figure;
% imagesc(thresholds, dt, ((alpha-2).^2+(tau-1.5).^2)');
% xlabel("Umbral (\muV)");
% ylabel("\Deltat");
% c = colorbar;
% c.Label.String = '|\alpha-2|^2+|\tau-3/2|^2';
% colormap('gray');
% 
% [~, linear_idx] = min(((alpha-2).^2+(tau-1.5).^2), [], 'all');
% [i, j] = ind2sub(size(tau), linear_idx);
% tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f", ...
%     thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
% title(tit);
% 
%% Plot |gamma-2|^2+|tau-3/2|^2 vs threshold and dt

figure;
imagesc(thresholds, dt, ((gamma-2).^2+(tau-1.5).^2)');
xlabel("Umbral (\muV)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\alpha-2|^2+|\tau-3/2|^2';
colormap('gray');

[~, linear_idx] = min(((gamma-2).^2+(tau-1.5).^2), [], 'all');
[i, j] = ind2sub(size(tau), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f", ...
    thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);
% 
% %% Plot |alpha-2|^2+|tau-3/2|^2+|gamma-2|^2 vs threshold and dt
% 
% figure;
% imagesc(thresholds, dt, ((alpha-2).^2+(tau-1.5).^2+(gamma-2).^2)');
% xlabel("Umbral (\muV)");
% ylabel("\Deltat");
% c = colorbar;
% c.Label.String = '|\alpha-2|^2+|\tau-3/2|^2+|gamma-2|^2';
% colormap('gray');
% 
% [~, linear_idx] = min(((alpha-2).^2+(tau-1.5).^2)+(gamma-2).^2, [], 'all');
% [i, j] = ind2sub(size(tau), linear_idx);
% tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f", ...
%     thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
% title(tit);

%% Plot with dt colors

delta_t = 1;
figure
A = alpha(:,1:3);
T = tau(:,1:3);
G = gamma(:,1:3);

subplot(1,4,1);
scatter(A, T);
xline(2, '--');
yline(1.5, '--');
xlabel("\alpha");
ylabel("\tau");
legend(string(1:3));

subplot(1,4,2);
scatter(A, G);
xline(2, '--');
yline(2, '--');
xlabel("\alpha");
ylabel("\gamma");

subplot(1,4,3);
scatter(T, G);
xline(1.5, '--');
yline(2, '--');
xlabel("\tau");
ylabel("\gamma");

subplot(1,4,4);
scatter((A-1)./(T-1), G);
hold on
xlabel("(\alpha-1)/(\tau-1)");
ylabel("\gamma");
x=xlim;
y=ylim;
lims = [max([x(1) y(1)]), min([x(2) y(2)])];
plot(lims, lims, 'k--');


%% 3d plots

figure;
scatter3(alpha, tau, gamma);
xlabel("\alpha");
ylabel("\tau");
zlabel("\gamma");
legend(string(dt));

%% Plot with threshold colors

delta_t = 1:3;
figure
A = alpha(:,delta_t);
T = tau(:,delta_t);
%G = (A-1)./(T-1);
G = gamma(:,delta_t);
tt = repmat(thresholds, 1, length(delta_t))';

subplot(1,3,1);
scatter(A(:), T(:), 40, tt(:), 'filled');
colormap(jet);

xline(2, '--');
yline(1.5, '--');
xlabel("\alpha");
ylabel("\tau");
grid on;

subplot(1,3,2);
scatter(A(:), G(:), 40, tt(:), 'filled');
colormap(jet);
xline(2, '--');
yline(2, '--');
xlabel("\alpha");
ylabel("\gamma");
grid on;

subplot(1,3,3);
scatter(T(:), G(:), 40, tt(:), 'filled');
colormap(jet);
xline(1.5, '--');
yline(2, '--');
xlabel("\tau");
ylabel("\gamma");
grid on;
c=colorbar;
c.Label.String = "Umbral (\muV)";

%%
figure
%subplot(1,4,4);
scatter(G(:), (A(:)-1)./(T(:)-1), 40, tt(:), 'filled');
hold on
ylabel("(\alpha-1)/(\tau-1)");
xlabel("\gamma");
c=colorbar;
c.Label.String = "Umbral (\muV)";

%%
%markers = {'o', 's', '^', 'd', 'x', '+'};  % Define marker styles
markers = {'o', 's', '^'};

figure; hold on;
for k = 1:3
    scatter(G(:,k), (A(:,k)-1)./(T(:,k)-1), 40, thresholds, ...
        'Marker', markers{k});
end
ylabel("(\alpha-1)/(\tau-1)");
xlabel("\gamma");
grid on;
colormap(jet);
c=colorbar;
c.Label.String = "Umbral (\muV)";
legend(string(1:3));
hold off;