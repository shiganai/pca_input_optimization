function trajectory = get_trajectory_edge(velocities)

x_velocity = velocities(:,1);
y_velocity = velocities(:,2);

x_base_trajectory = zeros(6,1);
x_base_trajectory(2:6,1) = cumsum(x_velocity);
y_base_trajectory = zeros(6,1);
y_base_trajectory(2:6,1) = cumsum(y_velocity);

x_trajectory = interp1(0:5, x_base_trajectory', 0:5);
y_trajectory = interp1(0:5, y_base_trajectory', 0:5);

trajectory = [x_trajectory', y_trajectory'];
end