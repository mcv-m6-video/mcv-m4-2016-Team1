function params = load_parameters()
    
% Best configuraion for P = 90 for highway and P = 390 for fall and
% traffic.

    params.alpha = [0:0.5:5];
    params.showvideos1 = false;
    params.fill_conn = 4; % could be 0 (no imfill), 4 or 8
    params.P = [20:20:400];
end