function [objective_value, dispstr] = objectiveFcn(AR, get_trajectory, get_velocity_fromAR, evaluating_time)

velocity = get_velocity_fromAR(AR);

trajectory = get_trajectory(velocity, evaluating_time);

[performance, evaluating_index_tmp] = get_performance_value(trajectory, evaluating_time);

objective_value = [performance, evaluating_index_tmp];
if nargout > 1
    dispstr = '[evaluating_index_tmp]';
end
end