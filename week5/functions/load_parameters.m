function params = load_parameters()
    %% Task 1
    params.maxblock_disp_i = 50;
    params.i_step = 2;
    params.maxblock_disp_j = 50;
    params.j_step = 2;
    params.block_size = [16,16];
    params.block_error_cost = 'MSE'; % 'MSE', 'Hists'
    params.verbose_block_matching = false;
    params.verbose_stabilization = true;
    params.hist_bins = 64;
    
    %% Task 2
    params.tau = 3;
    
    %% Task 3
    % equation of lines: y = a*x + b
    params.a0=0; % Keep it at 0 please
    params.b0=240-100;
    params.a1=0; % Keep it at 0 please
    params.b1=220;
    
    params.pixXframe2kmXh_highway = 15.0;
    params.pixXframe2kmXh_traffic = 7.0;

    
    %% Task 5
    params.alpha = 1.6;
    params.P = 90;
    params.fill_conn = 4;
    params.opening = 3;%10;  
    params.closing = 11;%15;
    
    % Params for 20kmh video
    params.alpha_20kmh = 0.2;
    params.P_20kmh = 200;
    params.fill_conn_20kmh = 4;
    params.opening_20kmh = 11;
    params.closing_20kmh = 51;
    
    % Params for 30kmh video
    params.alpha_30kmh = 0.2;
    params.P_30kmh = 50;
    params.fill_conn_30kmh = 4;
    params.opening_30kmh = 11;
    params.closing_30kmh = 25;
    
    % Params for 50kmh video
    params.alpha_50kmh = 0.2;
    params.P_50kmh = 200;
    params.fill_conn_50kmh = 4;
    params.opening_50kmh = 11;
    params.closing_50kmh = 51;
    
    
    % Compute velocity
    params.a0_OwnVideo = 0; % Keep it at 0 please
    params.b0_OwnVideo = 110;
    params.a1_OwnVideo = 0; % Keep it at 0 please
    params.b1_OwnVideo = 220;
    
    params.pixXframe2kmXh_OwnVideo = 9.0;
    
    params.save_tracking_video = true;
    
end