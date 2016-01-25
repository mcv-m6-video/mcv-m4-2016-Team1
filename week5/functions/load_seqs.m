
function [seq_highway, gt_highway, seq_traffic, gt_traffic] = load_seqs(color_space)

% Original Frames
folderTName_input='../highway/input/*.jpg';
fileTSet_input=dir(folderTName_input);

%% HIGHWAY

seq_highway = cell(1,length(fileTSet_input));
for i=1:length(fileTSet_input)
    seq_highway{i}=imread(strcat('../highway/input/',fileTSet_input(i).name));
    if(strcmp(color_space,'Gray'))
        seq_highway{i}=rgb2gray(seq_highway{i});
    elseif(strcmp(color_space,'HSV'))
        seq_highway{i}=uint8(255*rgb2hsv(seq_highway{i}));
    elseif(strcmp(color_space,'YUV'))
        seq_highway{i}=rgb2ycbcr(seq_highway{i});
    end
end

%% Ground Truth HIGHWAY
folderTName_gt='../highway/groundtruth/*.png';
fileTSet_gt=dir(folderTName_gt);
gt_highway = cell(1,length(fileTSet_gt));

for i=1:length(fileTSet_gt)
    gt_highway{i}=imread(strcat('../highway/groundtruth/',fileTSet_gt(i).name));
end

% Original Frames
folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);

%% TRAFFIC

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

%% Ground Truth TRAFFIC
folderTName_gt='../traffic/groundtruth/*.png';
fileTSet_gt=dir(folderTName_gt);
gt_traffic = cell(1,length(fileTSet_gt));

for i=1:length(fileTSet_gt)
    gt_traffic{i}=imread(strcat('../traffic/groundtruth/',fileTSet_gt(i).name));
end

