function save_sequence(sequence, name, frame_rate)
disp(['Writing sequence ',name])
v = VideoWriter(name,'Uncompressed AVI');
v.FrameRate = frame_rate;
open(v);
for i=1:length(sequence)
%     im = flip(sequence{i},1);
    writeVideo(v,im2uint8(sequence{i}));    
end
close(v);
implay([name,'.avi']);

end