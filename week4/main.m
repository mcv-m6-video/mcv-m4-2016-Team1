close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options

color_space = 'RGB'; % 'RGB', 'Gray', 'HSV', 'YUV'

doTask1 = false;
doTask2 = false;
doTask3 = false;

doTask4 = false; opticalFlow = 'opticalFlowHS';
doTask5 = false; est_method = 'Feat_track'; %'Feat_track' 'team1_method' %GRAY IMAGES ONLY 'Premiere' %RGB ONLY
doTask6 = true;

show_plots = false;
show_seq = false;

doFirstOpticalFlow = false; doSecondOpticalFlow = false;
% 'opticalFlowHS'
smoothness = 1; maxIteration = 10; velocityDifference = 0;
% 'opticalFlowFarneback'
numPyramidLevels = 3; pyramidScale = 0.5; numIterations = 3; neighborhoodSize = 5; filterSize = 15;
% 'opticalFlowLK'
noiseThreshold_LK = 0.0039;
% 'opticalFlowLKDoG'
numFrames = 3; imageFilterSigma = 1.5; gradientFilterSigma = 1; noiseThreshold_LKDoG = 0.0039;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'))

[seq_traffic, gt_traffic, seq_kitti45, seq_kitti157, gt_kitti45, gt_kitti157] = load_seqs(color_space);

global params;
params = load_parameters();

%% Task1
if (doTask1)
    disp('----- TASK 1 -----')
    [flow45, tracked_img45] = block_matching(seq_kitti45{1},seq_kitti45{2});
    figure(1)
    quiver(flow45(:,:,1), flow45(:,:,2))
    figure(2)
    imshow(uint8(tracked_img45));
    [flow157, tracked_img157] = block_matching(seq_kitti157{1},seq_kitti157{2});
    figure(3)
    quiver(flow157(:,:,1), flow157(:,:,2))
    figure(4)
    imshow(uint8(tracked_img157));
end

%% Task 2

if(doTask2)
    disp('press any key to execute task 2')
    pause;
    close all;
    disp('----- TASK 2 -----')
    
    flow45(:,:,3) = gt_kitti45(:,:,3);
    F_err45 = flow_error_image(gt_kitti45,flow45);
    figure(1),imshow(F_err45);
    
    flow157(:,:,3) = gt_kitti157(:,:,3);
    F_err157 = flow_error_image(gt_kitti157,flow157);
    figure(2),imshow(F_err157);
    
    % Mean square error
    SSE45 = sqrt((flow45(:,:,1) - gt_kitti45(:,:,1)).^2 + (flow45(:,:,2) - gt_kitti45(:,:,2)).^2);
    % Occluded
    SSE45(gt_kitti45(:,:,3)==0) = 0;
    MSEN45 = sum(SSE45(:))/nnz(gt_kitti45(:,:,3));
    disp(['MSEN 45: ', num2str(MSEN45)])
    f_err45 = flow_error(gt_kitti45,flow45,params.tau);
    disp(['PEPN 45: ', num2str(f_err45*100),'%%'])
    
    % Mean square error
    SSE157 = sqrt((flow157(:,:,1) - gt_kitti157(:,:,1)).^2 + (flow157(:,:,2) - gt_kitti157(:,:,2)).^2);
    % Occluded
    SSE157(gt_kitti157(:,:,3)==0) = 0;
    MSEN157 = sum(SSE157(:))/nnz(gt_kitti157(:,:,3));
    disp(['MSEN 157: ', num2str(MSEN157)])
    f_err157 = flow_error(gt_kitti157,flow157,params.tau);
    disp(['PEPN 157: ', num2str(f_err157*100),'%%'])
end

%% Task 3
if(doTask3)
    disp('press any key to execute task 3')
    pause;
    close all;
    disp('----- TASK 3 -----')
    [traffic_stabilized,~] = stabilize_sequence(seq_traffic,gt_traffic);
    v = VideoWriter('video1','Motion JPEG AVI');
    v.FrameRate = 10;
    open(v);
    for i=1:length(traffic_stabilized)
        fig = figure('Visible','Off');
        subplot(1,2,1)
        imshow(seq_traffic{i});
        title('Original')
        subplot(1,2,2)
        imshow(traffic_stabilized{i});
        title('Stabilized')
        im = frame2im(getframe(fig));
        writeVideo(v,im);
        %         figure(1)
        %         imshow(traffic_stabilized{i})
        %         pause(0.05);
    end
    close(v);
end

%% Task 4
if(doTask4)
    disp('press any key to execute task 4')
    pause;
    close all;
    disp('----- TASK 4 -----')
    
    switch opticalFlow
        
        case 'opticalFlowHS'
            
            opticFlow = opticalFlowHS('Smoothness', smoothness, 'MaxIteration', maxIteration, 'VelocityDifference', velocityDifference);
            
        case 'opticalFlowFarneback'
            
            opticFlow = opticalFlowFarneback('NumPyramidLevels', numPyramidLevels, 'PyramidScale', pyramidScale, 'NumIterations', numIterations, 'NeighborhoodSize', neighborhoodSize, 'FilterSize', filterSize);
            
        case 'opticalFlowLK'
            
            opticFlow = opticalFlowLK('NoiseThreshold', noiseThreshold_LK);
            
        case 'opticalFlowLKDoG'
            
            opticFlow = opticalFlowLKDoG('NumFrames', numFrames, 'ImageFilterSigma', imageFilterSigma, 'ImageFilterSigma', imageFilterSigma, 'NoiseThreshold', noiseThreshold_LKDoG);
            
        otherwise
            error('Choose a valid opticalFlow')
    end
    
    [MSEN45, PEPN45] = compute_optical_flow_errors(opticFlow, seq_kitti45, gt_kitti45, params);
    
    switch opticalFlow
        
        case 'opticalFlowHS'
            
            opticFlow = opticalFlowHS('Smoothness', smoothness, 'MaxIteration', maxIteration, 'VelocityDifference', velocityDifference);
            
        case 'opticalFlowFarneback'
            
            opticFlow = opticalFlowFarneback('NumPyramidLevels', numPyramidLevels, 'PyramidScale', pyramidScale, 'NumIterations', numIterations, 'NeighborhoodSize', neighborhoodSize, 'FilterSize', filterSize);
            
        case 'opticalFlowLK'
            
            opticFlow = opticalFlowLK('NoiseThreshold', noiseThreshold_LK);
            
        case 'opticalFlowLKDoG'
            
            opticFlow = opticalFlowLKDoG('NumFrames', numFrames, 'ImageFilterSigma', imageFilterSigma, 'ImageFilterSigma', imageFilterSigma, 'NoiseThreshold', noiseThreshold_LKDoG);
            
        otherwise
            error('Choose a valid opticalFlow')
    end
    
    [MSEN157, PEPN157] = compute_optical_flow_errors(opticFlow, seq_kitti157, gt_kitti157, params);
    
end

%% Task 5
if(doTask5)
    disp('press any key to execute task 5')
    pause;
    close all;
    disp('----- TASK 5 -----')
    
    % Estabilize video and GT
    disp('Computing video stabilization...')
    
    if ~(strcmp(est_method,'Premiere')) % If the estabilization method is not Premiere, we can evaluate
        
        if (strcmp(est_method,'Feat_track')) % Matlabs estabilization method
            [seq_traffic_stab, gt_traffic_stab] = task5a(seq_traffic,gt_traffic, show_plots);
       
        elseif(strcmp(est_method,'team1_method')) %Our own implemented estabilization method
            [seq_traffic_stab, gt_traffic_stab] = stabilize_sequence(seq_traffic,gt_traffic);
        end
    
        % Show Sequence
        if(show_seq)
            showvideo(seq_traffic,seq_traffic_stab,gt_traffic,gt_traffic_stab);
        end

        % Foreground Estimation
        for i = 1:length(params.alpha)
            disp(['Computing forground estimation... Alpha = ',num2str(params.alpha(i))])
            % Previous stabilization
            [forEstim_traffic,t1_t, mean_t]= task1(seq_traffic, params.alpha(i), params.P,false, color_space);
            [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_traffic(t1_t:end));

            % With stabilization
            [forEstim_traffic_stab,t1_t, mean_t]= task1(seq_traffic_stab,params.alpha(i), params.P,false, color_space);
            [TP_ts(i), FP_ts(i), FN_ts(i), TN_ts(i), Precision_ts(i), Accuracy_ts(i), Specificity_ts(i), Recall_ts(i), F1_ts(i)] = task2(forEstim_traffic_stab,gt_traffic_stab(t1_t:end));

        end

        % Evaluate: PR Curves, AUC, F1-Score
        % F1-Score
        [maxF1t,id_t] = max(F1_t); good_alpha_t = params.alpha(id_t);
        disp(['max F1 traffic: ', num2str(maxF1t), ' in alpha: ',num2str(good_alpha_t)]);

        [maxF1ts,id_ts] = max(F1_ts); good_alpha_ts = params.alpha(id_ts);
        disp(['max F1 traffic stabilized: ', num2str(maxF1ts), ' in alpha: ',num2str(good_alpha_ts)]);

        % PR Curves and AUC
        Precision_ts(isnan(Precision_ts))=1;
        figure;
        plot([1,Recall_t,0],[0,Precision_t,1],[1,Recall_ts,0],[0,Precision_ts,1]); legend('No Stabilized','Stabilized')
        xlabel('Recall'); ylabel('Precision'); title('PR Curve of Stabilized video')

        Area_t(i) = trapz(flip([1,Recall_t,0]), flip([0,Precision_t,1]));
        disp(['Area under the curve for the Traffic: ', num2str(Area_t(i))])

        Area_ts(i) = trapz(flip([1,Recall_ts,0]), flip([0,Precision_ts,1]));
        disp(['Area under the curve for the Traffic Stabilized: ', num2str(Area_ts(i))])
    
    elseif (strcmp(est_method,'Premiere'))
        
        seq_traffic_stab = load_seqs_adobe();
        
        [forEstim_traffic,t1_t, mean_t]= task1(seq_traffic, 1.6, params.P,false, color_space);
        [forEstim_traffic_stab,t1_ts, mean_ts]= task1(seq_traffic_stab, 1.6, params.P,false, color_space);
        
        % Show Sequence
       for i = 1:length(forEstim_traffic_stab)
           subplot(2,2,1)
           imshow(seq_traffic{i}); title('No Stabilized')   ;        
           subplot(2,2,2)
           imshow(forEstim_traffic{i}); title('Foreground detection No Stabilized');
           subplot(2,2,3)
           imshow(seq_traffic_stab{i}); title('Stabilized')
           subplot(2,2,4)
           imshow(forEstim_traffic_stab{i});title('Foreground detection Stabilized')
           pause(0.1);
       end
    end
    
end

%% Task 6
if(doTask6)
    disp('press any key to execute task 6')
    pause;
    close all;
    disp('----- TASK 6 -----')
    
    %     videoFReader = vision.VideoFileReader(params.video);
    %     while ~isDone(videoFReader)
    %         frame = step(videoFReader);
    %         imshow(frame);
    %         pause;
    %     end
    vid = VideoReader(params.video);
    seq_no_stabilized = cell(1,vid.Duration);
    count=1;
    while hasFrame(vid)
        img = readFrame(vid);
        seq_no_stabilized{count} = img;
        count = count+1;
        %     imshow(img);
    end
    [seq_stabilized, ~] = stabilize_sequence(seq_no_stabilized,seq_no_stabilized);
    v = VideoWriter('jordi_stable','Motion JPEG AVI');
    v.FrameRate = 10;
    open(v);    
    for i=1:length(seq_stabilized)
        writeVideo(v,seq_stabilized{i});
    end
    close(v);
    %     stabilization_matlab_code(params.video);
    
end
