AddPath_MATLABDATA

base_dir = 'C:\Users\11900k\OneDrive - The University of Tokyo\MATLAB_data\pca_input_optimization\box_velocity\';
wildcard = '*.m';

count = 0;
while true
    target_dir = input('type para name / e to exit : ', 's');
    if isequal(target_dir, 'e')
        break
    end
    
    % list = dir([base_dir])
    list = dir([base_dir, target_dir]);
    % list = dir([base_dir, target_dir, wildcard])
    
    target_index_array = 3:size(list, 1)-1;
    target_size = size(target_index_array, 2);
    
    performance_array = NaN(target_size, 1);
    
    for loop_index = 1:target_size
        target_index = target_index_array(loop_index);
        load(list(target_index).name)
        
        performance_array(loop_index) = Para.ObjectiveValueDatas(1,1);
    end
    
    if count
        hold(target_ax, 'on')
        histogram(performance_array)
        hold(target_ax, 'off')
    else
        dockfig(300)
        target_ax = gca;
        histogram(performance_array)
    end
    
    count = count + 1;
        
end
