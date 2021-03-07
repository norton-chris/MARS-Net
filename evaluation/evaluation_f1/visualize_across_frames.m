function [values_across_frames, mean_across_frames, erroci_across_frames] = visualize_across_frames(dataset_name, fold_name, prediction_num, frame_list, repeat_max, saved_folder, display_names, list_type)

    list_type = ['model_', list_type];
    values_across_frames = [];
    mean_across_frames = zeros(1, length(frame_list));  % i.e) shape can be 6
    erroci_across_frames = zeros(length(frame_list), 2);  % i.e) shape can be 6,2

    frame_counter = 1;
    for frame_num = frame_list
        repeat_combined_list_values = [];
        for repeat_index = 1 : repeat_max
%            disp([frame_num, repeat_index])
            try
                fpr_score = load([saved_folder, '/repeat', num2str(repeat_index), '/', ...
                                display_names{prediction_num} ,'_', dataset_name, '_', fold_name, '/', ...
                                '/Recall_Precision_F_score_frame', num2str(frame_num), '.mat']);
                repeat_combined_list_values = [repeat_combined_list_values, fpr_score.(list_type)];
            catch ME
                disp(['visualize_across_frames skip ', num2str(frame_num), ' ', num2str(repeat_index)])
            end
        end
        [mean_value, errci] = mean_errci(repeat_combined_list_values);
        values_across_frames = [values_across_frames; repeat_combined_list_values];
        mean_across_frames(1, frame_counter) = mean_value;
        erroci_across_frames(frame_counter, :) = errci(:);

        frame_counter = frame_counter + 1;
    end
    % -------------------- visualization ---------------------------
%    saved_folder = ['results/' dataset_name '/'];
%     barplot_helper(erroci_across_frames, mean_across_frames, saved_folder, 'F1', display_names)
%     draw_line_with_error(mean_across_frames, erroci_across_frames, 'between two models', 'F1', saved_folder, frame_list, f1_ylim, display_names);
end
