function [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelRecall, F1] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    % PerformanceEvaluationPixel
    % Function to compute different performance indicators (Precision, accuracy, 
    % specificity, sensitivity) at the pixel level
    %
    % [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'pixelTP'           Number of True  Positive pixels
    %    'pixelFP'           Number of False Positive pixels
    %    'pixelFN'           Number of False Negative pixels
    %    'pixelTN'           Number of True  Negative pixels
    %
    % The function returns the precision, accuracy, specificity and sensitivity
    
    % Compute precision, accuracy, specificity and recall
    pixelPrecision = pixelTP / (pixelTP+pixelFP);
    pixelAccuracy = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
    pixelSpecificity = pixelTN / (pixelTN+pixelFP);
    pixelRecall = pixelTP / (pixelTP+pixelFN);
    
    % Return the F1 score
    F1 = 2*pixelPrecision*pixelRecall/(pixelPrecision+pixelRecall);
end
