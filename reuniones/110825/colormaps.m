dt=1:5;

figure;
ax1 = subplot(2,2,1);
ax2 = subplot(2,2,2);
ax3 = subplot(2,2,3);

% Plot |alpha-2| vs threshold and dt
hold(ax1, "on");
imagesc(ax1, thresholds, dt, abs(alpha-2)');
xlabel(ax1, "Umbral (\muV)");
ylabel(ax1, "\Deltat");
c = colorbar(ax1);
c.Label.String = '|\alpha-2|';
colormap(flipud(gray));
clim(ax1, [0 0.50]);

[~, linear_idx] = min(abs(alpha-2), [], 'all');
[i, j] = ind2sub(size(alpha), linear_idx);
tit = sprintf("Mínimo:\n umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(ax1, tit);
scatter(ax1, thresholds(i), dt(j), 'o', 'filled', 'MarkerFaceColor', 'red');
xlim(ax1, [-100, 0]);
ylim(ax1, [.5 5.5]);

% Plot |tau-3/2| vs threshold and dt

hold(ax2, "on");
imagesc(ax2, thresholds, dt, abs(tau-1.5)');
xlabel(ax2,"Umbral (\muV)");
ylabel(ax2, "\Deltat");
c = colorbar(ax2);
c.Label.String = '|\tau-3/2|';
colormap(flipud(gray));
clim(ax2, [0 0.50]);

[~, linear_idx] = min(abs(tau-1.5), [], 'all');
[i, j] = ind2sub(size(tau), linear_idx);
tit = sprintf("Mínimo:\n umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(ax2, tit);

scatter(ax2, thresholds(i), dt(j), 'o', 'filled', 'MarkerFaceColor', 'red');
xlim(ax2, [-100, 0]);
ylim(ax2, [.5 5.5]);

% Plot |gamma-2| vs threshold and dt

hold(ax3, "on");
imagesc(ax3, thresholds, dt, abs(gamma-2)');
xlabel("Umbral (\muV)");
ylabel("\Deltat");
c = colorbar(ax3);
c.Label.String = '|\gamma-2|';
colormap(flipud(gray));
clim(ax3, [0 0.50]);

[~, linear_idx] = min(abs(gamma-2), [], 'all');
[i, j] = ind2sub(size(gamma), linear_idx);
tit = sprintf("Mínimo:\n umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", thresholds(i), dt(j), alpha(i, j), tau(i, j), gamma(i, j));
title(ax3, tit);

scatter(ax3, thresholds(i), dt(j), 'o', 'filled', 'MarkerFaceColor', 'red');
xlim(ax3, [-100, 0]);
ylim(ax3, [.5 5.5]);
