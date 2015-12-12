
function [TP, TN, FN, FP, Prec, Rec, F1]=result_evaluation(gt,test)

TP = zeros(1,length(gt));
FN = zeros(1,length(gt));
FP = zeros(1,length(gt));

for i = 1 : length(gt)

    diff = test{i} - gt{i};

    [x,y] = find(diff==0);
    
    for j = 1:length(x)
       if gt(x(j),y(j))==0
           TN = TN+1;
       else
           TP = TP+1;
       end
    end
    
    FN = numel(diff == -1);
    FP = numel(diff == 1);

end