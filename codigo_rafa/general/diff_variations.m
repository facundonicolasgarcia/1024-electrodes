load("activity.mat", "activity");

timestep = 1/500;

%%
d_act = diff(activity)/timestep;
d_act_100 = diff(activity(1:100:end))/timestep/100;

[cc, vv] = hist(d_act, 20);
[cc_100, vv_100] = hist(d_act_100, 20);

figure
plot(vv, cc/sum(cc), 'red');
hold on
plot(vv_100, cc_100/sum(cc_100), 'blue');

%%
n_scales = 100;
var_delta = zeros(n_scales, 1);
for i=(1:1:n_scales)
    s = 2^i;
    delta = diff(activity(1:s:end))/s;
    var_delta(i) = std(delta);
end

plot(1:1:n_scales, log2(var_delta), '--o');