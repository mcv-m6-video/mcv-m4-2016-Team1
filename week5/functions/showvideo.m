
function showvideo(seq_traffic,seq_traffic_stab,gt_traffic,gt_traffic_stab)

    for i=1:length(seq_traffic_stab)
        subplot(2,2,1)
        imshow(seq_traffic{i});
        title('Original Seq')
        subplot(2,2,2)
        imshow(seq_traffic_stab{i});
        title('Stabilized Seq')
        subplot(2,2,3)
        imshow(gt_traffic{i})
        title('Original Groundtruth')
        subplot(2,2,4)
        imshow(gt_traffic_stab{i})
        title('Stabilized Groundtruth')
        pause(0.1)
    end
    
end