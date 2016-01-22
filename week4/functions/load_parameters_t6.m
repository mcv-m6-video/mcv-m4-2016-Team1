function [alpha,T1,T2,K,Rho,THFG] = load_parameters_t6(video)

%% Modifiable parameters to be optmized for each scene
switch (video)
        case 'highway'
            alpha = 0:10;      % like our alpha ~ 2 [1-4]
            K = 3;              % accepted from 3 to 6 
            Rho = 0.015;          % Rho as in our implementation ~ 0.1
            THFG = 0.5;         % of weights corresponding to foreground objects
            
        case 'fall'
            alpha = 0:10;      %[1.5:0.25:4];    % like our alpha ~ 2 [1-4]
            K = 3;              % accepted from 3 to 6 
            Rho = 0.025;          % Rho as in our implementation ~ 0.1
            THFG = 0.5;         % of weights corresponding to foreground objects
            
        case 'traffic'
            alpha = 0:10;      %[1.5:0.25:4];    % like our alpha ~ 2 [1-4]
            K = 3;              % accepted from 3 to 6 
            Rho = 0.014;          % Rho as in our implementation ~ 0.1
            THFG = 0.7;         % of weights corresponding to foreground objects
    
        otherwise
            fprintf('Invalid scene selected [highway, fall, traffic].\n');
end


%% Fix parameters not to be changed
switch (video)
        case 'highway'
            fprintf('Selected %s scene.\n', video)
            T1 = 1050;  % initial frame, do not change.
            T2 = 1350;  % ending frame, do not change.

        case 'fall'
            fprintf('Selected %s scene.\n', video)
            T1 = 1460;  % initial frame, do not change.
            T2 = 1560;  % ending frame, do not change.
            
        case 'traffic'
            fprintf('Selected %s scene.\n', video)
            T1 = 950;  % initial frame, do not change.
            T2 = 1050;  % ending frame, do not change.
end