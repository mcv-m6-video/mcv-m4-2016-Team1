close all
clear all
clc

show_plots = false;

%% TRAFFIC
% Original Frames
folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);
color_space = 'Gray';

seq_traffic = cell(1,length(fileTSet_input));
for i=1:length(fileTSet_input)
    seq_traffic{i}=imread(strcat('../traffic/input/',fileTSet_input(i).name));
    if(strcmp(color_space,'Gray'))
        seq_traffic{i}=rgb2gray(seq_traffic{i});
    elseif(strcmp(color_space,'HSV'))
        seq_traffic{i}=uint8(255*rgb2hsv(seq_traffic{i}));
    elseif(strcmp(color_space,'YUV'))
        seq_traffic{i}=rgb2ycbcr(seq_traffic{i});
    end
end
%%

seq_traffic_stab = cell(size(seq_traffic));

% Process all frames in the video
movMean = seq_traffic{1};
imgB = movMean;
imgBp = imgB;
correctedMean = imgBp;
ii = 2;
Hcumulative = eye(3);
while ii<length(seq_traffic)
    % Read in new frame
    imgA = imgB; % z^-1
    imgAp = imgBp; % z^-1
    imgB = seq_traffic{ii};
    movMean = movMean + imgB;

    % Estimate transform from frame A to frame B, and fit as an s-R-t
    H = cvexEstStabilizationTform(imgA,imgB);
    HsRt = cvexTformToSRT(H);
    Hcumulative = HsRt * Hcumulative;
    imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));
    seq_traffic_stab{ii}=imgBp;

    % Display as color composite with last corrected frame
    %step(hVPlayer, imfuse(imgAp,imgBp,'ColorChannels','red-cyan'));
    correctedMean = correctedMean + imgBp;

    ii = ii+1;
end
correctedMean = correctedMean/(ii-2);
movMean = movMean/(ii-2);