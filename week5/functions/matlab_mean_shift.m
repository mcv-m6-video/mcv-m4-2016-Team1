function matlab_mean_shift( seq )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    tracker = vision.HistogramBasedTracker;

    frame = seq{1};
    hsv = rgb2hsv(frame);

    id = [1];
    objectRegion = [185, 100, 65, 60];
    
    number_of_bins = 16;
    
    initializeObject(tracker, hsv(:,:,1) , objectRegion, number_of_bins);
    
    print_bb_with_id( seq{1}, id, objectRegion(1), objectRegion(2), objectRegion(3), objectRegion(4) )
    
    for index_frame = 2 : length(seq)
        
        frame = seq{index_frame};
        
        hsv = rgb2hsv(frame);                   
        [bbox, orientation, score] = step(tracker, hsv(:,:,1));
        
        if (score > 0.50)
        
            id = [1];
            x1 = [bbox(1)];
            y1 = [bbox(2)];
            x2 = [bbox(3)];
            y2 = [bbox(4)];

            print_bb_with_id( frame, id, x1, y1, x2, y2 )
        
        else
            imshow(frame);
            drawnow;
        end
    end

end

