function [isInBox, isInBox_array] = get_isInBox(targetx, targety)
%ISINBOX この関数の概要をここに記述
%   詳細説明をここに記述

isInBox_array = NaN(size(targetx, 1), 3);

isInBox_array(:,1) = (-targetx + targety <= 3) .* (targetx <= 0) .* (targety >= 0) .* (targety <= 1);
isInBox_array(:,2) = (targetx >= -3) .* (targetx <= -2) .* (-targetx + targety >= 3) .* (targetx + targety <= 0);
isInBox_array(:,3) = (targetx + targety >= 0) .* (targetx <= 0) .* (targety >= 2) .* (targety <= 3);

isInBox = any(isInBox_array, 2);
end

