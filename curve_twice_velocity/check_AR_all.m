AddPath_MATLABDATA

[base_dir, username] = find_UserData;
base_dir = [base_dir, '\pca_input_optimization\curve_twice\'];

dockfig(200)
ax200 = gca;

dockfig(201)
ax201 = gca;

while true
    try
        isCalcAll = input('is calc all? y/n [n]', 's');
        if isempty(isCalcAll)
            isCalcAll = 'n';
        end
        
        if isequal(isCalcAll, 'y')
            isCalcAll = true;
        elseif isequal(isCalcAll, 'n')
            isCalcAll = false;
        else
            error('type y/n')
        end
        break
    catch
    end
end

target_dir = uigetdir(base_dir);

list = dir([target_dir]);

target_index_array = 3:size(list, 1)-1;
target_size = size(target_index_array, 2);

performance_array = NaN(target_size, 1);

count = 0;
for loop_index = 1:target_size
    
    target_index = target_index_array(loop_index);
    load(list(target_index).name)
    AR = Para.ActivatingRate(1,:,:);
    AR = reshape(AR, Para.input_dim2_num, Para.input_dim3_num)';
    
    velocity = Para.get_velocity_fromAR(AR);
    
    trajectory = Para.get_trajectory(velocity, Para.evaluating_time);
    trajectory_edge = get_trajectory_edge(velocity);
    
    x_trajectory = trajectory_edge(:,1);
    y_trajectory = trajectory_edge(:,2);
    
    [isInBox, isInBox_array] = get_isInBox(x_trajectory, y_trajectory);
    
    plot(ax200, Para.Data_Set_Time, velocity, '-o')
    legend(ax200, 'x', 'y')
    ylim(ax200, [-1, 1])
    ax200.XAxisLocation = 'origin';
    
    if isCalcAll && count > 0
    else
        plot_box(ax201)
    end
    
    hold(ax201, 'on')
    quiver(ax201, trajectory_edge(1:end-1,1), trajectory_edge(1:end-1,2), diff(trajectory_edge(:,1)), diff(trajectory_edge(:,2)), 'autoscale', 'off')
    hold(ax201, 'off')
    
    [performance, evaluating_index_tmp] = get_performance_value(trajectory, Para.evaluating_time);
    
    if isCalcAll
    else
        target_dir = input('type nothing / e to exit : ', 's');
        if isequal(target_dir, 'e')
            break
        end
    end
    count = count + 1;
end




















































