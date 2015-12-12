
function play_video(seq1,seq2,seq3, seq4, step)

figure(1);

for t=1:step:200
    subplot(2,2,1);
    imshow(seq1{t});
    title('INPUT')
    
    subplot(2,2,2)
    imshow(seq2{t});
    title('GROUND TRUTH')
    
    subplot(2,2,3);
    imshow(double(seq3{t}));
    title('TEST A')
    
    subplot(2,2,4)
    imshow(double(seq4{t})); 
    title('TEST B')
    pause (0.001);
end

end