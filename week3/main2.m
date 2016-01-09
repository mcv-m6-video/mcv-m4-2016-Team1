close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options

color_space = 'YUV'; % 'RGB', 'Gray', 'HSV', 'YUV'

doTask1 = true;         % 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'))

[gt_input_highway,gt_input_fall,gt_input_traffic]=load_gt();
[seq_input_highway, seq_input_fall, seq_input_traffic] = load_seqs(color_space);

global params;
params = load_parameters();
alpha = params.alpha;
show_videos_1 = params.showvideos1;

for i = 1:length(alpha)

    disp(['Computing for: ', num2str(alpha(i))]);
    
    [forEstim_highway, t1_h]= task1(seq_input_highway,alpha(i), show_videos_1, color_space);
    [forEstim_fall,t1_f] = task1(seq_input_fall,alpha(i), show_videos_1, color_space);
    [forEstim_traffic,t1_t]= task1(seq_input_traffic,alpha(i), show_videos_1, color_space);

    
    
    % Evaluation functions for TASK 1 (TASK 2 and TASK 3)
    [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
    [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
    [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));

end

% Best F1 Score and Alpha
[maxF1h,id_h] = max(F1_h(:)); good_alpha_h = alpha(id_h);
[maxF1f,id_f] = max(F1_f(:)); good_alpha_f = alpha(id_f);
[maxF1t,id_t] = max(F1_t(:)); good_alpha_t = alpha(id_t);

disp(['max F1 highway: ', num2str(maxF1h), ' in alpha: ',num2str(good_alpha_h)]);
disp(['max F1 fall: ', num2str(maxF1f), ' in alpha: ',num2str(good_alpha_f)]);
disp(['max F1 traffic: ', num2str(maxF1t), ' in alpha: ',num2str(good_alpha_t)]);

plot_f1_t2(alpha, F1_h, F1_f, F1_t);

disp('--------Plot AUC--------');

% Plot Precision VS Recall
plot_precision_recall_t3([1,Recall_h,0], [1,Recall_f,0], [1,Recall_t,0], [0,Precision_h,1], [0,Precision_f,1], [0,Precision_t,1]);

% Calculate the area under the curve
Area_h = trapz(flip([1,Recall_h,0]), flip([0,Precision_h,1]));
Area_f = trapz(flip([1,Recall_f,0]), flip([0,Precision_f,1]));
Area_t = trapz(flip([1,Recall_t,0]), flip([0,Precision_t,1]));

disp(['Area under the curve for the Highway: ', num2str(Area_h)])
disp(['Area under the curve for the Fall: ', num2str(Area_f)])
disp(['Area under the curve for the Traffic: ', num2str(Area_t)])

