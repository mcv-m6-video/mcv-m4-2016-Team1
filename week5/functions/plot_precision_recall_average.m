
function [] = plot_precision_recall_average(Recall_h, Recall_f, Recall_t, Precision_h, Precision_f, Precision_t) 

figure()
    
    Average_Recall = (Recall_h+Recall_f+Recall_t)/3;
    Average_Precision = (Precision_h+Precision_f+Precision_t)/3;

    plot(Recall_h,Precision_h,'b',Recall_f,Precision_f,'r',Recall_t,Precision_t,'g',Average_Recall,Average_Precision,'b--')
    xlim([0 1])
    title('Prec vs Rec')
    xlabel('Recall')
    ylabel('Precision')
    
    legend('Highway','Fall','Traffic','Average')
