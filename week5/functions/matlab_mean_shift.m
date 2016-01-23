function matlab_mean_shift( seq )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    frame = seq{1};
    hsv = rgb2hsv(frame);

    id = [1];
    objectRegion = [185, 100, 250, 160];
    
    print_bb_with_id( seq{1}, id, objectRegion(1), objectRegion(2), objectRegion(3) - objectRegion(1), objectRegion(4) - objectRegion(2) )
    
    tracker = vision.HistogramBasedTracker;
    initializeObject(tracker, hsv(:,:,1) , objectRegion);
    
    for index_frame = 2 : length(seq)
        
        frame = seq{index_frame};
        
        hsv = rgb2hsv(frame);                   
        bbox = step(tracker, hsv(:,:,1));       
        
        id = [1];
        x1 = [bbox(1)];
        y1 = [bbox(2)];
        x2 = [max(bbox(3) - bbox(1), 1)];
        y2 = [max(bbox(4) - bbox(2), 1)];

        print_bb_with_id( frame, id, x1, y1, x2, y2 )             
    end

end

