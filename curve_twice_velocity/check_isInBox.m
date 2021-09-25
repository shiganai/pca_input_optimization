

[targetx, targety] = meshgrid(-4:0.5:1, -1:0.5:6);

targetx = targetx(:);
targety = targety(:);
trajectory = [targetx, targety];

figure(1)
target_ax = gca;

plot_box(target_ax)

[isInBox, isInBox_array] = get_isInBox(targetx, targety);

colordata = isInBox_array .* (1:5);
colordata = sum(colordata, 2);

hold(target_ax, 'on')
scatter(target_ax, targetx, targety, [], colordata, 'filled')
hold(target_ax, 'off')
colormap(target_ax, 'colororder')

figure(2)
target_ax = gca;

plot_box(target_ax)

[isInBox, isInBox_array] = get_isInBox(targetx, targety);
target_norm = get_norm1(trajectory, isInBox_array);

colordata = target_norm;

hold(target_ax, 'on')
% scatter(target_ax, targetx, targety, [], colordata, 'filled')
scatter3(target_ax, targetx, targety, colordata, [], colordata, 'filled')
hold(target_ax, 'off')
colormap(target_ax, 'default')
colorbar





