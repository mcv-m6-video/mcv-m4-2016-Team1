function params = load_parameters()
    
%     params.alpha = [0:0.5:5];
%    params.alpha = 1.8;
    params.showvideos1 = false;
    params.fill_conn = 0;           % could be 0 (no imfill), 4 or 8
    params.FM = 0;

    params.alpha = [0:0.2:7]; %best
    params.fill_conn = 8;           % could be 0 (no imfill), 4 or 8
    params.opening = 0;%10;  
    params.closing = 0;%15;

    % size of the objects to be detected
%     params.P = [20:50:400];         % highway 90, other 390.
    params.P = 0;%[390];         % highway 90, other 390.
    
%     params.SR_alpha = 0.2;
%     params.SR_beta = 0.7;
%     params.SR_tauH = 0.5;
%     params.SR_tauS = 0.2;
    
    % paper
    params.SR_alpha = 0.4;
    params.SR_beta = 0.6;
    params.SR_tauH = 0.5;
    params.SR_tauS = 0.1;

end