function params = load_parameters()
    
% Best configuraion for P = 90 for highway and P = 390 for fall and
% traffic.

    params.alpha = 2;
    params.showvideos1 = false;
    params.fill_conn = 4; % could be 0 (no imfill), 4 or 8
    params.P = 90;
    
    params.SR_alpha = 0.2;
    params.SR_beta = 0.7;
    params.SR_tauH = 0.5;
    params.SR_tauS = 0.2;
    % paper:
%     params.SR_alpha = 0.4;
%     params.SR_beta = 0.6;
%     params.SR_tauH = 0.5;
%     params.SR_tauS = 0.1;

end