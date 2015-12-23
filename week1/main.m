
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

%TEST A
for i=1:length(fileSet_A)
    test_A{i}=imread(strcat('./results/highway/testA/',fileSet_A(i).name));   
end

%TEST B
for i=1:length(fileSet_B)
    test_B{i}=imread(strcat('./results/highway/testB/',fileSet_B(i).name));   
end



%%
% Uncomment if you want to see the video!
% play_video(seq_input, seq_gt, test_A, test_B, 1);
% pause;
%play_video(test_A, test_B, 1);


%% TASK 1
disp('--------TASK 1--------');
% False Negative, True Negative, False Positive and True Positive, the Precision, the Recall and the F1 score for the 200 frames of both test A and test B sequences

% Initialize the counters. We will compute TP, TN, FN, FP for each image.
TP_A_counter=0; TN_A_counter=0; FN_A_counter=0; FP_A_counter=0;
TP_B_counter=0; TN_B_counter=0; FN_B_counter=0; FP_B_counter=0;

% Assert if we have the same number of images in all sequencies
assert(length(test_A)==length(test_B) && length(test_B)==length(seq_gt));

% Initialize the F1 and TP vectors.
F1_vector_A = zeros(1,length(test_A));
F1_vector_B = zeros(1,length(test_B));
TP_vector_A = zeros(1,length(test_A));
TP_vector_B = zeros(1,length(test_B));

% Peform the evaluation for all images.
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

% Finally, perform the total evaluation.
[Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A_counter, FP_A_counter, FN_A_counter, TN_A_counter)
[Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B_counter, FP_B_counter, FN_B_counter, TN_B_counter)
pause;


%% TASK 3
disp('--------TASK 3--------');
xLabel = 'frame';
yLabel = 'F1';

% Plot F1 in every frame
figure(1)
plot_F1_vs_frame(F1_vector_A,F1_vector_B, xLabel, yLabel);

% Plot True Positives and ground truth positives in every frame
figure(2)
plot_TP_and_GT_vs_frame(TP_vector_A,TP_vector_B,seq_gt);
pause;

%% TASK 6
disp('--------TASK 6--------');
close all;
% Initialize the F1 delay vectors with 25 possible delays
F1_vector_A_DELAY = zeros(1,25);
F1_vector_B_DELAY = zeros(1,25);

% Advance in the delays
for delay=0:1:25
    % Init counters
    TP_A_counter=0; TN_A_counter=0; FN_A_counter=0; FP_A_counter=0;
    TP_B_counter=0; TN_B_counter=0; FN_B_counter=0; FP_B_counter=0;
    
    %Assert lengths
    assert(length(test_A)==length(test_B) && length(test_B)==length(seq_gt));
    
%     F1_vector_A = zeros(1,length(test_A)-delay);
%     F1_vector_B = zeros(1,length(test_B)-delay);
%     TP_vector_A = zeros(1,length(test_A)-delay);
%     TP_vector_B = zeros(1,length(test_B)-delay);

    % Compute the TP, FP, FN, TN for every approach (A or B)
    for i=1:length(test_A)-delay
        [TP_A, FP_A, FN_A, TN_A] = PerformanceAccumulationPixel(test_A{i+delay},seq_gt{i});
%         TP_vector_A(i)=TP_A;
        TP_A_counter=TP_A_counter+TP_A; TN_A_counter=TN_A_counter+TN_A; FN_A_counter=FN_A_counter+FN_A; FP_A_counter=FP_A_counter+FP_A;
%         [Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A, FP_A, FN_A, TN_A);
%         F1_vector_A(i)=F1_A;

        [TP_B, FP_B, FN_B, TN_B] = PerformanceAccumulationPixel(test_B{i+delay},seq_gt{i});
%         TP_vector_B(i)=TP_B;
        TP_B_counter=TP_B_counter+TP_B; TN_B_counter=TN_B_counter+TN_B; FN_B_counter=FN_B_counter+FN_B; FP_B_counter=FP_B_counter+FP_B;
%         [Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B, FP_B, FN_B, TN_B);
%          F1_vector_B(i)=F1_B;
    end
    %TP_A_counter, TN_A_counter, FN_A_counter, FP_A_counter
    %TP_B_counter, TN_B_counter, FN_B_counter, FP_B_counter

    % Compute the scores
    [Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A] = PerformanceEvaluationPixel(TP_A_counter, FP_A_counter, FN_A_counter, TN_A_counter);
    [Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B] = PerformanceEvaluationPixel(TP_B_counter, FP_B_counter, FN_B_counter, TN_B_counter);
    %[Precision_A, Accuracy_A, Specificity_A, Recall_A, F1_A]
    %[Precision_B, Accuracy_B, Specificity_B, Recall_B, F1_B]
    
    % Save the delayed F1 score in vector
    F1_vector_A_DELAY(delay+1) = F1_A;
    F1_vector_B_DELAY(delay+1) = F1_B;
    
end

% Plot the delayed F1 scores
xLabel = 'Delay';
yLabel = 'F1';
figure(1)
plot_F1s_desync(F1_vector_A_DELAY,F1_vector_B_DELAY, xLabel, yLabel);
    
    