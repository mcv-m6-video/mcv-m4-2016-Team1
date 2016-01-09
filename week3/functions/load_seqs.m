
function [seq_input_highway, seq_input_fall, seq_input_traffic] = load_seqs(color_space)

% Original Frames
folderHName_input='../highway/input/*.jpg';
fileHSet_input=dir(folderHName_input);

folderFName_input='../fall/input/*.jpg';
fileFSet_input=dir(folderFName_input);

folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);

%Load all entire sequence
%INPUT
seq_input_highway = cell(length(fileHSet_input));
for i=1:length(fileHSet_input)
    seq_input_highway{i}=imread(strcat('../highway/input/',fileHSet_input(i).name));
    if(strcmp(color_space,'Gray'))
        seq_input_highway{i}=rgb2gray(seq_input_highway{i});
    elseif(strcmp(color_space,'HSV'))
        seq_input_highway{i}=uint8(255*rgb2hsv(seq_input_highway{i}));
    elseif(strcmp(color_space,'YUV'))
        seq_input_highway{i}=rgb2ycbcr(seq_input_highway{i});
    end
    
end

seq_input_fall = cell(length(fileFSet_input));
for i=1:length(fileFSet_input)
    seq_input_fall{i}=imread(strcat('../fall/input/',fileFSet_input(i).name));
    if(strcmp(color_space,'Gray'))
        seq_input_fall{i}=rgb2gray(seq_input_fall{i});
    elseif(strcmp(color_space,'HSV'))
        seq_input_fall{i}=uint8(255*rgb2hsv(seq_input_fall{i}));
    elseif(strcmp(color_space,'YUV'))
        seq_input_fall{i}=rgb2ycbcr(seq_input_fall{i});
    end
    
end

seq_input_traffic = cell(length(fileTSet_input));
for i=1:length(fileTSet_input)
    seq_input_traffic{i}=imread(strcat('../traffic/input/',fileTSet_input(i).name));
    if(strcmp(color_space,'Gray'))
        seq_input_traffic{i}=rgb2gray(seq_input_traffic{i});
    elseif(strcmp(color_space,'HSV'))
        seq_input_traffic{i}=uint8(255*rgb2hsv(seq_input_traffic{i}));
    elseif(strcmp(color_space,'YUV'))
        seq_input_traffic{i}=rgb2ycbcr(seq_input_traffic{i});
    end
end
