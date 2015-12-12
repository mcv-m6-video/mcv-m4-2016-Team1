
close all;
clear all;
clc;

addpath(genpath('.'));

global seq_input
global seq_gt
global test_A
global test_B

% Original Frames
folderName_input='./highway/input/*.jpg';
fileSet_input=dir(folderName_input); 

% Ground Truth
folderName_gt='./highway/groundtruth/*.png';
fileSet_gt=dir(folderName_gt); 

% testA Frames
folderName_input='./results/highway/testA/*.png';
fileSet_A=dir(folderName_input); 

% testB Truth
folderName_gt='./results/highway/testB/*.png';
fileSet_B=dir(folderName_gt); 


%Load all entire sequence
%INPUT
count=1;
for i=1201:1400
    seq_input{count}=imread(strcat('./highway/input/',fileSet_input(i).name));   
    count = count+1;
end

%GROUNDTRUTH
count=1;
for i=1201:1400
    seq_gt{count}=imread(strcat('./highway/groundtruth/',fileSet_gt(i).name)); 
    count = count+1;
    % normalize GT
  %  [x,y] = find(seq_gt{i}>0);
  %  seq_gt{i}(x,y)=1;    
end

%TESTA
for i=1:length(fileSet_A)
    test_A{i}=imread(strcat('./results/highway/testA/',fileSet_A(i).name));   
end

%TESTB
for i=1:length(fileSet_B)
    test_B{i}=imread(strcat('./results/highway/testB/',fileSet_B(i).name));   
end



%%

% play_video(seq_input, seq_gt, test_A, test_B, 1);
%play_video(test_A, test_B, 1);


%% TASK 1
% False Negative, True Negative, False Positive and True Positive, the Precision, the Recall and the F1 score for the 200 frames of both test A and test B sequences

TP_A_counter=0; TN_A_counter=0; FN_A_counter=0; FP_A_counter=0;
TP_B_counter=0; TN_B_counter=0; FN_B_counter=0; FP_B_counter=0;
assert(length(test_A)==length(test_B) && length(test_B)==length(seq_gt));
F1_vector_A = zeros(1,length(test_A));
F1_vector_B = zeros(1,length(test_B));
TP_vector_A = zeros(1,length(test_A));
TP_vector_B = zeros(1,length(test_B));

for i=1:length(test_A)
    [TP_A, FP_A, FN_A, TN_A] = PerformanceAccumulationPixel(test_A{i},seq_gt{i});
    TP_vector_A(i)=TP_A;
    TP_A_counter=TP_A_counter+TP_A; TN_A_counter=TN_A_counter+TN_A; FN_A_counter=FN_A_counter+FN_A; FP_A_counter=FP_A_counter+FP_A;
    [Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A, FP_A, FN_A, TN_A);
    F1_vector_A(i)=F1_A;

    [TP_B, FP_B, FN_B, TN_B] = PerformanceAccumulationPixel(test_B{i},seq_gt{i});
    TP_vector_B(i)=TP_B;
    TP_B_counter=TP_B_counter+TP_B; TN_B_counter=TN_B_counter+TN_B; FN_B_counter=FN_B_counter+FN_B; FP_B_counter=FP_B_counter+FP_B;
    [Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B, FP_B, FN_B, TN_B);
     F1_vector_B(i)=F1_B;
end
TP_A_counter, TN_A_counter, FN_A_counter, FP_A_counter
TP_B_counter, TN_B_counter, FN_B_counter, FP_B_counter

[Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A_counter, FP_A_counter, FN_A_counter, TN_A_counter);
[Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B_counter, FP_B_counter, FN_B_counter, TN_B_counter);
[Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A]
[Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B]


%% TASK 3

xLabel = 'frame';
yLabel = 'F1';

figure(1)
plot_F1_vs_frame(F1_vector_A,F1_vector_B, xLabel, yLabel);

figure(2)
plot_TP_and_GT_vs_frame(TP_vector_A,TP_vector_B,seq_gt);
pause;

%% TASK 6

F1_vector_A_DELAY = zeros(1,25);
F1_vector_B_DELAY = zeros(1,25);

for delay=0:1:25
    %% TASK 1
    % False Negative, True Negative, False Positive and True Positive, the Precision, the Recall and the F1 score for the 200 frames of both test A and test B sequences

    TP_A_counter=0; TN_A_counter=0; FN_A_counter=0; FP_A_counter=0;
    TP_B_counter=0; TN_B_counter=0; FN_B_counter=0; FP_B_counter=0;
    assert(length(test_A)==length(test_B) && length(test_B)==length(seq_gt));
    F1_vector_A = zeros(1,length(test_A)-delay);
    F1_vector_B = zeros(1,length(test_B)-delay);
    TP_vector_A = zeros(1,length(test_A)-delay);
    TP_vector_B = zeros(1,length(test_B)-delay);

    for i=1:length(test_A)-delay
        [TP_A, FP_A, FN_A, TN_A] = PerformanceAccumulationPixel(test_A{i+delay},seq_gt{i});
        TP_vector_A(i)=TP_A;
        TP_A_counter=TP_A_counter+TP_A; TN_A_counter=TN_A_counter+TN_A; FN_A_counter=FN_A_counter+FN_A; FP_A_counter=FP_A_counter+FP_A;
        [Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A, FP_A, FN_A, TN_A);
        F1_vector_A(i)=F1_A;

        [TP_B, FP_B, FN_B, TN_B] = PerformanceAccumulationPixel(test_B{i+delay},seq_gt{i});
        TP_vector_B(i)=TP_B;
        TP_B_counter=TP_B_counter+TP_B; TN_B_counter=TN_B_counter+TN_B; FN_B_counter=FN_B_counter+FN_B; FP_B_counter=FP_B_counter+FP_B;
        [Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B, FP_B, FN_B, TN_B);
         F1_vector_B(i)=F1_B;
    end
    %TP_A_counter, TN_A_counter, FN_A_counter, FP_A_counter
    %TP_B_counter, TN_B_counter, FN_B_counter, FP_B_counter

    [Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A_counter, FP_A_counter, FN_A_counter, TN_A_counter);
    [Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B_counter, FP_B_counter, FN_B_counter, TN_B_counter);
    %[Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A]
    %[Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B]
    
    F1_vector_A_DELAY(delay+1) = sum(F1_A)/length(test_A);
    F1_vector_B_DELAY(delay+1) = sum(F1_B)/length(test_B);
    
end


%% TASK 3

xLabel = 'Delay';
yLabel = 'F1';

figure(1)
plot_F1_vs_frame(F1_vector_A_DELAY,F1_vector_B_DELAY, xLabel, yLabel);
    
    