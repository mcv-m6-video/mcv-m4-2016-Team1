function [max_AUC, best_index] = calculate_best_ro(Recall, Precision)

max_AUC = -inf;
best_index = 1

for i = 1:size(Recall,2)
    
    aux = trapz(flip(Recall(:,i)), Precision(:,i));
    if max_AUC < aux
        max_AUC = aux;
        best_index = i;
    end
end
