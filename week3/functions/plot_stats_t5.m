function [] = plot_stats_t5(alpha, data_h, data_f, data_t, label)

    % I want to split 'TRUE POSITIVE' into two cells 'TRUE' and 'POSITIVE'
    
    % READ CAREFULLY THE COMMENTS
    % words = strsplit(label, ' '); use with new matlab
    words = strread(label, '%s'); % working in old matlab
    
    % words = textscan('True Positive', '%s') % working everywhere, but
    % then needs to use:
    % tag = [words{1}{1}(1), words{1}{2}(1)]; 
    
    % I want to take the T and the P to obtain "TP"
    tag = [words{1}(1), words{2}(1)];
    
    disp(['Plotting ', label])
    figure(1)
    hold on
    plot(alpha, data_h, alpha, data_f, alpha, data_t)
    xlabel('TP')
    xlabel('Alpha')

    legend([tag, ' Highway'],[tag, ' Fall'],[tag, ' Traffic'])
    title([label])