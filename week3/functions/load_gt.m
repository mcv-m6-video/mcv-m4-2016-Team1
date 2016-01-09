
function [gt_input_highway,gt_input_fall,gt_input_traffic] = load_gt()

    % Ground Truth
    folderHName_gt='../highway/groundtruth/*.png';
    fileHSet_gt=dir(folderHName_gt);

    folderFName_gt='../fall/groundtruth/*.png';
    fileFSet_gt=dir(folderFName_gt);

    folderTName_gt='../traffic/groundtruth/*.png';
    fileTSet_gt=dir(folderTName_gt);

    %GROUNDTRUTH
    for i=1:length(fileHSet_gt)
        gt_input_highway{i}=imread(strcat('../highway/groundtruth/',fileHSet_gt(i).name));
    end

    for i=1:length(fileFSet_gt)
        gt_input_fall{i}=imread(strcat('../fall/groundtruth/',fileFSet_gt(i).name));
    end

    for i=1:length(fileTSet_gt)
        gt_input_traffic{i}=imread(strcat('../traffic/groundtruth/',fileTSet_gt(i).name));
    end