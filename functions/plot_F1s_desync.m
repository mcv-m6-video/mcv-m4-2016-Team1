function [] = plot_F1s_desync(F1_vector_A,F1_vector_B, xLabel, yLabel)
% If there is some NaN (given by total lack of detection in one frame),
% put the F1 vector to zeros.
F1_vector_A(isnan(F1_vector_A)) = 0;
F1_vector_B(isnan(F1_vector_B)) = 0;

% Plot the scores for each method (A or B)
plot(0:length(F1_vector_A)-1, F1_vector_A, 0:length(F1_vector_B)-1, F1_vector_B);
xlabel(xLabel);
ylabel(yLabel);
legend('F1 A', 'F1 B');
end