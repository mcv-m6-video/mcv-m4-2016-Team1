%% Script just to plot three surfs in separate figures for the 
% corresponding highway, fall and traffic video sequences.
% The 'label' parameter is meant to have at least two words,
% whose first letters are used for the label in the z axis.
% It includes a pause in the end for proper visualisation.
% CAUTION! Different versions of matlab may require a different
% function in lines 16-24, depending on the use of the functions
% strread (removed in last versions), textscan (less efficient)
% or strsplit (only in new versions)

function [] = plot_surfs_t5(ro, alpha, data_h, data_f, data_t, label)

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
    surf(ro,alpha,data_h)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel(tag)
    %legend([tag, ' Highway'])
    title([label, ' HIGHWAY'])
    
    figure(2)
    surf(ro,alpha,data_f)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel(tag)
    %legend([tag, ' Fall'])
    title([label, ' FALL'])
    
    figure(3)
    surf(ro,alpha,data_t)
    xlabel('Ro')
    ylabel('Alpha')
    zlabel(tag)
    %legend([tag, ' Traffic'])
    title([label, ' TRAFFIC'])
    
    pause;