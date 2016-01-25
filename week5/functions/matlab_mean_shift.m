function matlab_mean_shift( seq )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    id = [1];
    tracker = vision.HistogramBasedTracker; % Mean Shift algorithm

    frame = seq{1};
    hsv = rgb2hsv(frame);
    
    bbox = [185, 100, 65, 60];
    
    number_of_bins_in_histogram = 16;
    
    initializeObject(tracker, hsv(:,:,1) , bbox, number_of_bins_in_histogram);
    
    print_bb_with_id( frame, id, bbox(1), bbox(2), bbox(3), bbox(4) )
    
    for index_frame = 2 : length(seq)
        
        frame = seq{index_frame};
        
        hsv = rgb2hsv(frame);
        
        [bbox, orientation, score] = step(tracker, hsv(:,:,1));
        
        if (score > 0.50)
        
            id = [1];

            print_bb_with_id( frame, id, bbox(1), bbox(2), bbox(3), bbox(4) )
        
        else
            imshow(frame);
            drawnow;
        end
    end

end

