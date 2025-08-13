figure;
X = abs((tau-1.5)/1.5).*abs((alpha-2)/2).*abs((gamma-2)/2);

imagesc(threshold, dt, X');
xlabel("Umbral (SD)");
ylabel("\Deltat");
c = colorbar;
%c.Label.String = '|\tau-3/2|';

xticks(threshold);
yticks(dt);

for i=1:length(threshold)-1
    xline((threshold(i)+threshold(i+1))/2)
end
for i=1:length(dt)-1
    yline((dt(i)+dt(i+1))/2)
end

[~, linear_idx] = min(X(:, 1), [], 'all');
[i, j] = ind2sub(size(X(:, 1)), linear_idx);
tit = sprintf("Mínimo: umbral=%.2f, dt=%d, \\alpha=%.2f, \\tau=%.2f, \\gamma=%.2f\n", threshold(i), dt(i, j), alpha(i, j), tau(i, j), gamma(i, j));
title(tit);