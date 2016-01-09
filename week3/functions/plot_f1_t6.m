function [] = plot_f1_t6 (K, F1_h, F1_f, F1_t)

fprintf('\nPlotting F1 Scores...')
figure(2)
plot(K, F1_h, K, F1_f, K, F1_t)
xlabel('Num Gaussians')
ylabel('F1')
legend('F1 Highway','F1 Fall','F1 Traffic')
title('F1 Score')