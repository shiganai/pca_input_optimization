function [performance_value, nan_start_index] = get_performance_value(trajectory, evaluating_time)

x_trajectory = trajectory(:,1);
y_trajectory = trajectory(:,2);

[isInBox, isInBox_array] = get_isInBox(x_trajectory, y_trajectory);

if any(~isInBox)
    evaluating_index = find(~isInBox, 1) - 1;
    performance_value = NaN;
else
    evaluating_index = size(x_trajectory, 1);
end
performance_value = get_norm1(trajectory(evaluating_index, :), isInBox_array(evaluating_index,:));

if evaluating_index == size(evaluating_time(:), 1)
    nan_start_index = ceil(evaluating_time(evaluating_index)) + 1;
else
    nan_start_index = ceil(evaluating_time(evaluating_index + 1));
end
end