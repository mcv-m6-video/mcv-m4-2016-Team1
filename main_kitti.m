close all;
clear all;
clc;

addpath(genpath('.'));

global sq_0_test
global sq_0_train
global sq_0_test_flow_noc
global sq_0_train_flow_noc
global sq_0_m4_kitti_flow_noc

% Read image_0

sq_0_train{1} = imread('./data_stereo_flow/training/image_0/000045_10.png');
sq_0_train{2} = imread('./data_stereo_flow/training/image_0/000045_11.png');

sq_1_train{1} = imread('./data_stereo_flow/training/image_0/000157_10.png');
sq_1_train{2} = imread('./data_stereo_flow/training/image_0/000157_11.png');

sq_0_gt_flow_noc{1} = flow_read('./data_stereo_flow/training/flow_noc/000045_10.png');
sq_0_gt_flow_noc{2} = flow_read('./data_stereo_flow/training/flow_noc/000157_10.png'); 

sq_0_est_kitti_flow_noc{1} = flow_read('./results_kitti/LKflow_000045_10.png');
sq_0_est_kitti_flow_noc{2} = flow_read('./results_kitti/LKflow_000157_10.png');

% Plot figure 1

figure(1);

t = 1;

subplot(4,2,1);
imshow(sq_0_train{t});
title('train image_1 10')

subplot(4,2,3);
imshow(sq_0_train{t+1});
title('train image_1 11')

subplot(4,2,2)
imshow(sq_1_train{t});
title('train image_1 157 10')

subplot(4,2,4)
imshow(sq_1_train{t+1});
title('train image_1 157 11')

subplot(4,2,5);
imshow(sq_0_gt_flow_noc{t});
title('train kitti flow')

subplot(4,2,6);
imshow(sq_0_gt_flow_noc{t+1});
title('train kitti flow')

subplot(4,2,7);
imshow(sq_0_est_kitti_flow_noc{t});
title('m4 kitti flow')

subplot(4,2,8);
imshow(sq_0_est_kitti_flow_noc{t+1});
title('m4 kitti flow')

%% Task 4 Compute the mean magnitude error, MMEN, for all pixels in
% non-ocluded areas.
% 1st test
tau=3;
f_err = flow_error(sq_0_gt_flow_noc{1},sq_0_est_kitti_flow_noc{1},tau);
F_err = flow_error_image(sq_0_gt_flow_noc{1},sq_0_est_kitti_flow_noc{1});
% figure,imshow([flow_to_color([sq_0_est_kitti_flow_noc{1};sq_0_gt_flow_noc{1}]);F_err]);
figure,imshow(F_err);
title(sprintf('Error: %.2f %%',f_err*100));
figure,flow_error_histogram(sq_0_gt_flow_noc{1},sq_0_est_kitti_flow_noc{1});
pause;
% 2nd test
close all;
f_err = flow_error(sq_0_gt_flow_noc{2},sq_0_est_kitti_flow_noc{2},tau);
F_err = flow_error_image(sq_0_gt_flow_noc{2},sq_0_est_kitti_flow_noc{2});
figure,imshow(F_err);
title(sprintf('Error: %.2f %%',f_err*100));
figure,flow_error_histogram(sq_0_gt_flow_noc{2},sq_0_est_kitti_flow_noc{2});

