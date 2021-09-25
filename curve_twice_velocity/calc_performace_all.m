
clear all

step_num = 3;
Para.velocity_variety = linspace(-1,1,step_num);
vv = Para.velocity_variety;

[x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7] = ...
    ndgrid(vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv);


Para.velocity_matrix = ...
    [x1(:), x2(:), x3(:), x4(:), x5(:), x6(:), x7(:), y1(:), y2(:), y3(:), y4(:), y5(:), y6(:), y7(:)];

sz = size(Para.velocity_matrix, 1);
performance = NaN(sz, 1);
evaluating_index = NaN(size(sz,1));

ppm = ParforProgressbar(sz, 'showWorkerProgress',true);
velocity_matrix = Para.velocity_matrix;
velocity_matrix_NaN = velocity_matrix;

Para.evaluating_time = 0:1e-2:7;

parfor vm_index = 1:size(velocity_matrix, 1)
    velocities = reshape(velocity_matrix(vm_index, :), 7, 2);
    
    trajectory = get_trajectory(velocities, Para.evaluating_time);
    
    x_trajectory = trajectory(:,1);
    y_trajectory = trajectory(:,2);
    
    [performance(vm_index), nan_start_index] = get_performance_value(trajectory, Para.evaluating_time);
    
    velocity_matrix_NaN_tmp = velocity_matrix_NaN(vm_index, :)
    velocity_matrix_NaN_tmp = reshape(velocity_matrix_NaN_tmp, 7, 2);
    velocity_matrix_NaN_tmp(nan_start_index:end, :) = NaN;
    velocity_matrix_NaN_tmp = reshape(velocity_matrix_NaN_tmp, 1, 7 * 2);
    velocity_matrix_NaN(vm_index, :) = velocity_matrix_NaN_tmp;
    
    evaluating_index(vm_index) = nan_start_index;
    
    ppm.increment();
end

delete(ppm)
Para.performance = performance;
Para.velocity_matrix_NaN = velocity_matrix_NaN;
Para.evaluating_index = evaluating_index;
% performance

edges = 0:10;

histogram(Para.performance, edges)
ax = gca;
ax.YAxis.Scale = 'log';

save('Para', 'Para')