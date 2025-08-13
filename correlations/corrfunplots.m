clear

%% Calculate mean g(r) and plot alongside with an example configuration
t_bin=1;
threshold=0;
dr=400;
f=4;
load('..\\A_electrode_positions.mat', 'positions_arr');
load(sprintf("results\\g(r)_dt<              '00<<<<<<<<2f_thr%.2f_dr%d_logspace.mat", t_bin, threshold, dr));

mcorrfun = mean(corrfun, 1, "omitnan");

x=log10(r_total);
y=log10(mcorrfun);
x=x((~isnan(y)) & (~isinf(y)));
y=y((~isnan(y)) & (~isinf(y)));

p=polyfit(x, y, 1);
figure(1)
%
subplot(2,1,1)

plot(x, y, "--o");
hold on
plot(x, polyval(p,x), "red");
axis padded
xlabel("$log_{10}(r)\; [\mu m]$", "Interpreter", "latex");
ylabel("$log_{10}(g)$", "Interpreter", "latex");
legend(["g(r)" sprintf("$\\eta=%.2f$", -p(1))], "Interpreter", "latex");

%
subplot(2,1,2)
scatter(X(:,1), X(:,2), '.');
corners = corners_of_arrays(positions_arr);
hold on
for arr=1:16
    plot(corners(arr,:,1), corners(arr,:,2), 'r'); % aca ploteo los bordes de los arrays
end
axis padded equal
xlabel("$x\; [\mu m]$", "Interpreter", "latex");
ylabel("$y\; [\mu m]$", "Interpreter", "latex");
hold off

%% Funciones
function corners = corners_of_arrays(positions)
    corners = zeros(16, 4, 2); % 16 arrays, 4 corners, 2 coordinates
    within_arr_corner_idxs = [1 8 64 57 1];
    for arr=1:16
        for i=1:5
            corner_idx=within_arr_corner_idxs(i);
            corners(arr, i, :) = positions((arr-1)*64+corner_idx,:);
        end
    end
end