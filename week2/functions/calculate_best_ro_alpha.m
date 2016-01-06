
function [maxF1, rho_indx, alpha_indx] = calculate_best_ro_alpha(F1)

[max1, idx] = max(F1);
[maxF1,rho_indx] = max(max1);
alpha_indx = idx(rho_indx);