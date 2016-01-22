function [seq_traffic] = load_seqs_adobe()

% Original Frames
folderTName_input='../traffic_stab_adobe/*.jpg';
fileTSet_input=dir(folderTName_input);

%% TRAFFIC

seq_traffic = cell(1,length(fileTSet_input));
for i=1:length(fileTSet_input)
    seq_traffic{i}=imread(strcat('../traffic_stab_adobe/',fileTSet_input(i).name));
end

