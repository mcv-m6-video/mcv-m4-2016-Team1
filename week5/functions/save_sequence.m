function save_sequence(sequence, name)
disp(['Writing sequence ',name])
v = VideoWriter(name,'Uncompressed AVI');
v.FrameRate = 10;
open(v);
for i=1:length(sequence)
    im = flip(sequence{i},1);
    writeVideo(v,im);    
end
close(v);

end