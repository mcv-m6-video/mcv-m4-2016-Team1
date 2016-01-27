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
    
    params.pixXframe2kmXh = 1.0;

    
    %% Task 5
    params.alpha = 1.6;
    params.P = 90;
    params.fill_conn = 4;
    params.opening = 3;%10;  
    params.closing = 11;%15;
    
    
end