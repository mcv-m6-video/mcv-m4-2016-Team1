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

% folderFName_input='../fall/input/*.jpg';
% fileFSet_input=dir(folderFName_input);

folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);

% Ground Truth
folderHName_gt='../highway/groundtruth/*.png';
fileHSet_gt=dir(folderHName_gt);

% folderFName_gt='../fall/groundtruth/*.png';
% fileFSet_gt=dir(folderFName_gt);

folderTName_gt='../traffic/groundtruth/*.png';
fileTSet_gt=dir(folderTName_gt);


%Load all entire sequence
%INPUT
for i=1:length(fileHSet_input)
    seq_input_highway{i}=rgb2gray(imread(strcat('../highway/input/',fileHSet_input(i).name)));
%     seq_input_highway{i}=imread(strcat('../highway/input/',fileHSet_input(i).name));    
end

% for i=1:length(fileFSet_input)
%     seq_input_fall{i}=rgb2gray(imread(strcat('../fall/input/',fileFSet_input(i).name)));
% end

for i=1:length(fileTSet_input)
    seq_input_traffic{i}=rgb2gray(imread(strcat('../traffic/input/',fileTSet_input(i).name)));
%     seq_input_traffic{i}=imread(strcat('../traffic/input/',fileTSet_input(i).name));    
end


%GROUNDTRUTH
for i=1:length(fileHSet_input)
    gt_input_highway{i}=imread(strcat('../highway/groundtruth/',fileHSet_gt(i).name));
end

% for i=1:length(fileFSet_input)
%     gt_input_fall{i}=imread(strcat('../fall/groundtruth/',fileFSet_gt(i).name));
% end

for i=1:length(fileTSet_input)
    gt_input_traffic{i}=imread(strcat('../traffic/groundtruth/',fileTSet_gt(i).name));
end



%%
% Uncomment if you want to see the video!
% play_video(seq_input, seq_gt, test_A, test_B, 1);
% pause;
%play_video(test_A, test_B, 1);


%% TASK 1
disp('--------TASK 1--------');

% % Compute mean highway
% dims = ndims(seq_input_highway{1});
% M = cat(dims+1,seq_input_highway{1:round(length(seq_input_highway)/2)});
% seqH_mean = mean(M,dims+1);
% seqH_std = std(double(M),0,dims+1);
% clear M;
% 
% dims = ndims(seq_input_traffic{1});
% M = cat(dims+1,seq_input_traffic{1:round(length(seq_input_traffic)/2)});
% seqT_mean = mean(M,dims+1);
% seqT_std = std(double(M),0,dims+1);
% clear M;

%C = task1(seq_input_highway);
C = task1(seq_input_traffic);






