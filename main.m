
close;
clear;
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
for i=1:length(fileSet_input)
    seq_input{i}=imread(strcat('./highway/input/',fileSet_input(i).name));   
end

%GROUNDTRUTH
for i=1:length(fileSet_gt)
    seq_gt{i}=imread(strcat('./highway/groundtruth/',fileSet_gt(i).name)); 
    
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

play_video(seq_input, seq_gt, test_A, test_B, 1);
%play_video(test_A, test_B, 1);


%% TASK 1
% False Negative, True Negative, False Positive and True Positive, the Precision, the Recall and the F1 score for the 200 frames of both test A and test B sequences

[TP_A, TN_A, FN_A, FP_A, Prec_A, Rec_A, F1_A] = results_evaluation(seq_gt{1201:1400},test_A);

[TP_B, TN_B, FN_B, FP_B, Prec_B, Rec_B, F1_B] = results_evaluation(seq_gt{1201:1400},test_B);


%% TASK 2





%% TASK 3



