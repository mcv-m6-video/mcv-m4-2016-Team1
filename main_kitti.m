close all;
clear all;
clc;

addpath(genpath('.'));

global sq_0_test
global sq_0_train
global sq_0_train_flow_noc

% Read image_45

sq_0_test{1} = imread('./data_stereo_flow/testing/image_0/000045_10.png');
sq_0_test{2} = imread('./data_stereo_flow/testing/image_0/000045_11.png');

sq_0_train{1} = imread('./data_stereo_flow/training/image_0/000045_10.png');
sq_0_train{2} = imread('./data_stereo_flow/training/image_0/000045_11.png');

sq_0_train_flow_noc{1} = imread('./data_stereo_flow/training/flow_noc/000045_10.png');

% Read image_157

sq_1_test{1} = imread('./data_stereo_flow/testing/image_0/000157_10.png');
sq_1_test{2} = imread('./data_stereo_flow/testing/image_0/000157_11.png');

sq_1_train{1} = imread('./data_stereo_flow/training/image_0/000157_10.png');
sq_1_train{2} = imread('./data_stereo_flow/training/image_0/000157_11.png');

sq_1_train_flow_noc{1} = imread('./data_stereo_flow/training/flow_noc/000157_10.png');

% Plot figure 1

figure(1);

t = 1;

subplot(3,2,1);
imshow(sq_0_test{t});
title('test image_0 10')

subplot(3,2,2);
imshow(sq_0_test{t+1});
title('test image_0 11')

subplot(3,2,3)
imshow(sq_0_train{t});
title('train image_0 10')

subplot(3,2,4)
imshow(sq_0_train{t+1});
title('train image_0 11')

subplot(3,2,5);
imshow(sq_0_train_flow_noc{t});
title('kitti flow')
    

% Plot figure 1

figure(2);

t = 1;

subplot(3,2,1);
imshow(sq_1_test{t});
title('test image_1 10')

subplot(3,2,2);
imshow(sq_1_test{t+1});
title('test image_1 11')

subplot(3,2,3)
imshow(sq_1_train{t});
title('train image_1 10')

subplot(3,2,4)
imshow(sq_1_train{t+1});
title('train image_1 11')

subplot(3,2,5);
imshow(sq_1_train_flow_noc{t});
title('kitti flow')



    