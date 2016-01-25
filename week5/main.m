close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options

color_space = 'RGB'; % 'RGB', 'Gray', 'HSV', 'YUV'

doTask1 = false;
doTask2 = false;
doTask3 = false;
doTask4 = true;
doTask5 = false;

show_plots = false;
show_seq = true;
show_videos = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'))

[seq_highway, gt_highway, seq_traffic, gt_traffic] = load_seqs(color_space);
% save_sequence(seq_highway,'highway', 10);
% save_sequence(seq_traffic,'traffic', 5);

global params;
params = load_parameters();

%% Task1
if (doTask1)
    disp('----- TASK 1 -----')
    
    disp('Apply the background substraction work previously done.')
    foreEstim_highway = backgroundSubstraction(seq_highway,params.alpha, params.P, show_videos, color_space);
    foreEstim_traffic = backgroundSubstraction(seq_traffic,params.alpha, params.P, show_videos, color_space);
    save_sequence(foreEstim_highway,'foreground_highway', 10);
%     save_sequence(foreEstim_traffic,'foreground_traffic', 5);
    
    disp('Use Kalman filter to track each vehicle appearing in the sequence.')
    
    
    
end

%% Task 2

if(doTask2)
    disp('press any key to execute task 2')
    pause;
    close all;
    disp('----- TASK 2 -----')
    disp('Draw a bounding box around each vehicle with an ID counter.')
    
    figure(1); imshow(seq_highway{1}); title('Red box shows object region');
    drawnow;
    
    for index = 2 : length(seq_highway)
        frame = seq_highway{index};
        
        % We need to initialize this variables
        
        id = [1];
        x1 = [20 + frame];
        y1 = [20 + frame];
        x2 = [100 + frame];
        y2 = [100 + frame];
        
        % This function prints a red bounding box and an id
        
        print_bb_with_id( frame, id, x1, y1, x2, y2 )
        
        disp([num2str(index), '/', num2str(length(seq_highway))])
        
    end
    
end

%% Task 3
if(doTask3)
    disp('press any key to execute task 3')
    pause;
    close all;
    disp('----- TASK 3 -----')
    disp('Estimate the speed of the vehicles.')
    disp('Specify any assumption you make to simplify the problem (KISS).')
    
end

%% Task 4
if(doTask4)
    disp('press any key to execute task 4')
    %pause;
    close all;
    disp('----- TASK 4 -----')
    disp('Test another tracking method:')
    disp('https://saravananthirumuruganathan.wordpress.com/2010/04/01/introduction-to-mean-shift-algorithm/')
    disp('http://areshmatlab.blogspot.com.es/2010/06/meanshift-tracking-algorithm.html')
    
    matlab_mean_shift(seq_highway)
    
end

%% Task 5
if(doTask5)
    disp('press any key to execute task 5')
    pause;
    close all;
    disp('----- TASK 5 -----')
    disp('Record a video sequence with traffic monitoring.')
    disp('(optional) Generate a simple speed ground truth with in-vehicle recording of the speed meter.')
    
end