
function showvideo(seq_traffic,seq_traffic_stab,gt_traffic,gt_traffic_stab)

    for i=1:length(seq_traffic_stab)
        subplot(2,2,1)
        imshow(seq_traffic{i});
        title(['Original Seq ',num2str(i)])
        subplot(2,2,2)
        imshow(seq_traffic_stab{i});
        title(['Stabilized Seq ',num2str(i)])
        subplot(2,2,3)
        imshow(gt_traffic{i})
        title(['Original Groundtruth ',num2str(i)])
        subplot(2,2,4)
        imshow(gt_traffic_stab{i})
        title(['Stabilized Groundtruth ',num2str(i)])
        pause(0.1);
    end
    
end