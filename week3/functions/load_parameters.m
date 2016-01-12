function params = load_parameters()
    
%     params.alpha = [0:0.5:5];
    params.alpha = [0:2:5];
    params.showvideos1 = false;
    params.fill_conn = 4;           % could be 0 (no imfill), 4 or 8
    
    % size of the objects to be detected
%     params.P = [20:50:400];         % highway 90, other 390.
    params.P = [20:100:400];         % highway 90, other 390.
end