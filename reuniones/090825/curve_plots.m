%% 3d plots

figure;
scatter3(alpha, tau, gamma);
xlabel("\alpha");
ylabel("\tau");
zlabel("\gamma");
legend(string(dt));

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