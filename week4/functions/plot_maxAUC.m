
function plot_maxAUC(K_h,max_AUC_h,K_f,max_AUC_f,K_t,max_AUC_t)

figure(1)
plot(K_h,max_AUC_h,K_f,max_AUC_f,K_t,max_AUC_t)
xlabel('Number of Gaussians')
ylabel('AUC')
legend('Highway','Fall','Traffic')
title('AUC vs Num Gaussians')