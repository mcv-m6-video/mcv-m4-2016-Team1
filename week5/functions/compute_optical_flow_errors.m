function [ MSEN, PEPN ] = compute_optical_flow_errors( opticFlow, seq_kitti, gt_kitti, params )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Compute optical flow process
    for i=1:length(seq_kitti)
        
        frame = seq_kitti{i};
        
        if size(frame,3) == 3
            frameGray = rgb2gray(frame);
        else
            frameGray = frame;
        end

        % Compute optical flow
        flow = estimateFlow(opticFlow, frameGray);
        
        % First frame can not have estimation. 
        % The different optical flow algorithms estimate the flow of the first image from a black image.
        if i ~= 1
            
            f_est = double(zeros(size(frameGray)));
            
            f_est(:,:,1) = flow.Vx;
            f_est(:,:,2) = flow.Vy;

            % Display video frame with flow vectors
            figure()
            imshow(frameGray) 
            hold on
            plot(flow, 'DecimationFactor', [5 5], 'ScaleFactor', 60)
            drawnow
            hold off
            
            f_est(:,:,3) = gt_kitti(:,:,3);
            f_err = flow_error_image(gt_kitti,f_est);
            figure(),imshow(f_err);
            
            % Mean square error
            SSE = sqrt((f_est(:,:,1) - gt_kitti(:,:,1)).^2 + (f_est(:,:,2) - gt_kitti(:,:,2)).^2);
            % Occluded
            SSE(gt_kitti(:,:,3)==0) = 0;
            MSEN = sum(SSE(:))/nnz(gt_kitti(:,:,3));
            disp(['MSEN: ', num2str(MSEN)])
            
            % Percentage of Erroneous Pixels
            PEPN = flow_error(gt_kitti,f_est,params.tau);
            disp(['PEPN: ', num2str(PEPN*100),'%%'])
            
        end

    end

end

