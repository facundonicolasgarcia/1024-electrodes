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
delta_t = 1;
figure
plot(threshold, tau(:, delta_t)/1.5-1);
hold on
plot(threshold, alpha(:, delta_t)/2-1);
plot(threshold, gamma(:, delta_t)/2-1);
plot(threshold, (alpha(:, delta_t)-1)-gamma(:, delta_t).*(tau(:, delta_t)-1));
yline(0);

legend(["\tau-3/2" "\alpha-2" "\gamma-2"])