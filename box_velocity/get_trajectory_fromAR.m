function trajectory = get_trajectory_fromAR(AR, )

x_velocity = velocity(:,1);
y_velocity = velocity(:,2);

x_base_trajectory = zeros(6,1);
x_base_trajectory(2:6,1) = cumsum(x_velocity);
y_base_trajectory = zeros(6,1);
y_base_trajectory(2:6,1) = cumsum(y_velocity);

x_trajectory = interp1(0:5, x_base_trajectory', 0:0.5:5);
y_trajectory = interp1(0:5, y_base_trajectory', 0:0.5:5);

trajectory = [x_trajectory', y_trajectory'];
end