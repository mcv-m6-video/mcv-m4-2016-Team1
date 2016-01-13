function seq_without_shadows = remove_shadows(seq_estimated_foregrounds, seq_original, seq_mean, color_space)
    assert(length(seq_estimated_foregrounds)==length(seq_original));
    
    global params;
    
    if strcmp(color_space,'RGB')
        seq_mean = rgb2hsv(seq_mean)/255;
    elseif strcmp(color_space,'YUV')
        seq_mean = ycbcr2rgb(seq_mean);
        seq_mean = rgb2hsv(seq_mean)/255;
    elseif strcmp(color_space,'Gray')
        disp('You must provide a color space multichannel!!');
        return
    end

    seq_without_shadows = cell(1,length(seq_estimated_foregrounds));
    for i=1:length(seq_estimated_foregrounds)
        estimation = seq_estimated_foregrounds{i};
        image = seq_original{i};
        if strcmp(color_space,'RGB')
            image = rgb2hsv(image);
        elseif strcmp(color_space,'YUV')
            image = ycbcr2rgb(image);
            image = rgb2hsv(image);
        elseif strcmp(color_space,'Gray')
            disp('You must provide a color space multichannel!!');
            return
        end
        I_H = image(:,:,1);
        I_S = image(:,:,2);
        I_V = image(:,:,3);
        
        B_H = seq_mean(:,:,1);
        B_S = seq_mean(:,:,2);
        B_V = seq_mean(:,:,3);
        
        Vdiv = I_V./B_V;
        cond1 = Vdiv>=params.SR_alpha & Vdiv<=params.SR_beta;
        cond2 = abs(I_H-B_H)<=params.SR_tauH;
        cond3 = (I_S-B_S)<=params.SR_tauS;
        
        seq_without_shadows{i} = estimation & ~(cond1 & cond2 & cond3);
        
        figure(1)
        subplot(1,3,1)        
        imshow(estimation)
        title('estimation 0')
        subplot(1,3,2)
        imshow(seq_without_shadows{i})
        title('estimation without shadows')
        subplot(1,3,3)        
        imshow(seq_original{i})
        title('original')
        pause
%         figure(3)
%         imshow(cond1 & cond2 & cond3);
%         pause;
        
        
    end



end