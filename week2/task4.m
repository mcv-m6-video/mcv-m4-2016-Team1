function [foreEstim, seq_starting_test] = task4(seq, alpha, rho, show_videos, color_space)

% parameters
% alpha = 0.8;
% ro = 0.03;

% total elements in the sequence for training
seq_length = length(seq);
seq_starting_test = round(seq_length/2) + 1; % first frame for test

% dimensions of each frame (for future 3d)
dims = ndims(seq{1});

M = cat(dims+1,seq{1:round(seq_length/2)});
seq_mean = mean(M,dims+1);
seq_std = std(double(M),0,dims+1);
clear M;

for f = seq_starting_test : seq_length
    
    % Pixels which are background need to update its mean and std:
    
    % the bckg mask has the pixels which are similar enough to the mean
    bckg = abs(double(seq{f}) - seq_mean) < alpha .* (seq_std + 2);
    
    % new mean for bckg pixels is updated using a ro regularizer
    seq_mean(bckg) = rho * double(seq{f}(bckg)) + (1 - rho) * seq_mean(bckg);
    % new deviation
    seq_std(bckg) = sqrt(rho * ((double(seq{f}(bckg)) - seq_mean(bckg)).^2) + (1 - rho) * (seq_std(bckg).^2));
    
    % We pick as foreground those pixels which differ too much from the mean
    estimation = ~bckg;
    if(strcmp(color_space,'RGB'))
        estimation = max(estimation,[],3);
    elseif(strcmp(color_space,'HSV'))
        %% If the next two lines uncommented and the last commented -> Model 2. Opposite -> Model 1.
%         H_foregroud = estimation(:,:,1);
%         estimation = H_foregroud;
        estimation = max(estimation,[],3);
    elseif(strcmp(color_space,'YUV'))
        %% If the next two lines uncommented and the last commented -> Model 2. Opposite -> Model 1.
%         UV_foregroud = estimation(:,:,[2,3]);
%         estimation = max(UV_foregroud,[],3);
        estimation = max(estimation,[],3);
    end
    foreEstim{f-seq_starting_test+1} = estimation;
    
    if show_videos
        if(strcmp(color_space,'HSV'))
            input_to_show = hsv2rgb(double(seq{f})/255);
        elseif(strcmp(color_space,'YUV'))
            input_to_show = ycbcr2rgb(seq{f});
        else
            input_to_show = seq{f};
        end
        
        
        subplot(2,2,1)
        imshow(foreEstim{f-seq_starting_test+1})
        subplot(2,2,2)
        imshow(input_to_show)
        
        if(strcmp(color_space,'HSV'))
            seq_mean_to_show = 255*hsv2rgb(double(seq_mean)/255);
            seq_std_to_show = 255*hsv2rgb(double(seq_std)/255);
        elseif(strcmp(color_space,'YUV'))
            seq_mean_to_show = ycbcr2rgb(uint8(seq_mean));
            seq_std_to_show = ycbcr2rgb(uint8(seq_std));
        else
            seq_mean_to_show = seq_mean;
            seq_std_to_show = seq_std;
        end
        
        subplot(2,2,3)
        imshow(uint8(seq_mean_to_show))
        subplot(2,2,4)
        imshow(uint8(seq_std_to_show))
        pause(0.001);
    end
    
end