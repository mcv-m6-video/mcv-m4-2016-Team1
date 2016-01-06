close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options
doTask1 = false;         % Gaussian function to evaluate background
show_videos_1 = true;  % (From Task1) show back- foreground videos
doTask2 = false;         % (From Task1) TP, TN, FP, FN, F1score vs alpha
doTask3 = false;         % (From Task1) Precision vs recall, AUC

doTask4 = false;        % Adaptive modelling
show_videos_4 = false;  % (From Task4) show back- foreground videos
doTask5 = false;

doTask6 = true;
show_video_6 = true;
doTask7 = false;

compareMethods = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'));

global seq_input_highway
global seq_input_fall
global seq_input_traffic
global gt_input_highway
global gt_input_fall
global gt_input_traffic

% Original Frames
folderHName_input='../highway/input/*.jpg';
fileHSet_input=dir(folderHName_input);

folderFName_input='../fall/input/*.jpg';
fileFSet_input=dir(folderFName_input);

folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);

% Ground Truth
folderHName_gt='../highway/groundtruth/*.png';
fileHSet_gt=dir(folderHName_gt);

folderFName_gt='../fall/groundtruth/*.png';
fileFSet_gt=dir(folderFName_gt);

folderTName_gt='../traffic/groundtruth/*.png';
fileTSet_gt=dir(folderTName_gt);

%Load all entire sequence
%INPUT
for i=1:length(fileHSet_input)
    seq_input_highway{i}=rgb2gray(imread(strcat('../highway/input/',fileHSet_input(i).name)));
end

for i=1:length(fileFSet_input)
    seq_input_fall{i}=rgb2gray(imread(strcat('../fall/input/',fileFSet_input(i).name)));
end

for i=1:length(fileTSet_input)
    seq_input_traffic{i}=rgb2gray(imread(strcat('../traffic/input/',fileTSet_input(i).name)));
end


%GROUNDTRUTH
for i=1:length(fileHSet_input)
    gt_input_highway{i}=imread(strcat('../highway/groundtruth/',fileHSet_gt(i).name));
end

for i=1:length(fileFSet_input)
     gt_input_fall{i}=imread(strcat('../fall/groundtruth/',fileFSet_gt(i).name));
end

for i=1:length(fileTSet_input)
    gt_input_traffic{i}=imread(strcat('../traffic/groundtruth/',fileTSet_gt(i).name));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-recursive Gaussian modeling
if doTask1
    %% TASK 1
    disp('--------TASK 1--------');
    
    alpha = 1.85;
    %alpha = [0.1:0.25:5];

    for i = 1:length(alpha)
    
        [NRGM_forEstim_highway, t1_h]= task1(seq_input_highway,alpha(i), show_videos_1);
        [NRGM_forEstim_fall,t1_f] = task1(seq_input_fall,alpha(i), show_videos_1);
        [NRGM_forEstim_traffic,t1_t]= task1(seq_input_traffic,alpha(i), show_videos_1);

        if (doTask2 || doTask3)
            
            % Evaluation functions for TASK 1 (TASK 2 and TASK 3)
            [NRGM_TP_h(i), NRGM_FP_h(i), NRGM_FN_h(i), NRGM_TN_h(i), NRGM_Precision_h(i), NRGM_Accuracy_h(i), NRGM_Specificity_h(i), NRGM_Recall_h(i), NRGM_F1_h(i)] = task2(NRGM_forEstim_highway,gt_input_highway(t1_h:end));
            [NRGM_TP_f(i), NRGM_FP_f(i), NRGM_FN_f(i), NRGM_TN_f(i), NRGM_Precision_f(i), NRGM_Accuracy_f(i), NRGM_Specificity_f(i), NRGM_Recall_f(i), NRGM_F1_f(i)] = task2(NRGM_forEstim_fall,gt_input_fall(t1_f:end));
            [NRGM_TP_t(i), NRGM_FP_t(i), NRGM_FN_t(i), NRGM_TN_t(i), NRGM_Precision_t(i), NRGM_Accuracy_t(i), NRGM_Specificity_t(i), NRGM_Recall_t(i), NRGM_F1_t(i)] = task2(NRGM_forEstim_traffic,gt_input_traffic(t1_t:end));

        end

    end

    %% TASK 2
    if doTask2
        
        disp('--------TASK 2--------');
        % Plot TP, TN, FP, FN
        plot_metrics_t2(alpha, NRGM_TP_h, NRGM_TP_f, NRGM_TP_t, NRGM_TN_h, NRGM_TN_f, NRGM_TN_t, NRGM_FP_h, NRGM_FP_f, NRGM_FP_t, NRGM_FN_h, NRGM_FN_f, NRGM_FN_t);
                
        % Plot F1 Score
        plot_f1_t2(alpha, NRGM_F1_h, NRGM_F1_f, NRGM_F1_t);
            
    end

    %% TASK 3
    if doTask3
        
        disp('--------TASK 3--------');
        % Plot Precision VS Recall
        plot_precision_recall_t3(NRGM_Recall_h, NRGM_Recall_f, NRGM_Recall_t, NRGM_Precision_h, NRGM_Precision_f, NRGM_Precision_t);
    
        % Calculate the area under the curve
        NRGM_Area_h = trapz(flip(NRGM_Recall_h), NRGM_Precision_h);
        disp(['Area under the curve for the Highway: ', num2str(NRGM_Area_h)])

        NRGM_Area_f = trapz(flip(NRGM_Recall_f), NRGM_Precision_f);
        disp(['Area under the curve for the Fall: ', num2str(NRGM_Area_f)])

        NRGM_Area_t = trapz(flip(NRGM_Recall_t), NRGM_Precision_t);
        disp(['Area under the curve for the Traffic: ', num2str(NRGM_Area_t)])
    end

pause;
    
end % of task1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 4: Recursive Gaussian Modeling
if doTask4

    disp('--------TASK 4--------');
    
%     alpha = [0.1:0.25:5];
%     ro = [0:0.1:1];
    alpha=1.85;
    ro=0;
    
    total = length(alpha) * length(ro); 
    parts = round(total / 10);
    total = total / 100;
    current = 1;
    
    disp('Iterating over alpha and ro...');
    for i = 1:length(alpha)
        for j = 1:length(ro)

            if mod(current, parts) == 0
                disp([num2str(round(current/total)), '%.. '])
            end
            current = current + 1;
            
            [RGM_forEstim_highway,t1_h]= task4(seq_input_highway, alpha(i), ro(j), show_videos_4);
            [RGM_forEstim_fall,t1_f] = task4(seq_input_fall, alpha(i), ro(j), show_videos_4);
            [RGM_forEstim_traffic,t1_t]= task4(seq_input_traffic, alpha(i), ro(j), show_videos_4);

            %% Evaluation functions for TASK 4 (TASK 2 and TASK 3)
            [RGM_TP_h(i,j), RGM_FP_h(i,j), RGM_FN_h(i,j), RGM_TN_h(i,j), RGM_Precision_h(i,j), RGM_Accuracy_h(i,j), RGM_Specificity_h(i,j), RGM_Recall_h(i,j), RGM_F1_h(i,j)] = task2(RGM_forEstim_highway,gt_input_highway(t1_h:end));
            [RGM_TP_f(i,j), RGM_FP_f(i,j), RGM_FN_f(i,j), RGM_TN_f(i,j), RGM_Precision_f(i,j), RGM_Accuracy_f(i,j), RGM_Specificity_f(i,j), RGM_Recall_f(i,j), RGM_F1_f(i,j)] = task2(RGM_forEstim_fall,gt_input_fall(t1_f:end));
            [RGM_TP_t(i,j), RGM_FP_t(i,j), RGM_FN_t(i,j), RGM_TN_t(i,j), RGM_Precision_t(i,j), RGM_Accuracy_t(i,j), RGM_Specificity_t(i,j), RGM_Recall_t(i,j), RGM_F1_t(i,j)] = task2(RGM_forEstim_traffic,gt_input_traffic(t1_t:end));

        end
    end
    
    if doTask5
        %% Plot data for Task 5:

        % Plot TP, TN, FP, FN:
        plot_surfs_t5(ro, alpha, RGM_TP_h, RGM_TP_f, RGM_TP_t, 'True Positives');
        plot_surfs_t5(ro, alpha, RGM_TN_h, RGM_TN_f, RGM_TN_t, 'True Negatives');
        plot_surfs_t5(ro, alpha, RGM_FP_h, RGM_FP_f, RGM_FP_t, 'False Positives');
        plot_surfs_t5(ro, alpha, RGM_FN_h, RGM_FN_f, RGM_FN_t, 'False Negatives');
        close all;

        % Plot F1 Score
        plot_surfs_t5(ro, alpha, RGM_F1_h, RGM_F1_f, RGM_F1_t, 'F 1 score');
        plot_precision_recall_t3(RGM_Recall_h, RGM_Recall_f, RGM_Recall_t, RGM_Precision_h, RGM_Precision_f, RGM_Precision_t)    

        pause;

        [max_AUC_h, best_ro_index_h] = calculate_best_ro(RGM_Recall_h, RGM_Precision_h);
        [max_AUC_f, best_ro_index_f] = calculate_best_ro(RGM_Recall_f, RGM_Precision_f);
        [max_AUC_t, best_ro_index_t] = calculate_best_ro(RGM_Recall_t, RGM_Precision_t);

        disp(['Area under the curve for the Highway: ', num2str(max_AUC_h), ' with ro = ', num2str(ro(best_ro_index_h))])
        disp(['Area under the curve for the Fall: ', num2str(max_AUC_f), ' with ro = ', num2str(ro(best_ro_index_f))])
        disp(['Area under the curve for the Traffic: ', num2str(max_AUC_t), ' with ro = ', num2str(ro(best_ro_index_t))])

    end % doTask5
    
    fprintf('\n\nTask 4 done.\n\n')
end %end task4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 6: Stauffer and Grimson implementation

if doTask6
    disp('-------- TASK 6 --------');
    
% Load the parameters. Some of them are specific for each scene
    [Alpha_h, T1_h, T2_h, K_h, Rho_h, THFG_h] = load_parameters_t6('highway');
    [Alpha_f, T1_f, T2_f, K_f, Rho_f, THFG_f] = load_parameters_t6('fall');
    [Alpha_t, T1_t, T2_t, K_t, Rho_t, THFG_t] = load_parameters_t6('traffic');
   

% Find out the optimal number of Gaussians (K), the optimal Alpha and rho
    for i = 1:length(K_h)
        disp(['for K = ', num2str(K_h(i)),'...\n'])
        for j = 1:length(Alpha_h)
            for k = 1:length(Rho_h)

                % Run the S&G implementation for the given parameters
                fprintf('Running S&G implementation for Highway...\n');
                [SG_forEstim_highway] = MultG_fun(Alpha_h(j), T1_h, T2_h, K_h(i), Rho_h(k), THFG_h, 'highway');
                fprintf('Running S&G implementation for Fall...\n');
                [SG_forEstim_fall] = MultG_fun(Alpha_f(j), T1_f, T2_f, K_f(i), Rho_f(k), THFG_f, 'fall');
                fprintf('Running S&G implementation for Traffic...\n');
                [SG_forEstim_traffic] = MultG_fun(Alpha_t(j), T1_t, T2_t, K_t(i), Rho_t(k), THFG_t, 'traffic');

                    % Show estimated scene
                if show_video_6
                    % Quick preview
                    for p = 1:((T2_h-T1_h)/2)    
                        imshow(SG_forEstim_highway{p});
                        pause(0.001)
                    end
                    pause;
                    for p = 1:((T2_f-T1_f)/2)    
                        imshow(SG_forEstim_fall{p});
                        pause(0.001)
                    end
                    for p = 1:((T2_t-T1_t)/2)    
                        imshow(SG_forEstim_traffic{p});
                        pause(0.001)
                    end
                end
                

            fprintf('Evaluate S&G implementation...\n');
            [SG_TP_h(i,j,k), SG_FP_h(i,j,k), SG_FN_h(i,j,k), SG_TN_h(i,j,k), SG_Precision_h(i,j,k), SG_Accuracy_h(i,j,k), SG_Specificity_h(i,j,k), SG_Recall_h(i,j,k), SG_F1_h(i,j,k)] = task2(SG_forEstim_highway,gt_input_highway);
            [SG_TP_f(i,j,k), SG_FP_f(i,j,k), SG_FN_f(i,j,k), SG_TN_f(i,j,k), SG_Precision_f(i,j,k), SG_Accuracy_f(i,j,k), SG_Specificity_f(i,j,k), SG_Recall_f(i,j,k), SG_F1_f(i,j,k)] = task2(SG_forEstim_fall,gt_input_fall);
            [SG_TP_t(i,j,k), SG_FP_t(i,j,k), SG_FN_t(i,j,k), SG_TN_t(i,j,k), SG_Precision_t(i,j,k), SG_Accuracy_t(i,j,k), SG_Specificity_t(i,j,k), SG_Recall_t(i,j,k), SG_F1_t(i,j,k)] = task2(SG_forEstim_traffic,gt_input_traffic);

            end
        end
    end
    
    
    if doTask7
        
        %% Plot data for Task 7:

        % Plot TP, TN, FP, FN for each K:
        for k = 1:length(K_h) 
            disp(['for K = ', num2str(K_h(k)),'...\n']);
            plot_surfs_t5(Rho_h(1:end-1), Alpha_h, squeeze(SG_TP_h(k,:,1:end-1)), squeeze(SG_TP_f(k,:,1:end-1)), squeeze(SG_TP_t(k,:,1:end-1)), 'True Positives');
            plot_surfs_t5(Rho_h(1:end-1), Alpha_h, squeeze(SG_TN_h(k,:,1:end-1)), squeeze(SG_TN_f(k,:,1:end-1)), squeeze(SG_TN_t(k,:,1:end-1)), 'True Negatives');
            plot_surfs_t5(Rho_h(1:end-1), Alpha_h, squeeze(SG_FP_h(k,:,1:end-1)), squeeze(SG_FP_f(k,:,1:end-1)), squeeze(SG_FP_t(k,:,1:end-1)), 'False Positives');
            plot_surfs_t5(Rho_h(1:end-1), Alpha_h, squeeze(SG_FN_h(k,:,1:end-1)), squeeze(SG_FN_f(k,:,1:end-1)), squeeze(SG_FN_t(k,:,1:end-1)), 'False Negatives');
            close all;

            % Plot F1 Score for each K:
            plot_surfs_t5(Rho_h(1:end-1), Alpha_h, squeeze(SG_F1_h(k,:,1:end-1)), squeeze(SG_F1_f(k,:,1:end-1)), squeeze(SG_F1_t(k,:,1:end-1)), 'F 1 score');
            plot_precision_recall_t3(squeeze(SG_Recall_h(k,:,1:end-1)), squeeze(SG_Recall_f(k,:,1:end-1)), squeeze(SG_Recall_t(k,:,1:end-1)), squeeze(SG_Precision_h(k,:,1:end-1)), squeeze(SG_Precision_f(k,:,1:end-1)), squeeze(SG_Precision_t(k,:,1:end-1)))    
%             
            pause;

            % Best F1
            [max_F1_h(k), best_ro_index_h, best_alpha_index_h] = calculate_best_ro_alpha(squeeze(SG_F1_h(k,:,1:end-1)));
            [max_F1_f(k), best_ro_index_f, best_alpha_index_f] = calculate_best_ro_alpha(squeeze(SG_F1_f(k,:,1:end-1)));
            [max_F1_t(k), best_ro_index_t, best_alpha_index_t] = calculate_best_ro_alpha(squeeze(SG_F1_t(k,:,1:end-1)));

            disp(['Max F1 Score for the Highway: ', num2str(max_F1_h(k)), ' with rho = ', num2str(Rho_h(best_ro_index_h)), ' and alpha =', num2str(Alpha_h(best_alpha_index_h))])
            disp(['Max F1 Score for the Fall: ', num2str(max_F1_f(k)), ' with rho = ', num2str(Rho_f(best_ro_index_f)), ' and alpha =', num2str(Alpha_f(best_alpha_index_f))])
            disp(['Max F1 Score for the Traffic: ', num2str(max_F1_t(k)), ' with rho = ', num2str(Rho_t(best_ro_index_t)), ' and alpha =', num2str(Alpha_t(best_alpha_index_t))])
            
            % Best AUC
            [max_AUC_h(k), best_ro_index_h] = calculate_best_ro(squeeze(SG_Recall_h(k,:,1:end-1)), squeeze(SG_Precision_h(k,:,1:end-1)));
            [max_AUC_f(k), best_ro_index_f] = calculate_best_ro(squeeze(SG_Recall_f(k,:,1:end-1)), squeeze(SG_Precision_f(k,:,1:end-1)));
            [max_AUC_t(k), best_ro_index_t] = calculate_best_ro(squeeze(SG_Recall_t(k,:,1:end-1)), squeeze(SG_Precision_t(k,:,1:end-1)));

            disp(['Area under the curve for the Highway: ', num2str(max_AUC_h(k)), ' with ro = ', num2str(Rho_h(best_ro_index_h))])
            disp(['Area under the curve for the Fall: ', num2str(max_AUC_f(k)), ' with ro = ', num2str(Rho_f(best_ro_index_f))])
            disp(['Area under the curve for the Traffic: ', num2str(max_AUC_t(k)), ' with ro = ', num2str(Rho_t(best_ro_index_t))])
        end
        plot_maxAUC(K_h,max_AUC_h,K_f,max_AUC_f,K_t,max_AUC_t)
        plot_maxF1(K_h,max_F1_h,K_f,max_F1_f,K_t,max_F1_t)
    end
end   
fprintf('\nTask 6 done.\n')

   
    
    
 % task 6


fprintf('\n FINISHED.\n')