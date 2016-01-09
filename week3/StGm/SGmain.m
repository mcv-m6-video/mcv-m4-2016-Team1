%% Main for the S&G implementation tests

Threshold = 2.5; % like our alpha ~ 2
T1 = 1050;  % initial frame. H: 1050 F: 1460 T: 950
T2 = 1150;  % ending frame   H: 1350 F: 1560 T: 1050
K = 3;      % accepted from 3 to 6 
Rho = 0.1;  % Rho as in our implementation ~ 0.1
THFG = 0.25;     % of weights corresponding to foreground objects
video = 'highway'; % 'fall' 'traffic'

[Sequence] = MultG_fun(Threshold,T1,T2,K,Rho,THFG,video);

disp('Done')

for p = 1:((T2-T1)/2)    
    imshow(Sequence(:,:,p*2));
    pause(0.001)
end

