function filename_extra_str = get_filename_extra_info(Para)

filename_extra_str = [
    '_', Para.Mode_String,...
    '_pop_', num2str(Para.Pop_Num),...
    '_gen_', num2str(Para.Gen_Num),...
    ];

filename_extra_str = strrep(filename_extra_str, '.', ',');

end

