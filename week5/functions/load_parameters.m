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

    
    %% Task 5
    params.alpha = 1.8;
    params.P = 390;
    params.fill_conn = 4;
    params.opening = 10;%10;  
    params.closing = 15;%15;
    
    
end