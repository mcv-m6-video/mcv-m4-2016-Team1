
function plot_task2(Area_h,Area_f,Area_t)

    global params

    Area_Average = (Area_h + Area_f + Area_t)/3;
 
    figure(1)    
    plot(params.P,Area_h,'--',params.P,Area_f,'--',params.P,Area_t,'--')
    hold on

    plot(params.P,Area_Average)
    xlabel('P')
    ylabel('Average AUC')
    legend('Highway','Fall','Traffic','Average')
    
    hold off
end