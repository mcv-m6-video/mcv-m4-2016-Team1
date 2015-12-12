function [] = plot_TP_and_GT_vs_frame(TP_vector_A,TP_vector_B,seq_gt)
assert(length(TP_vector_A)==length(seq_gt));

% Initialize the ground truth positives
GT_P = zeros(1,length(seq_gt));
% Compute all the positives in the ground truth.
for i=1:length(seq_gt)
   GT_P(i) = nnz(seq_gt{i}); 
end

% Plot the {TP_A, TP_B, GT_P} vs frame graphic.
plot(1:length(TP_vector_A), TP_vector_A);
hold on
plot(1:length(TP_vector_B), TP_vector_B);
hold on
plot(1:length(TP_vector_A), GT_P);
legend('TP A','TP B','GT P');
hold off
xlabel('frame');
ylabel('True Positives');

end