function target_norm = get_norm1(trajectory, isInBox_array)

x_trajectory = trajectory(:,1);
y_trajectory = trajectory(:,2);

target_norm = NaN(size(x_trajectory));

for index = 1:size(x_trajectory,1)
    
    targetx = x_trajectory(index);
    targety = y_trajectory(index);
    
    if isInBox_array(index, 2)
        base_y = targetx + 3;
        top_y = -targetx;
        
        target_norm(index) = -(targety - base_y)/(top_y - base_y) + 4;
    else
        if isInBox_array(index, 1)
            target_norm(index) = 7 - vecnorm([targetx, targety] - [0, 0], 1);
        elseif isInBox_array(index, 3)
            target_norm(index) = vecnorm([targetx, targety] - [0, 3], 1);
        else
            target_norm(index) = NaN;
        end
    end
end


end

