function [TP_counter,FP_counter, FN_counter, TN_counter, Precision, Accuracy, Specificity, Recall, F1] = task2(est,gt)


% Initialize the counters. We will compute TP, TN, FN, FP for each image.
TP_counter=0; TN_counter=0; FN_counter=0; FP_counter=0;

for i = 1 : length(est)
    [TP, FP, FN, TN] = PerformanceAccumulationPixel(est{i},gt{i});
    
    TP_counter=TP_counter+TP; 
    TN_counter=TN_counter+TN; 
    FN_counter=FN_counter+FN; 
    FP_counter=FP_counter+FP;
    
end

[Precision, Accuracy, Specificity, Recall, F1] = PerformanceEvaluationPixel(TP_counter, FP_counter, FN_counter, TN_counter);