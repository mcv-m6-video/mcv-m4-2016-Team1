close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options
doTask1 = false;         % Gaussian function to evaluate background
show_videos_1 = false;  % (From Task1) show back- foreground videos
doTask2 = true;         % (From Task1) TP, TN, FP, FN, F1score vs alpha
doTask3 = true;         % (From Task1) Precision vs recall, AUC

doTask4 = false;        % Adaptive modelling
show_videos_4 = false;  % (From Task4) show back- foreground videos
doTask5 = true;

doTask6 = true;
task6_video = 'highway'; % 'fall' 'traffic'
evaluate_6 = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Parameters
addpath(genpath('.'));

global seq_input_highway
global seq_input_fall
global seq_input_traffic
global gt_input_highway
global gt_input_fall
global gt_input_traffic

% Original Frames
folderHName_input='../highway/input/*.jpg';
fileHSet_input=dir(folderHName_input);

folderFName_input='../fall/input/*.jpg';
fileFSet_input=dir(folderFName_input);

folderTName_input='../traffic/input/*.jpg';
fileTSet_input=dir(folderTName_input);

% Ground Truth
folderHName_gt='../highway/groundtruth/*.png';
fileHSet_gt=dir(folderHName_gt);

folderFName_gt='../fall/groundtruth/*.png';
fileFSet_gt=dir(folderFName_gt);

folderTName_gt='../traffic/groundtruth/*.png';
fileTSet_gt=dir(folderTName_gt);

%Load all entire sequence
%INPUT
for i=1:length(fileHSet_input)
    seq_input_highway{i}=rgb2gray(imread(strcat('../highway/input/',fileHSet_input(i).name)));
end

for i=1:length(fileFSet_input)
    seq_input_fall{i}=rgb2gray(imread(strcat('../fall/input/',fileFSet_input(i).name)));
end

for i=1:length(fileTSet_input)
    seq_input_traffic{i}=rgb2gray(imread(strcat('../traffic/input/',fileTSet_input(i).name)));
end


%GROUNDTRUTH
for i=1:length(fileHSet_input)
    gt_input_highway{i}=imread(strcat('../highway/groundtruth/',fileHSet_gt(i).name));
end

for i=1:length(fileFSet_input)
     gt_input_fall{i}=imread(strcat('../fall/groundtruth/',fileFSet_gt(i).name));
end

for i=1:length(fileTSet_input)
    gt_input_traffic{i}=imread(strcat('../traffic/groundtruth/',fileTSet_gt(i).name));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-recursive Gaussian modeling
if doTask1
    %% TASK 1
    disp('--------TASK 1--------');
    
    %alpha = [0.1:0.1:5];
    alpha = [0:1:5];

    for i = 1:length(alpha)
    
        [forEstim_highway, t1_h,t2_h]= task1(seq_input_highway,alpha(i), show_videos_1);
        [forEstim_fall,t1_f,t2_f] = task1(seq_input_fall,alpha(i), show_videos_1);
        [forEstim_traffic,t1_t,t2_t]= task1(seq_input_traffic,alpha(i), show_videos_1);

        if (doTask2 || doTask3)
            
            % Evaluation functions for TASK 1 (TASK 2 and TASK 3)
            [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
            [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
            [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));

        end

    end

    %% TASK 2
    if doTask2
        
        disp('--------TASK 2--------');
        % Plot TP, TN, FP, FN
        plot_metrics_t2(alpha, TP_h, TP_f, TP_t, TN_h, TN_f, TN_t, FP_h, FP_f, FP_t, FN_h, FN_f, FN_t);
                
        % Plot F1 Score
        plot_f1_t2(alpha, F1_h, F1_f, F1_t);
            
    end

    %% TASK 3
    if doTask3
        
        disp('--------TASK 3--------');
        % Plot Precision VS Recall
        plot_precision_recall_t3(Recall_h, Recall_f, Recall_t, Precision_h, Precision_f, Precision_t);
    
        % Calculate the area under the curve
        Area_h = trapz(flip(Recall_h), Precision_h);
        disp(['Area under the curve for the Highway: ', num2str(Area_h)])

        Area_f = trapz(flip(Recall_f), Precision_f);
        disp(['Area under the curve for the Fall: ', num2str(Area_f)])

        Area_t = trapz(flip(Recall_t), Precision_t);
        disp(['Area under the curve for the Traffic: ', num2str(Area_t)])
    end


    
end % of task1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 4: Adaptive modeling
if doTask4

    disp('--------TASK 4--------');
    
    alpha = [0.1:0.25:1];
    ro = [0:1:4];
    
    total = length(alpha) * length(ro); 
    parts = round(total / 10);
    total = total / 100;
    current = 1;
    
    disp('Iterating over alpha and ro...');
    for i = 1:length(alpha)
        for j = 1:length(ro)

            if mod(current, parts) == 0
                disp([num2str(round(current/total)), '%.. '])
            end
            current = current + 1;
            
            [forEstim_highway,t1_h,t2_h]= task4(seq_input_highway, alpha(i), ro(j), show_videos_4);
            [forEstim_fall,t1_f,t2_f] = task4(seq_input_fall, alpha(i), ro(j), show_videos_4);
            [forEstim_traffic,t1_t,t2_t]= task4(seq_input_traffic, alpha(i), ro(j), show_videos_4);

            %% Evaluation functions for TASK 4 (TASK 2 and TASK 3)
            [TP_h(i,j), FP_h(i,j), FN_h(i,j), TN_h(i,j), Precision_h(i,j), Accuracy_h(i,j), Specificity_h(i,j), Recall_h(i,j), F1_h(i,j)] = task2(forEstim_highway,gt_input_highway(t1_h:end));
            [TP_f(i,j), FP_f(i,j), FN_f(i,j), TN_f(i,j), Precision_f(i,j), Accuracy_f(i,j), Specificity_f(i,j), Recall_f(i,j), F1_f(i,j)] = task2(forEstim_fall,gt_input_fall(t1_f:end));
            [TP_t(i,j), FP_t(i,j), FN_t(i,j), TN_t(i,j), Precision_t(i,j), Accuracy_t(i,j), Specificity_t(i,j), Recall_t(i,j), F1_t(i,j)] = task2(forEstim_traffic,gt_input_traffic(t1_t:end));

        end
    end
    
    if doTask5
        %% Plot data for Task 5:

        % Plot TP, TN, FP, FN:
        plot_surfs_t5(ro, alpha, TP_h, TP_f, TP_t, 'True Positives');
        plot_surfs_t5(ro, alpha, TN_h, TN_f, TN_t, 'True Negatives');
        plot_surfs_t5(ro, alpha, FP_h, FP_f, FP_t, 'False Positives');
        plot_surfs_t5(ro, alpha, FN_h, FN_f, FN_t, 'False Negatives');
        close all;

        % Plot F1 Score
        plot_surfs_t5(ro, alpha, F1_h, F1_f, F1_t, 'F 1 score');
        plot_precision_recall_t3(Recall_h, Recall_f, Recall_t, Precision_h, Precision_f, Precision_t)    

        pause;

        [max_AUC_h, best_ro_index_h] = calculate_best_ro(Recall_h, Precision_h);
        [max_AUC_f, best_ro_index_f] = calculate_best_ro(Recall_f, Precision_f);
        [max_AUC_t, best_ro_index_t] = calculate_best_ro(Recall_t, Precision_t);

        disp(['Area under the curve for the Highway: ', num2str(max_AUC_h), ' with ro = ', num2str(ro(best_ro_index_h))])
        disp(['Area under the curve for the Fall: ', num2str(max_AUC_f), ' with ro = ', num2str(ro(best_ro_index_f))])
        disp(['Area under the curve for the Traffic: ', num2str(max_AUC_t), ' with ro = ', num2str(ro(best_ro_index_t))])

    end % doTask5
    
    fprintf('\n\nTask 4 done.\n\n')
end %end task4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 6: Stauffer and Grimson implementation

if doTask6
    disp('-------- TASK 6 --------');
    
    
    % Load the parameters. Some of them are specific for each scene
    [Alpha, T1, T2, K, Rho, THFG] = load_parameters_t6(task6_video);
    
    % Run the S&G implementation for the given parameters
    fprintf('Running S&G implementation...\n');
    [Sequence] = MultG_fun(Alpha, T1, T2, K, Rho, THFG, task6_video);
    
    % Show estimated scene
    if show_video_6
        
        % Quick preview
        for p = 1:((T2-T1)/2)    
            imshow(Sequence(:,:,p*2));
            pause(0.001)
        end
        
        % Slow visualisation
%         for p = 1:(T2-T1)    
%             imshow(Sequence(:,:,p));
%             pause(0.01)
%         end
    end
    
    
    if evaluate_6
        
    % Aquí faltarà fer l'avaluació per a la configuració S&G concreta.
    % Es poden carregar els paràmetres un cop i despés executar-ho per a
    % differents Alphas com feiem amb la task1 i la task4, de manera que
    % podrem tenir gràfics més complerts sobre l'evolució dels resultats en
    % funció de alpha, però recordeu que aquest model també varia en funció
    % dels altres paràmetres modificables a load_parameters_t6. Aquests
    % paràmetres també tindran un rendiment MOLT diferent en funció del
    % video que fem servir. Cal entrendre bé que:
    %
    %   Alhpa és el threshold de N de desviació estandard on acceptem que
    %   un pixel pertany a una gaussiana (1-4), veure surfs en tasca 4.
    %
    %   K és el nombre de gaussianes que defineixen un sol pixel. Nosaltres
    %   en teníem tan sols una, ara en tindrem de 3 a 6, definint per
    %   exemple blancs saturats i verds foscos si en un punt hi ha sovint
    %   una fulla que es mou i deixa sovint un tros de cel blanc lluent.
    %
    %   Rho és com a task 4 el pes que té l'ultima deteccio de background
    %   en aquell punt, és a dir, com més gran, més ràpid aprenem el nou
    %   background. Si el foreground es detecta com a background i
    %   l'aprenem com a tal, ja no ho arreglarem mai, i quan torni el
    %   background l'entendrem com a foreground i mai el reaprendrem bé.
    %   Per tant, controlar que no sigui massa gran.
    %
    %   THFG no recordo haver-lo relacionat amb cap concepte teòric, però
    %   sembla que sobre 0.25 va bé.
    %
    % HAVE FUN!
   
    end    
    
    
    fprintf('\nTask 6 done.\n')
end % task 6




fprintf('\n FINISHED.\n')