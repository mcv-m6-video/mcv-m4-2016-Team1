
function [seq_traffic_stab, gt_traffic_stab] = task5a(seq_traffic,gt_traffic, show_plots)

    % Size to crop the resulting image
    x = 20;
    y = 20;
    w = size(seq_traffic{1},2) - 40;
    h = size(seq_traffic{1},1) - 40;

    seq_traffic_stab = cell(size(seq_traffic));
    gt_traffic_stab = cell(size(gt_traffic));
    
    movMean = seq_traffic{1};
    correctedMean = seq_traffic{1};

    seq_traffic_stab{1} = imcrop(seq_traffic{1},[x y w h]);
    gt_traffic_stab{1} = imcrop(gt_traffic{1},[x y w h]);
    
    
    %% READ AND SHOW FRAMES
    
    for i=2:length(seq_traffic)
        
%         if i == 85 || i == 48 || i==91
%             pause;
%         end

        
        imgA = seq_traffic{i-1}; % Read first frame into imgA
        imgB = seq_traffic{i}; % Read second frame into imgB
        gtB = gt_traffic{i};
        
        movMean = movMean + imgB;

        if(show_plots)
            figure; imshowpair(imgA, imgB, 'montage');
            title(['Frame A', repmat(' ',[1 70]), 'Frame B']);
        end
        %% SHOW DIFFERENCE BETWEEN FRAMES

        if(show_plots)
            figure; imshowpair(imgA,imgB,'ColorChannels','red-cyan');
            title('Color composite (frame A = red, frame B = cyan)');
            pause
        end

        %% Collect Salient Points from Each Frame

        ptThresh = 0.1;
        pointsA = detectFASTFeatures(imgA, 'MinContrast', ptThresh);
        pointsB = detectFASTFeatures(imgB, 'MinContrast', ptThresh);

        if(show_plots)

            % Display corners found in images A and B.
            figure; imshow(imgA); hold on;
            plot(pointsA);
            title('Corners in A');

            figure; imshow(imgB); hold on;
            plot(pointsB);
            title('Corners in B');
            pause
        end

        %% Select Correspondences Between Points

        % Extract FREAK descriptors for the corners
        [featuresA, pointsA] = extractFeatures(imgA, pointsA);
        [featuresB, pointsB] = extractFeatures(imgB, pointsB);

        indexPairs = matchFeatures(featuresA, featuresB);
        pointsA = pointsA(indexPairs(:, 1), :);
        pointsB = pointsB(indexPairs(:, 2), :);

        if(show_plots)
            figure; showMatchedFeatures(imgA, imgB, pointsA, pointsB);
            legend('A', 'B');
            pause
        end

        
        %% Estimating Transform from Noisy Correspondences
    if size(pointsA,1)>2
        [tform, pointsBm, pointsAm] = estimateGeometricTransform(...
            pointsB, pointsA, 'affine');
        imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
        pointsBmp = transformPointsForward(tform, pointsBm.Location);

        if(show_plots)
            figure;
            showMatchedFeatures(imgA, imgBp, pointsAm, pointsBmp);
            legend('A', 'B');
            pause
        end

        %% Transform Approximation and Smoothing

        % Extract scale and rotation part sub-matrix.
        H = tform.T;
        R = H(1:2,1:2);
        % Compute theta from mean of two possible arctangents
        theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
        % Compute scale from mean of two stable mean calculations
        scale = mean(R([1 4])/cos(theta));
        % Translation remains the same:
        translation = H(3, 1:2);
        % Reconstitute new s-R-t transform:
        HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
          translation], [0 0 1]'];
        tformsRT = affine2d(HsRt);

        imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
        imgBsRt = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));

        seq_traffic_stab{i} = imcrop(imgBsRt,[x y w h]);
        gt_traffic_stab{i} = imcrop(imwarp(gtB, tformsRT, 'OutputView', imref2d(size(gtB))),[x y w h]);
        
        correctedMean = correctedMean + imgBold;

    else
        seq_traffic_stab{i} = imcrop(seq_traffic{i-1}, [x y w h]);
        gt_traffic_stab{i} = imcrop(gt_traffic{i-1}, [x y w h]);
        correctedMean = correctedMean + seq_traffic{i};
    end

        if (show_plots)
            figure(2), clf;
            imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
            title('Color composite of affine and s-R-t transform outputs');
            pause
        end
    end
    
    correctedMean = correctedMean/(i-2);
    movMean = movMean/(i-2);

    if(show_plots)
        figure; imshowpair(movMean, correctedMean, 'montage');
        title(['Raw input mean', repmat(' ',[1 50]), 'Corrected sequence mean']);
    end
    
end

