
AddPath_MATLABDATA

dockfig(201)
clf('reset')
ax201 = gca;
plot_box(ax201)

load('5950x_210923124501_input_by_pca_pop_200_gen_10')

AR = Para.ActivatingRate(1,:,:);
AR = reshape(AR, Para.Joint_num, size(Para.Data_Set_Time,1))';

velocity = Para.get_velocity_fromAR(AR);

trajectory = Para.get_trajectory(velocity, Para.evaluating_time);
trajectory_edge = get_trajectory_edge(velocity);

x_trajectory = trajectory_edge(:,1);
y_trajectory = trajectory_edge(:,2);

[isInBox, isInBox_array] = get_isInBox(x_trajectory, y_trajectory);

% get_norm1(trajectory, isInBox_array)

dockfig(200)
plot(1:5, velocity, '-o')
legend('x', 'y')
ylim([-1, 1])
ax200 = gca;
ax200.XAxisLocation = 'origin';

dockfig(201)
hold(ax201, 'on')
quiver(trajectory_edge(1:end-1,1), trajectory_edge(1:end-1,2), diff(trajectory_edge(:,1)), diff(trajectory_edge(:,2)), 'autoscale', 'off')
hold(ax201, 'off')

[performance, evaluating_index_tmp] = get_performance_value(trajectory, Para.evaluating_time)