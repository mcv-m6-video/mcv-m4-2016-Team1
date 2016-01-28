function [foreEstim, seq_starting_test, seq_mean] = backgroundSubstraction(seq, alpha, P, conn, open, close, show_videos, color_space)
global params;

% total elements in the sequence for training
seq_length = length(seq);
seq_starting_test = round(seq_length/2) + 1; % first frame for test

% dimensions of each frame (for future 3d)
dims = ndims(seq{1});

M = cat(dims+1,seq{1:round(seq_length/2)});
seq_mean = mean(M,dims+1);
seq_std = std(double(M),0,dims+1);
clear M;

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
seq_starting_test = 1;
for f = seq_starting_test : seq_length
    
    % We pick as foreground those pixels which differ too much from the mean
    estimation = abs(double(seq{f}) - seq_mean) >= alpha.*(seq_std + 2);
    
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
        
        if params.fill_conn==0
            foreEstim{f-seq_starting_test+1} = estimation;
        else
            foreEstim{f-seq_starting_test+1} = imfill(estimation,conn,'holes');
            if P ~= 0
                foreEstim{f-seq_starting_test+1} = bwareaopen(foreEstim{f-seq_starting_test+1},P);
            end
            if params.closing ~= 0
                SE_close = ones(close);
                SE_open = ones(open);
                foreEstim_base = foreEstim;
                foreEstim_open{f-seq_starting_test+1}       = imopen(foreEstim{f-seq_starting_test+1}, SE_open);
                foreEstim_open_close{f-seq_starting_test+1} = imclose(foreEstim_open{f-seq_starting_test+1}, SE_close);
                foreEstim{f-seq_starting_test+1} = foreEstim_open_close{f-seq_starting_test+1};
            end
            foreEstim{f-seq_starting_test+1} = imfill(foreEstim{f-seq_starting_test+1},conn,'holes');
            foreEstim{f-seq_starting_test+1} = imerode(foreEstim{f-seq_starting_test+1},strel('diamond',3));
        end
        
        if show_videos
            subplot(2,2,1)
            imshow(foreEstim_base{f-seq_starting_test+1});
            subplot(2,2,2)
            if(strcmp(color_space,'HSV'))
                input_to_show = hsv2rgb(double(seq{f})/255);
            elseif(strcmp(color_space,'YUV'))
                input_to_show = ycbcr2rgb(seq{f});
            else
                input_to_show = seq{f};
            end
            imshow(input_to_show)
            
            subplot(2,2,3)
            %imshow(uint8(seq_mean_to_show))
            imshow(foreEstim_open{f-seq_starting_test+1})
            title('Openning')
            subplot(2,2,4)
%             imshow(uint8(seq_std_to_show))
            imshow(foreEstim_open_close{f-seq_starting_test+1})
            title('Openning & Clossing')
            pause(0.001);
        end
        
end
end