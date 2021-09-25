function [ObjectiveValueDatas, dispObjectiveValueData_Str] = custom_find_ObjectiveValueDatas(Para)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

ActivatingRate = Para.ActivatingRate;

Pop_Num = Para.Pop_Num;
Joint_num = Para.Joint_num;
Elite_Num = Para.Elite_Num;
Data_Set_Time = Para.Data_Set_Time;


Objective_Fcn = Para.Objective_Fcn;

is_Initial = false;
try
    Para.ObjectiveValueDatas(1);
catch
    is_Initial = true;
end

if is_Initial
    index = 1; %{肩、腰} * 離散時間 * 個体数
else
    index = 1 + Elite_Num; %{肩、腰} * 離散時間 * 個体数
end

ActivatingRate_index = reshape(ActivatingRate(index, :,:), Joint_num, size(Data_Set_Time,1))';

[ObjectiveValueData, dispObjectiveValueData_Str] = Objective_Fcn(ActivatingRate_index);

if is_Initial
    ObjectiveValueDatas = inf(Pop_Num, size(ObjectiveValueData,2)); %{肩、腰} * 離散時間 * 個体数
else
    ObjectiveValueDatas = Para.ObjectiveValueDatas;
end
ObjectiveValueDatas(index,:) = ObjectiveValueData;

parfor index = index + 1:Pop_Num %{肩、腰} * 離散時間 * 個体数
    ActivatingRate_index = reshape(ActivatingRate(index, :,:), Joint_num, size(Data_Set_Time,1))';
    
    [ObjectiveValueData, dispObjectiveValueData_Str] = Objective_Fcn(ActivatingRate_index);
    
    ObjectiveValueDatas(index,:) = ObjectiveValueData;
end

end

