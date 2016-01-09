function [] = plot_f1_t2 (alpha, F1_h, F1_f, F1_t)

fprintf('\nPlotting F1 Scores...')
figure(2)
plot(alpha, F1_h, alpha, F1_f, alpha, F1_t)
xlabel('Alpha')
ylabel('F1')
legend('F1 Highway','F1 Fall','F1 Traffic')
title('F1 Score')