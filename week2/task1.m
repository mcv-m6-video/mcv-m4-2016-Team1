function [foreEstim, seq_starting_test, seq_length] = task1(seq,alpha)

% parameters
alpha = 1;
 
% total elements in the sequence for training
seq_length = length(seq);
seq_starting_test = round(seq_length/2) + 1; % first frme for test

% dimensions of each frame (for future 3d)
dims = ndims(seq{1});

M = cat(dims+1,seq{1:round(seq_length/2)});
seq_mean = mean(M,dims+1);
seq_std = std(double(M),0,dims+1);
clear M;

for f = seq_starting_test : seq_length
       
    % We pick as foreground those pixels which differ too much from the mean
    foreEstim{f-seq_starting_test+1} = (double(seq{f}) - seq_mean) >= alpha.*(seq_std + 2); 
    subplot(2,2,1)
    imshow(foreEstim{f-seq_starting_test+1})
    subplot(2,2,2)
    imshow(seq{f})
    
    subplot(2,2,3)
    imshow(uint8(seq_mean))
    subplot(2,2,4)
    imshow(uint8(seq_std))
    pause();

    
    
%     imshow(~F{f});
%     pause;
    
%     % We pick as background those pixels which are similar mean
%     B(f) = (double(seq{f}) - seq_mean) < alpha.*(seq_std+2);
%     imshow(B(f));
%     pause;
    
%     Total(f) = F(f) + B(f);
%     imshow(Total(f));
%     pause;
end