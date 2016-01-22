
function [seq_traffic, gt_traffic, seq_kitti45, seq_kitti157, gt_kitti45, gt_kitti157] = load_seqs(color_space)

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

%% KITTI
seq_kitti45{1} = imread('../data_stereo_flow/training/colored_0/000045_10.png');
seq_kitti45{2} = imread('../data_stereo_flow/training/colored_0/000045_11.png');

seq_kitti157{1} = imread('../data_stereo_flow/training/colored_0/000157_10.png');
seq_kitti157{2} = imread('../data_stereo_flow/training/colored_0/000157_11.png');

% Note that we read the flows with flow_read function.
gt_kitti45 = flow_read('../data_stereo_flow/training/flow_noc/000045_10.png');
gt_kitti157 = flow_read('../data_stereo_flow/training/flow_noc/000157_10.png');
