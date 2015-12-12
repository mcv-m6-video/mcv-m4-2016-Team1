
function play_video(seq1,seq2,seq3, seq4, step)

figure(1);

for t=1:step:200
    subplot(2,2,1);
    imshow(seq1{t+1200});
    
    subplot(2,2,2)
    imshow(seq2{t+1200});
    
    subplot(2,2,3);
    imshow(double(seq3{t}));
    
    subplot(2,2,4)
    imshow(double(seq4{t})); 
    pause (0.001);
end

end