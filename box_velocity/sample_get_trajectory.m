
dockfig(101)
plot_box

velocities = [
    -1     1
    -1     0
     0     1
     1     1
     1     0
    ];

trajectory = get_trajectory(velocities);

hold on
plot(trajectory(:,1), trajectory(:,2), '-o')
hold off

x_trajectory = trajectory(:,1);
y_trajectory = trajectory(:,2);

[isInBox, isInBox_array] = get_isInBox(x_trajectory, y_trajectory);

get_norm1(trajectory, isInBox_array)

get_performance_value(trajectory)

dockfig(100)
plot(1:5, velocities, '-o')
legend('x', 'y')
ylim([-1, 1])
ax = gca;
ax.XAxisLocation = 'origin';