function [] = plot_F1_vs_frame(F1_vector)
plot([1:length(F1_vector)], F1_vector); %Plot the energy
xlabel('frame');
ylabel('F1');
end