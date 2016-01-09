close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options

color_space = 'Gray'; % 'RGB', 'Gray', 'HSV', 'YUV'

doTask1 = true;         % 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'))

[gt_input_highway,gt_input_fall,gt_input_traffic]=load_gt();

% Load the parameters. Some of them are specific for each scene
[Alpha_h, T1_h, T2_h, K_h, Rho_h, THFG_h] = load_parameters_t6('highway');
[Alpha_f, T1_f, T2_f, K_f, Rho_f, THFG_f] = load_parameters_t6('fall');
[Alpha_t, T1_t, T2_t, K_t, Rho_t, THFG_t] = load_parameters_t6('traffic');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 6: Stauffer and Grimson implementation

if doTask1
    disp('-------- TASK 1 --------');
    
    for i = 1:length(Alpha_h)
        % Run the S&G implementation for the given parameters
        fprintf('Running S&G implementation for Highway...\n');
        [forEstim_highway] = MultG_fun(Alpha_h(i), T1_h, T2_h, K_h, Rho_h, THFG_h, 'highway', color_space);
        fprintf('Running S&G implementation for Fall...\n');
        [forEstim_fall] = MultG_fun(Alpha_f(i), T1_f, T2_f, K_f, Rho_f, THFG_f, 'fall', color_space);
        fprintf('Running S&G implementation for Traffic...\n');
        [forEstim_traffic] = MultG_fun(Alpha_t(i), T1_t, T2_t, K_t, Rho_t, THFG_t, 'traffic', color_space);

        fprintf('Evaluate S&G implementation...\n');
        [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(forEstim_highway,gt_input_highway);
        [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(forEstim_fall,gt_input_fall);
        [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_input_traffic);
    end
    
    [max_F1h, indx_h] = max(F1_h);
    [max_F1f, indx_f] = max(F1_f);    
    [max_F1t, indx_t] = max(F1_t);
    
    disp(['F1 Score for the Highway: ', num2str(max_F1h), ' with rho = ', num2str(Rho_h), ' and alpha =', num2str(Alpha_h(indx_h))])
    disp(['F1 Score for the Fall: ', num2str(max_F1f), ' with rho = ', num2str(Rho_f), ' and alpha =', num2str(Alpha_f(indx_f))])
    disp(['F1 Score for the Traffic: ', num2str(max_F1t), ' with rho = ', num2str(Rho_t), ' and alpha =', num2str(Alpha_t(indx_t))])
    
    
    plot_precision_recall_t3([1,Recall_h,0], [1,Recall_f,0], [1,Recall_t,0], [0,Precision_h,1], [0,Precision_f,1], [0,Precision_t,1]);
    
    % Calculate the area under the curve
    AUC_h = trapz(flip([1,Recall_h,0]), flip([0,Precision_h,1]));
    AUC_f = trapz(flip([1,Recall_f,0]), flip([0,Precision_f,1]));
    AUC_t = trapz(flip([1,Recall_t,0]), flip([0,Precision_t,1]));
    
    disp(['Area under the curve for the Highway: ', num2str(AUC_h)])
    disp(['Area under the curve for the Fall: ', num2str(AUC_f)])
    disp(['Area under the curve for the Traffic: ', num2str(AUC_t)])      
       
end

% Show estimated scene
% Quick preview
for p = 1:length(forEstim_highway) 
    imshow(forEstim_highway{p});
    pause(0.001)
end

for p = 1:length(forEstim_fall)
    imshow(forEstim_fall{p});
    pause(0.001)
end

for p = 1:length(forEstim_traffic)
    imshow(forEstim_traffic{p});
    pause(0.001)
end


fprintf('\n FINISHED.\n')