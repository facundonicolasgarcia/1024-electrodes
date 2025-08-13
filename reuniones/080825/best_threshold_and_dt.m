clear
load("C:\Users\facun\Facundo\neurociencia\tesina\V1_V4_1024_electrode_resting_state_data\data\A_RS_140819\LFP\NSP4_array8_LFP.mat", "lfp");
signal = (lfp-repmat(mean(lfp, 1), size(lfp, 1), 1))./repmat(std(lfp,1,1), size(lfp, 1), 1);

%% Funcion definir power law a ajustar

ft = fittype('a*x^(-b)', 'independent', 'x', 'coefficients', {'a', 'b'});
ft1 = fittype('a*x^b', 'independent', 'x', 'coefficients', {'a', 'b'});

%% Parametros
fs = 500;
t=(1:size(lfp, 1))/fs;

mn = -2;
mx = 0;
threshold = mn:(mx-mn)/10:mx;
dt = 1:4;

%%
alpha = zeros(length(threshold), length(dt));
tau = zeros(length(threshold), length(dt));
gamma = zeros(length(threshold), length(dt));
N_ava = zeros(length(threshold), length(dt));


%% Compute alphas and taus for every threshold and dt

for i=1:length(threshold)
    disp("Umbral = "+string(threshold(i)));
    % calcular activaciones
    [peak_amp, peak_loc] = peaks(-signal);
    idx = -peak_amp<threshold(i); % indexes where the peak passes the threshold
    active = zeros(size(peak_amp));
    active(idx) = 1;
    for j=1:length(dt)
        disp("    dt = "+string(dt(j)))        % calcular distribuciones
        activity = sum(binnedArray(active, dt(j)),2);
        [dur, siz] = avalanche_hunter(activity);
        [dur_v, ~, dur_idx] = unique(dur);
        dur_c = accumarray(dur_idx, 1);
        [size_v, ~, size_idx] = unique(siz);
        size_c = accumarray(size_idx, 1);
        [D, S] = mean_by_group(dur, siz);

        % calcular exponentes y guardarlos en array
        try
            alpha(i, j) = fit(dur_v(dur_v<10)', dur_c(dur_v<10), ft, 'StartPoint', [1e4, 2]).b;
        catch ME
            alpha(i, j) = 0;
        end
        try
            tau(i, j) = fit(size_v(size_v<64)', size_c(size_v<64), ft, 'StartPoint', [1e4, 1.5]).b;
        catch ME
            tau(i, j) = 0;
        end
        try
            gamma(i, j) = fit(D(S<64), S(S<64), ft1, 'StartPoint', [3, 2]).b;
        catch ME
            gamma(i, j) = 0;
        end

        N_ava(i, j) = numel(dur);
    end
end

%% Plot |alpha-2| vs threshold and dt

figure;

imagesc(threshold, dt, abs(alpha-2)');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\alpha-2|';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(abs(alpha-2), [], 'all');
[i, j] = ind2sub(size(alpha), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |tau-3/2| vs threshold and dt

figure;
imagesc(threshold, dt, abs(tau-1.5)');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\tau-3/2|';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(abs(tau-1.5), [], 'all');
[i, j] = ind2sub(size(tau), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |gamma-2| vs threshold and dt



figure;
imagesc(threshold, dt, abs(gamma-2)');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\gamma-2|';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(abs(gamma-2), [], 'all');
[i, j] = ind2sub(size(gamma), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |(alpha-1)-gamma*(tau-1)| vs threshold and dt

figure;
imagesc(threshold, dt, abs((alpha-1)-gamma.*(tau-1))');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|(\alpha-1)-\gamma(\tau-1)|';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(abs((alpha-1)-gamma.*(tau-1)), [], 'all');
[i, j] = ind2sub(size(gamma), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);

%% Plot |alpha-2|^2+|tau-3/2|^2 vs threshold and dt

figure;
imagesc(threshold, dt(1:3), ((alpha(:,1:3)-2).^2+(tau(:,1:3)-1.5).^2)');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '|\alpha-2|^2+|\tau-3/2|^2';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt(1:3))-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(((alpha(:,1:3)-2).^2+(tau(:,1:3)-1.5).^2), [], 'all');
[i, j] = ind2sub(size(tau(:,1:3)), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j));
title(tit);

%% Plot N_ava vs threshold and dt

figure;

imagesc(threshold, dt, N_ava');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
c.Label.String = '# avalanchas';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = max(N_ava, [], 'all');
[i, j] = ind2sub(size(alpha), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f\n", threshold(i), dt(j), alpha(i, j), tau(i, j));
title(tit);

%%

save("resultados8.mat", "alpha", "tau", "gamma", "N_ava", "threshold", "dt");
%%
delta_t = 1;
[~, linear_idx] = min(abs(gamma(:,delta_t)-2), [], 1);
threshold(linear_idx)
disp(tau(linear_idx,delta_t))
disp(alpha(linear_idx,delta_t))
disp(gamma(linear_idx,delta_t))

%%
delta_t = 1;
figure
plot(threshold, tau(:, delta_t)/1.5-1);
hold on
plot(threshold, alpha(:, delta_t)/2-1);
plot(threshold, gamma(:, delta_t)/2-1);
plot(threshold, (alpha(:, delta_t)-1)-gamma(:, delta_t).*(tau(:, delta_t)-1));
yline(0);

legend(["\tau-3/2" "\alpha-2" "\gamma-2"])

%% Plot with dt colors
gamma = (alpha-1)./(tau-1);

delta_t = 1;
figure
A = alpha(:,1:3);
T = tau(:,1:3);
G = gamma(:,1:3);

subplot(1,3,1);
scatter(A, T);
xline(2, '--');
yline(1.5, '--');
xlabel("\alpha");
ylabel("\tau");
legend(string(dt(1:3)));

subplot(1,3,2);
scatter(A, G);
xline(2, '--');
yline(2, '--');
xlabel("\alpha");
ylabel("\gamma");

subplot(1,3,3);
scatter(T, G);
xline(1.5, '--');
yline(2, '--');
xlabel("\tau");
ylabel("\gamma");

%% 3d plots

figure;
scatter3(alpha, tau, gamma);
xlabel("\alpha");
ylabel("\tau");
zlabel("\gamma");
legend(string(dt));

%% Plot with threshold colors

delta_t = dt(1:3);
figure
A = alpha(:,delta_t);
T = tau(:,delta_t);
G = gamma(:,delta_t);
tt = repmat(threshold, 1, length(delta_t))';

subplot(1,3,1);
scatter(A(:), T(:), 40, tt(:), 'filled');
colormap(jet);

% xline(2, '--');
% yline(1.5, '--');
xlabel("\alpha");
ylabel("\tau");

subplot(1,3,2);
scatter(A(:), G(:), 40, tt(:), 'filled');
colormap(jet);
% xline(2, '--');
% yline(2, '--');
xlabel("\alpha");
ylabel("\gamma");

subplot(1,3,3);
scatter(T(:), G(:), 40, tt(:), 'filled');
colormap(jet);
c=colorbar;
c.Label.String = "Umbral (SD)";
% xline(1.5, '--');
% yline(2, '--');
xlabel("\tau");
ylabel("\gamma");