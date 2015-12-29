function [foreEstim, seq_starting_test, seq_length] = task4(seq,alpha,ro)

% parameters
%alpha = 0.8;
%ro = 0.03;
 
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
       
    % For those pixels which are background, 
    
    
    %seq_mean = ((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2)) .* (ro * seq{f} + (1 - ro) * seq_mean);
    % the bckg mask has the pixels which are similar enough to the mean
    bckg = double(seq{f}) - seq_mean < alpha .* (seq_std + 2);
%     imshow(bckg);
%     pause;
%     imshow(uint8(bckg))
%     pause;
    
    % new mean for bckg pixels is updated using a ro regularizer
    seq_previous = seq_mean;
    seq_mean(bckg) = ro * double(seq{f}(bckg)) + (1 - ro) * seq_mean(bckg);
    % new deviation
    seq_std(bckg) = sqrt(ro * ((double(seq{f}(bckg)) - seq_mean(bckg)).^2) + (1 - ro) * (seq_std(bckg).^2));
     
    
    %seq_mean( (double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1) = (ro * seq{f} + (1 - ro) * seq_mean((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1));
    %seq_std((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1) = ((double(seq{f}) - seq_mean) < alpha.*(seq_std((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1) + 2)) .* (ro * (seq{f} - seq_mean((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1)).^2 + (1 - ro) * seq_std((double(seq{f}) - seq_mean) < alpha.*(seq_std + 2) == 1).^2);

    % We pick as foreground those pixels which differ too much from the mean
    foreEstim{f-seq_starting_test+1} = (double(seq{f}) - seq_mean) >= alpha.*(seq_std + 2); 
        
%     subplot(2,2,1)
%     imshow(foreEstim{f-seq_starting_test+1})
%     subplot(2,2,2)
%     imshow(seq{f})
%     
%     subplot(2,2,3)
%     imshow(uint8(seq_mean))
%     subplot(2,2,4)
%     imshow(uint8(seq_std))
%     pause(0.001);

    
    
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