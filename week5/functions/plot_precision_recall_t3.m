function [] = plot_precision_recall_t3(Recall_h, Recall_f, Recall_t, Precision_h, Precision_f, Precision_t)    

fprintf('\nPlotting Precision vs Recall...\n')
    
    figure()
    subplot(1,3,1)
    plot(Recall_h,Precision_h,'b')
    xlim([0 1])
    title('Highway: Prec vs Rec depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,2)
    plot(Recall_f,Precision_f,'r')
    xlim([0 1])
    title('Fall: Prec vs Rec depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')

    subplot(1,3,3)
    plot(Recall_t,Precision_t,'g')
    xlim([0 1])
    title('Traffic: Prec vs Rec depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')
    
   