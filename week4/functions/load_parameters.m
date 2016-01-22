function params = load_parameters()
    %% Task 1
    params.maxblock_disp_i = 50;
    params.i_step = 5;
    params.maxblock_disp_j = 100;
    params.j_step = 5;
    params.block_size = [16,16];
    params.block_error_cost = 'MSE'; % 'MSE', 'Hists'
    params.verbose_block_matching = false;
    params.verbose_stabilization = true;
    params.hist_bins = 64;
    
    %% Task 2
    params.tau = 3;
    
    %% Task 3
    params.stv_method = 'non_smooth'; % 'smooth', 'non_smooth'

    
    %% Task 5
    params.alpha = 0:0.2:5;
    params.P = 390;
    params.fill_conn = 4;
    params.opening = 10;%10;  
    params.closing = 15;%15;  
    
    %% Task 6
    params.video='video/jordi_model_2_noaudio.mp4';
    
end