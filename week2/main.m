close all;
clear all;
clc;

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




%% Non-recursive Gaussian modeling

alpha = [0.1:0.1:5];

for i = 1:length(alpha)
    %% TASK 1
%    disp('--------TASK 1--------');

    [forEstim_highway, t1_h,t2_h]= task1(seq_input_highway,alpha(i));
    [forEstim_fall,t1_f,t2_f] = task1(seq_input_fall,alpha(i));
    [forEstim_traffic,t1_t,t2_t]= task1(seq_input_traffic,alpha(i));

    %% TASK 2 and TASK 3

%    disp('--------TASK 2--------');

    [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
    [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
    [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));

end

%% Plot curves

% Plot TP, TN, FP, FN
figure(1)
subplot(2,2,1)
plot(alpha,TP_h,alpha,TP_f,alpha,TP_t)
xlabel('Alpha')
ylabel('TP')
legend('TP Highway','TP Fall','TP Traffic')
title('TRUE POSITIVE')

subplot(2,2,2)
plot(alpha,TN_h,alpha,TN_f,alpha,TN_t)
xlabel('Alpha')
ylabel('TN')
legend('TN Highway','TN Fall','TN Traffic')
title('TRUE NEGATIVE')

subplot(2,2,3)
plot(alpha,FP_h,alpha,FP_f,alpha,FP_t)
xlabel('Alpha')
ylabel('FP')
legend('FP Highway','FP Fall','FP Traffic')
title('FALSE POSITIVE')

subplot(2,2,4)
plot(alpha,FN_h,alpha,FN_f,alpha,FN_t)
xlabel('Alpha')
ylabel('FN')
legend('FN Highway','FN Fall','FN Traffic')
title('FALSE NEGATIVE')

% Plot F1 Score
figure(2)
plot(alpha,F1_h,alpha,F1_f,alpha,F1_t)
xlabel('Alpha')
ylabel('F1')
legend('F1 Highway','F1 Fall','F1 Traffic')
title('F1 Score')


% Plot Precision VS Recall
figure(3)
plot(Recall_h,Precision_h,Recall_f,Precision_f,Recall_t,Precision_t)
xlabel('Recall')
ylabel('Precision')
legend('Highway','Fall','Traffic')
title('Precision VS Recall depending on Alpha')


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

%%
