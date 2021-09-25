function trajectory = get_trajectory(velocity, target_time)

x_velocity = velocity(:,1);
y_velocity = velocity(:,2);

x_base_trajectory = zeros(8,1);
x_base_trajectory(2:end,1) = cumsum(x_velocity);
y_base_trajectory = zeros(8,1);
y_base_trajectory(2:end,1) = cumsum(y_velocity);

x_trajectory = interp1(0:7, x_base_trajectory', target_time);
y_trajectory = interp1(0:7, y_base_trajectory', target_time);

trajectory = [x_trajectory', y_trajectory'];
end