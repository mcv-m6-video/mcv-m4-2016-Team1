
function plot_maxF1(K_h,max_F1_h,K_f,max_F1_f,K_t,max_F1_t)

figure(1)
plot(K_h,max_F1_h,K_f,max_F1_f,K_t,max_F1_t)
xlabel('Number of Gaussians')
ylabel('F1 Score')
legend('Highway','Fall','Traffic')
title('F1 vs Num Gaussians')