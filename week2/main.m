close all;
clear all;
clc;

%% Select execution options
doTask1 = true;         % Gaussian function to evaluate background
show_videos_1 = false;  % (From Task1) show back- foreground videos
doTask2 = false;         % (From Task1) TP, TN, FP, FN, F1score vs alpha
doTask3 = true;         % (From Task1) Precision vs recall, AUC

doTask4 = false;        % Adaptive modelling
show_videos_4 = false;  % (From Task4) show back- foreground videos

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
%     seq_input_highway{i}=imread(strcat('../highway/input/',fileHSet_input(i).name));    
end

for i=1:length(fileFSet_input)
    seq_input_fall{i}=rgb2gray(imread(strcat('../fall/input/',fileFSet_input(i).name)));
end

for i=1:length(fileTSet_input)
    seq_input_traffic{i}=rgb2gray(imread(strcat('../traffic/input/',fileTSet_input(i).name)));
%     seq_input_traffic{i}=imread(strcat('../traffic/input/',fileTSet_input(i).name));    
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
%% Non-recursive Gaussian modeling
if doTask1

    %% TASK 1
    disp('--------TASK 1--------');
    
    %alpha = [0.1:0.1:5];
    alpha = [0:1:5];

    for i = 1:length(alpha)
    
        [forEstim_highway, t1_h,t2_h]= task1(seq_input_highway,alpha(i), show_videos_1);
        [forEstim_fall,t1_f,t2_f] = task1(seq_input_fall,alpha(i), show_videos_1);
        [forEstim_traffic,t1_t,t2_t]= task1(seq_input_traffic,alpha(i), show_videos_1);

        if (doTask2 || doTask3)
        %% Evaluation functions for TASK 1 (TASK 2 and TASK 3)

        [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
        [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
        [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));
        
        end

    end

    if doTask2
        
        %% Plot TP, TN, FP, FN
        disp('--------TASK 2--------');
        plot_metrics_t2(alpha, TP_h, TP_f, TP_t, TN_h, TN_f, TN_t, FP_h, FP_f, FP_t, FN_h, FN_f, FN_t);
            
    end

    
    % Plot F1 Score
    fprintf('\nPlotting F1 Scores...')
    figure(2)
    plot(alpha,F1_h,alpha,F1_f,alpha,F1_t)
    xlabel('Alpha')
    ylabel('F1')
    legend('F1 Highway','F1 Fall','F1 Traffic')
    title('F1 Score')


    % Plot Precision VS Recall
    fprintf('\nPlotting Precision vs Recall...')
    
    figure(3)
    subplot(1,3,1)
    plot(Recall_h,Precision_h,'b')
    xlim([0 1])
    title('Highway: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,2)
    plot(Recall_f,Precision_f,'r')
    xlim([0 1])
    title('Fall: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,3)
    plot(Recall_t,Precision_t,'g')
    xlim([0 1])
    title('Traffic: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')
    
    
    
    
    

    Area_h = trapz(flip(Recall_h), Precision_h);
    disp(['Area under the curve for the Highway: ', num2str(Area_h)])

    Area_f = trapz(flip(Recall_f), Precision_f);
    disp(['Area under the curve for the Fall: ', num2str(Area_f)])
    
    Area_t = trapz(flip(Recall_t), Precision_t);
    disp(['Area under the curve for the Traffic: ', num2str(Area_t)])
    
end % end if task1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 4: Adaptive modeling
if doTask4
    
    disp('--------TASK 4--------');
    
    alpha = [0.1:0.1:5];
    ro = [0:0.01:0.1];
    
    for i = 1:length(alpha)
        for j = 1:length(ro)

            [forEstim_highway,t1_h,t2_h]= task4(seq_input_highway, alpha(i), ro(j), show_videos_4);
            [forEstim_fall,t1_f,t2_f] = task4(seq_input_fall, alpha(i), ro(j), show_videos_4);
            [forEstim_traffic,t1_t,t2_t]= task4(seq_input_traffic, alpha(i), ro(j), show_videos_4);

            %% Evaluation functions for TASK 4 (TASK 2 and TASK 3)

            [TP_h(i,j), FP_h(i,j), FN_h(i,j), TN_h(i,j), Precision_h(i,j), Accuracy_h(i,j), Specificity_h(i,j), Recall_h(i,j), F1_h(i,j)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
            [TP_f(i,j), FP_f(i,j), FN_f(i,j), TN_f(i,j), Precision_f(i,j), Accuracy_f(i,j), Specificity_f(i,j), Recall_f(i,j), F1_f(i,j)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
            [TP_t(i,j), FP_t(i,j), FN_t(i,j), TN_t(i,j), Precision_t(i,j), Accuracy_t(i,j), Specificity_t(i,j), Recall_t(i,j), F1_t(i,j)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));

        end
    end

    %% Plot curves

%     % Plot TP, TN, FP, FN
%     figure(1)
%     subplot(2,2,1)
%     plot(alpha,TP_h,alpha,TP_f,alpha,TP_t)
%     xlabel('Alpha')
%     ylabel('TP')
%     legend('TP Highway','TP Fall','TP Traffic')
%     title('TRUE POSITIVE')
% 
%     subplot(2,2,2)
%     plot(alpha,TN_h,alpha,TN_f,alpha,TN_t)
%     xlabel('Alpha')
%     ylabel('TN')
%     legend('TN Highway','TN Fall','TN Traffic')
%     title('TRUE NEGATIVE')
% 
%     subplot(2,2,3)
%     plot(alpha,FP_h,alpha,FP_f,alpha,FP_t)
%     xlabel('Alpha')
%     ylabel('FP')
%     legend('FP Highway','FP Fall','FP Traffic')
%     title('FALSE POSITIVE')
% 
%     subplot(2,2,4)
%     plot(alpha,FN_h,alpha,FN_f,alpha,FN_t)
%     xlabel('Alpha')
%     ylabel('FN')
%     legend('FN Highway','FN Fall','FN Traffic')
%     title('FALSE NEGATIVE')

    % Plot F1 Score
    figure(2)
    subplot(1,3,1)
    surf(ro,alpha,F1_h)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel('F1')
    legend('F1 Highway','F1 Fall','F1 Traffic')
    title('F1 Score')
    
    subplot(1,3,2)
    surf(ro,alpha,F1_f)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel('F1')
    legend('F1 Highway','F1 Fall','F1 Traffic')
    title('F1 Score')
    
    subplot(1,3,3)
    surf(ro,alpha,F1_t)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel('F1')
    legend('F1 Highway','F1 Fall','F1 Traffic')
    title('F1 Score')


    % Plot Precision VS Recall
    figure(3)
    subplot(1,3,1)
    plot(Recall_h,Precision_h,'b')
    title('Highway: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,2)
    plot(Recall_f,Precision_f,'r')
    title('Fall: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,3)
    plot(Recall_t,Precision_t,'g')
    title('Traffic: Precision VS Recall depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    
    [max_AUC_h, best_ro_index_h] = calculate_best_ro(Recall_h, Precision_h)
    [max_AUC_f, best_ro_index_f] = calculate_best_ro(Recall_f, Precision_f)
    [max_AUC_t, best_ro_index_t] = calculate_best_ro(Recall_t, Precision_t)
    
    disp(['Area under the curve for the Highway: ', num2str(Area_h)])
    disp(['Area under the curve for the Fall: ', num2str(Area_f)])
    disp(['Area under the curve for the Traffic: ', num2str(Area_t)])
    
    display('\n\nTask 4 done.\n\n')
end %end task4
