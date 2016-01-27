function [ seq ] = storeAviFramesInSeq( aviFilename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    obj.reader = vision.VideoFileReader('videos/20kmh_cam.mp4');
    
    obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);

    index = 1;
    
    while ~isDone(obj.reader)
    
        frame = obj.reader.step();
        
        seq{index} = frame;
        
        obj.videoPlayer.step(frame);
        
        index = index + 1;
    end
end

