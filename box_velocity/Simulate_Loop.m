
clear all

AddPath_MATLABDATA
AddPath_3Links

formatOut = 'yymmddHHMMss';
dateString = datestr(now,formatOut);
loop_start_time_str = dateString;

Saving_Dir_Name = [
    'pca_input_optimization\box_velocity\', loop_start_time_str
    ];

[MATLAB_data_dir, username] = find_UserData;

Saving_Name_tmp = [...
    MATLAB_data_dir, ...
    '\', Saving_Dir_Name, ...
    '\', username];

Saving_Folder_check_index = find(Saving_Name_tmp == '\', 1, 'last');
Saving_Folder_check = Saving_Name_tmp(1:Saving_Folder_check_index - 1);

if ~exist(Saving_Folder_check,'dir')
   mkdir(Saving_Folder_check)
end

loop_limit = 100;

for loop_index = 1:loop_limit
    
    rng shuffle
    
    Para.Take_Over = false;
    
    check_saving_dir(Saving_Dir_Name)
    
    if Para.Take_Over
        Take_Over_Str = "5950x_210905111643_NoVibe-FyWrist-Component_spinNum_-1,342_gen_17565";
        load(Take_Over_Str)
        
        Para.Take_Over = true;
        Para.Take_Over_Str = [Para.Take_Over_Str; Take_Over_Str];
    else
        % CONDITIONS
        warning('off', 'MATLAB:structOnObject')
        
        warning('on', 'MATLAB:structOnObject')
        
        Para.Take_Over_Str = "";
        % ABOUT POP AND GENERATIONS
        Para.Pop_Num = 2e3;
        Para.Gen_Num_Limit = 1e2;
        Para.Max_Annealing_Count_Without_Gain = 5;
        Para.Min_Annealing_Gen = 5;
        Para.No_Gain_Gen_Lim = 10;
        Para.Average_Range = 100;
        Para.Mean_Std_Threshold = 2e-4;
        
        % ABOUT DATA
        Para.Data_Set_Time = (1:5)';
        Para.Joint_num = 2;
        Para.ActivatingRate_Step_num = 10;
        Para.Mutation_Max_Ratio = 5;
        Para.ifResetAll = false;
        Para.get_filename_extra_info = @get_filename_extra_info;
        
        Para.Elite_Num = 2 - mod(Para.Pop_Num,2);
        
        % ABOUT Annealing
        Para.Base_Transition_Probability = 100;
        Para.Max_Transition_Probability = 100;
        
        Para.Minimum_Transition_Probablity = 0;
        
        % NoVibe-FyWrist-Component
        %{
    Para.Mode_String = 'input_by_time';
    Para.get_velocity_fromAR = @(AR) reshape(AR, size(Para.Data_Set_Time, 1), Para.Joint_num);
    Para.evaluating_time = 0:1e-2:5;
    Para.get_trajectory = @(velocity, evaluating_time) get_trajectory(velocity, evaluating_time);
    Para.Objective_Fcn = @(AR) objectiveFcn(AR, Para.get_trajectory, Para.get_velocity_fromAR, Para.evaluating_time);
        %}
        
        % NoVibe-FyWrist-Component
        %{-
        Para.Mode_String = 'input_by_pca';
        Para.get_velocity_fromAR = @(AR) get_velocity_fromPCA_001(AR, size(Para.Data_Set_Time, 1), Para.Joint_num);
        Para.evaluating_time = 0:1e-2:5;
        Para.get_trajectory = @(velocity, evaluating_time) get_trajectory(velocity, evaluating_time);
        Para.Objective_Fcn = @(AR) objectiveFcn(AR, Para.get_trajectory, Para.get_velocity_fromAR, Para.evaluating_time);
        %}
        
        % ABOUT INITIALIZATION
        Para = generate_init_ActivatingRate(Para);
        %     Para = load_and_fit_init_Mdatas(Para, 'Para_1018140016_pop_2400_gen_15794', 2400);
        
        Para.optimizing_func = @custom_optimization;
    end
    
    Para.Saving_Dir_Name = Saving_Dir_Name;
    
    Para.IfScat = 0;
    
    Para.ifstop = false;
    
    Para = Para.optimizing_func(Para);
    
    savePara(Para)
    
    
end




































