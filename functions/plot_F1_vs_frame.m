function [] = plot_F1_vs_frame(F1_vector_A,F1_vector_B)
F1_vector_A(isnan(F1_vector_A)) = 0;
F1_vector_B(isnan(F1_vector_B)) = 0;

plot(1:length(F1_vector_A), F1_vector_A, 1:length(F1_vector_B), F1_vector_B);
xlabel('frame');
ylabel('F1');
legend('F1 A', 'F1 B');
end