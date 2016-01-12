function params = load_parameters()
    
    params.alpha = [0:0.25:8]; %best
    %params.alpha = 1.8;
    params.showvideos1 = false;
    params.fill_conn = 4;           % could be 0 (no imfill), 4 or 8
    params.closing = 10;
    
    % size of the objects to be detected
%     params.P = [20:50:400];         % highway 90, other 390.
    params.P = [390];         % highway 90, other 390.
end