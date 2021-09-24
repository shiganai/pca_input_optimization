function [OutputPara] = custom_optimization(Para)
%OPTIMIZATION この関数の概要をここに記述
%   詳細説明をここに記述
formatOut = 'dd/HH:MM:ss';
dateString = datestr(now,formatOut);
fprintf(strcat("    開始時刻    ", dateString,'\n'))
Para.First_Date_String = dateString;

Pop_Num = Para.Pop_Num;
Elite_Num = 2 - mod(Pop_Num,2);
Child_Num = Pop_Num - Elite_Num;
Max_Annealing_Count_Without_Gain = Para.Max_Annealing_Count_Without_Gain;
Min_Annealing_Gen = Para.Min_Annealing_Gen;
No_Gain_Gen_Lim = Para.No_Gain_Gen_Lim;
Average_Range = Para.Average_Range;
Mean_Std_Threshold = Para.Mean_Std_Threshold;

Mutation_Max_Ratio=Para.Mutation_Max_Ratio; % (%) 1-5%が推奨
Mutation_Max_num=round(Mutation_Max_Ratio*0.01*numel(Para.Data_Set_Time)*2);

Joint_num = Para.Joint_num;
% q0 = Para.q0;
Data_Set_Time = Para.Data_Set_Time;
ActivatingRate_Step_num = Para.ActivatingRate_Step_num;
Base_Transition_Probability = Para.Base_Transition_Probability;
Max_Transition_Probability = Para.Max_Transition_Probability;
Minimum_Transition_Probablity = Para.Minimum_Transition_Probablity;

if Para.Take_Over
    Transition_Probability = Para.Transition_Probability;
    No_Gain_Gen_Num = Para.No_Gain_Gen_Num;
    Annealing_Gen_Num = Para.Annealing_Gen_Num;
    Count_Mean_Memory = Para.Count_Mean_Memory;
    If_Gained_AfterAnnealing = Para.If_Gained_AfterAnnealing;
    If_Gained_AfterReset = Para.If_Gained_AfterReset;
    
    if size(Para.Count_Memory, 1) ~= Para.Gen_Num
        warning("Para.Count_Memory のサイズを変更します")
        Para.Count_Memory = Para.Count_Memory(1:Para.Gen_Num,:);
    end

    ii = Para.Gen_Num;
else
    Transition_Probability = Base_Transition_Probability;
    No_Gain_Gen_Num = 0;
    Annealing_Gen_Num = 0;
    Count_Mean_Memory = zeros([Average_Range, 1]) + NaN;
    If_Gained_AfterAnnealing = 0;
    If_Gained_AfterReset = 0;
    
    Para.Annealing_Gen_Memory = [1, 0];
    Para.Reset_gen_Memory = [1, 0];
    Para.Gained_gen_Memory = 1; %始めを一応カウントしてElitestのindexと合わせる
    Para.Count_Memory = zeros([1,3]);
%     Para.Count_Memory = zeros([Para.Gen_Num, 3]);
    
    ii = 1;
end


fprintf(strcat("第", num2str(ii), "世代計算中\n"))

dockfig(100)
clf('reset')
ax100 = gca;
plot(0,0)
drawnow

dockfig(101)
clf('reset')
ax101= gca;
plot(0,0)
drawnow

tic
[Para.ObjectiveValueDatas, dispObjectiveValueData_Str] = custom_find_ObjectiveValueDatas(Para);

ObjectiveValueDatas_post = Para.ObjectiveValueDatas;
ActivatingRate_post = Para.ActivatingRate;

[ObjectiveValueDatas_post, index_pre] = sortrows(ObjectiveValueDatas_post, 1, 'MissingPlacement', 'last');
ActivatingRate_post = ActivatingRate_post(index_pre, :, :);

count = Para.Count_Memory(1,:);
dispObjectiveValueData(ObjectiveValueDatas_post(1:Elite_Num+1,:), count, dispObjectiveValueData_Str)

if Para.IfScat
    hold(ax100,'on')
    scatter(ax100, zeros(Pop_Num,1) + ii, ObjectiveValueDatas_post(:,1))
    hold(ax100,'off')
    drawnow
else
    scatter(ax100, 1:Pop_Num, ObjectiveValueDatas_post(:,1))
    xlabel(ax100, '順位')
    ylabel(ax100, '評価値(低いほど良い)')
    drawnow
    
    plot_box(ax101)
    ActivatingRate_tmp = reshape(ActivatingRate_post(1, :,:), Joint_num, size(Data_Set_Time,1))';
    velocity_tmp = Para.get_velocity_fromAR(ActivatingRate_tmp);
    trajectory_tmp = get_trajectory_edge(velocity_tmp);
    
    hold(ax101, 'on')
    %         plot(ax101, trajectory_tmp(:,1), trajectory_tmp(:,2), '-o')
    quiver(ax101, trajectory_tmp(1:end-1,1), trajectory_tmp(1:end-1,2), diff(trajectory_tmp(:,1)), diff(trajectory_tmp(:,2)), 'autoscale', 'off')
    hold(ax101, 'off')
    drawnow
end

toc

if Para.Take_Over

    Para.ActivatingRate = ActivatingRate_post;
    Para.ObjectiveValueDatas = ObjectiveValueDatas_post;
else

    Para.init_ActivatingRate = ActivatingRate_post;
    Para.init_ObjectiveValueDatas = ObjectiveValueDatas_post;
    
    Para.ActivatingRate = ActivatingRate_post;
    Para.ObjectiveValueDatas = ObjectiveValueDatas_post;
    
    Para.Midterm_Elitest_ActivatingRate = Para.ActivatingRate(1, :, :);
    Para.Midterm_Elitest_ObjectiveValueDatas = Para.ObjectiveValueDatas(1,:);
end

tic
while true
    
    if Para.ifstop || (ii >= Para.Gen_Num_Limit)
        Para.Gen_Num = ii;
        Para.Count_Memory = Para.Count_Memory(1:Para.Gen_Num,:);
        break
    end
    
    ii = ii + 1;
    Para.Gen_Num = ii;
    
    if mod(ii, 100) == 0
        fprintf(strcat("第", num2str(ii), "世代計算中\n"))
        fprintf(strcat("Transition_Probability = ", num2str(Transition_Probability), "\n"))
    end
    
    ActivatingRate = Para.ActivatingRate;
    ObjectiveValueDatas = Para.ObjectiveValueDatas;
    
    ActivatingRate_post = zeros(size(ActivatingRate));
    
    jj = 1:Elite_Num;
    ActivatingRate_post(jj, :, :) = ActivatingRate(jj, :, :);
    
    notNaN_num = numel(find(~isnan(ObjectiveValueDatas(:,1))));
    
    ActivatingRate_post = mixing_Children(Elite_Num, Child_Num, notNaN_num, Joint_num, Data_Set_Time, ActivatingRate_post, ActivatingRate, Mutation_Max_num, ActivatingRate_Step_num);
    
    Para.ActivatingRate = ActivatingRate_post;
    ObjectiveValueDatas_post = custom_find_ObjectiveValueDatas(Para);
    
    ObjectiveValueDatas_post_NaN_Logical_Array = isnan(ObjectiveValueDatas_post(:,1));
    ObjectiveValueDatas_post(ObjectiveValueDatas_post_NaN_Logical_Array,1) = 100 + 100;
    
    Probability_Array = max(Minimum_Transition_Probablity/100, (Transition_Probability/100).^(ObjectiveValueDatas_post(:,1)-ObjectiveValueDatas(:,1))); %minをとる必要はないかもしれない
    Randum_Array = rand([Pop_Num,1]);
    
    ObjectiveValueDatas_post(ObjectiveValueDatas_post_NaN_Logical_Array,1) = NaN;

    %直観的にはこの方が分かりやすい
    %{
    Transition_Logical_Array = Randum_Array < Probability_Array;
    ExtreamPoint(:,:,:, Transition_Logical_Array) = ExtreamPoint_post(:,:,:, Transition_Logical_Array);
    ExtreamPoint_num(Transition_Logical_Array, :) = ExtreamPoint_num_post(Transition_Logical_Array, :);
    ObjectiveValueDatas(Transition_Logical_Array, :) = ObjectiveValueDatas_post(Transition_Logical_Array, :);
    %}

    %ただしこっちの方がコードの改変が楽。遷移しないものを_postに代入していく
    Non_Transition_Logical_Array = Randum_Array > Probability_Array; %遷移しないものの論理行列
    Non_Transition_Logical_Array(1:Elite_Num, 1) = 1; %elite_numは一致しているはず
    
    ActivatingRate_post(Non_Transition_Logical_Array,:,:) = ActivatingRate(Non_Transition_Logical_Array,:,:);
    ObjectiveValueDatas_post(Non_Transition_Logical_Array, :) = ObjectiveValueDatas(Non_Transition_Logical_Array, :);
    
    
    Transition_ToUpper_Logical_Array = ObjectiveValueDatas_post(:,1) - ObjectiveValueDatas(:,1) > 0;
    Transition_ToVeryUpper_Logical_Array = ObjectiveValueDatas_post(:,1) - ObjectiveValueDatas(:,1) > 10;
    
    count = [Pop_Num - size(find(Non_Transition_Logical_Array), 1) - size(find(Transition_ToUpper_Logical_Array), 1),...
        size(find(Transition_ToUpper_Logical_Array), 1),...
        size(find(Transition_ToVeryUpper_Logical_Array), 1)];
    
    Para.Count_Memory = [Para.Count_Memory; count];
    if ii >= Average_Range + 1
%         Count_Mean_Memory(mod(ii,Average_Range)+1,:) = mean(Para.Count_Memory(ii-(Average_Range-1):ii,1));
        Count_Mean_Memory(mod(ii,Average_Range)+1,:) = mean(Para.Count_Memory(ii-(Average_Range-1):ii,1)-Para.Count_Memory(ii-(Average_Range-1) - 1:ii - 1,2))/Pop_Num;
    end
    
    [ObjectiveValueDatas_post, index_pre] = sortrows(ObjectiveValueDatas_post, 1, 'MissingPlacement', 'last');
    ActivatingRate_post = ActivatingRate_post(index_pre,:,:);
    
    if ObjectiveValueDatas_post(1,1) < ObjectiveValueDatas(1,1)
        warning("目的関数の値が下がりました")
        Para.Midterm_Elitest_ActivatingRate(size(Para.Midterm_Elitest_ActivatingRate,1) + 1,:,:) = ActivatingRate_post(1,:,:);
        Para.Midterm_Elitest_ObjectiveValueDatas(size(Para.Midterm_Elitest_ObjectiveValueDatas,1) + 1, :) = ObjectiveValueDatas_post(1,:);
        
        No_Gain_Gen_Num = 0; %進んだら他の条件によらずNo_Gain_Para.No_Gain_Gen_Numをリセット
        If_Gained_AfterAnnealing = 1;
        If_Gained_AfterReset = 1;
        Para.Gained_gen_Memory = [Para.Gained_gen_Memory; ii];
    elseif ObjectiveValueDatas_post(1,1) > ObjectiveValueDatas(1,1)
        warning("目的関数の値が上がりました")
    end
    
    %Gainした個体の数の平均の標準偏差でNo_Gain_Para.No_Gain_Gen_Numを増やす
    if ii >= 2*Average_Range - 1
        Mean_Std = std(Count_Mean_Memory);
        if mod(ii, 100) == 0
            fprintf(strcat('Mean_Std = ', num2str(Mean_Std), '\n'))
        end
        
        if Transition_Probability > Base_Transition_Probability % Aneealing中
            if Mean_Std > Mean_Std_Threshold
                Annealing_Gen_Num = Annealing_Gen_Num + 1;
        
                if Annealing_Gen_Num >= Min_Annealing_Gen
                    Annealing_Gen_Num = 0;
                    Transition_Probability = Base_Transition_Probability;
                    
                    Para.Annealed_ActivaitingRate = ActivatingRate_post;
                    Para.Annealed_ObjectiveValueDatas = ObjectiveValueDatas_post;
                end
            end
        else % Aneealing中じゃない
            if Mean_Std < Mean_Std_Threshold
                No_Gain_Gen_Num = No_Gain_Gen_Num + 1;
            end
        end
    end
    
    if mod(ii, 100) == 0
        dispObjectiveValueData(ObjectiveValueDatas_post(1:Elite_Num+1,:), count, dispObjectiveValueData_Str)
        toc
        tic
    end
    
    if mod(ii, 25) == 0
        if Para.IfScat
            hold(ax100,'on')
            scatter(ax100, zeros(Pop_Num,1) + ii, ObjectiveValueDatas_post(:,1))
            hold(ax100,'off')
            drawnow
        else
            scatter(ax100, 1:Pop_Num, ObjectiveValueDatas_post(:,1))
            xlabel(ax100, '順位')
            ylabel(ax100, '評価値(低いほど良い)')
            drawnow
            
            plot_box(ax101)
            ActivatingRate_tmp = reshape(ActivatingRate_post(1, :,:), Joint_num, size(Data_Set_Time,1))';
            velocity_tmp = Para.get_velocity_fromAR(ActivatingRate_tmp);
            trajectory_tmp = get_trajectory_edge(velocity_tmp);
            
            hold(ax101, 'on')
            %         plot(ax101, trajectory_tmp(:,1), trajectory_tmp(:,2), '-o')
            quiver(ax101, trajectory_tmp(1:end-1,1), trajectory_tmp(1:end-1,2), diff(trajectory_tmp(:,1)), diff(trajectory_tmp(:,2)), 'autoscale', 'off')
            hold(ax101, 'off')
            drawnow
        end
    end
    
        
    Para.ActivatingRate = ActivatingRate_post;
    Para.ObjectiveValueDatas = ObjectiveValueDatas_post;
    
    Para.Transition_Probability = Transition_Probability;
    Para.No_Gain_Gen_Num = No_Gain_Gen_Num;
    Para.Annealing_Gen_Num = Annealing_Gen_Num;
    Para.Count_Mean_Memory = Count_Mean_Memory;
    Para.If_Gained_AfterAnnealing = If_Gained_AfterAnnealing;
    Para.If_Gained_AfterReset = If_Gained_AfterReset;

    saveMidtermPara(Para,ii)
    
    %焼きなましの開始
    %{
    if No_Gain_Gen_Num >= No_Gain_Gen_Lim
        if Para.IfScat
%             line(ax100, [ii+1, ii+1], [0 330], "Color", "red")
        end
        fprintf("-----------------------------------------焼きなまし開始-----------------------------------------\n")
        
        No_Gain_Gen_Num = 0;
        Transition_Probability = Max_Transition_Probability;
        Para.Annealing_Gen_Memory(end,2) = If_Gained_AfterAnnealing;
        
        Para.ActivatingRate_Before_Annealing = ActivatingRate_post;
        Para.ObjectiveValueDatas_Before_Annealing = ObjectiveValueDatas_post;
        
        Annealing_Gen_Memory = Para.Annealing_Gen_Memory;
        
        if size(Annealing_Gen_Memory, 1) - find(Annealing_Gen_Memory(:,2),1,'last') >= Max_Annealing_Count_Without_Gain
            Para.ifstop = true;
%             if any(Annealing_Gen_Memory(end - (Max_Annealing_Count_Without_Gain - 1):end,2))
%                 Para.ifstop = true;
%             end
        else
            If_Gained_AfterAnnealing = 0;
            Para.Annealing_Gen_Memory = [Para.Annealing_Gen_Memory; ii+1, 0];
        end
    end
    %}
    
end

Para.ActivatingRate = ActivatingRate_post;
Para.ObjectiveValueDatas = ObjectiveValueDatas_post;

Para.Transition_Probability = Transition_Probability;
Para.No_Gain_Gen_Num = No_Gain_Gen_Num;
Para.Annealing_Gen_Num = Annealing_Gen_Num;
Para.Count_Mean_Memory = Count_Mean_Memory;
Para.If_Gained_AfterAnnealing = If_Gained_AfterAnnealing;
Para.If_Gained_AfterReset = If_Gained_AfterReset;

% Para.Count_Memory = Para.Count_Memory(1:Para.Para.No_Gain_Gen_Num,:);

OutputPara = Para;
end





