function [] = plot_PR_Combined(Recall_h, Recall_f, Recall_t, Precision_h, Precision_f, Precision_t)    

    fprintf('\nPlotting Combined PR...\n')

    Recall = (Recall_h + Recall_f + Recall_t) / 3;
    Precision = (Precision_h + Precision_f + Precision_t) / 3;

    figure()

    plot(Recall_h,Precision_h,'b')
    xlim([0 1])
    title('Prec vs Rec depending on Alpha')
    xlabel('Recall')
    ylabel('Precision')
    
    hold on;

    plot(Recall_f,Precision_f,'r')
    plot(Recall_t,Precision_t,'g')
    
    plot(Recall,Precision,'--')    
    
    hold off;
    
end