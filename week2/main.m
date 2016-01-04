close all;
clear all;
clc;

fprintf('Loading general parameters...\n');

%% Select execution options
doTask1 = true;         % Gaussian function to evaluate background
show_videos_1 = false;  % (From Task1) show back- foreground videos
doTask2 = true;         % (From Task1) TP, TN, FP, FN, F1score vs alpha
doTask3 = true;         % (From Task1) Precision vs recall, AUC

doTask4 = true;        % Adaptive modelling
show_videos_4 = false;  % (From Task4) show back- foreground videos
doTask5 = true;

doTask6 = true;
task6_video = 'highway'; % 'fall' 'traffic'
show_video_6 = false;
doTask7 = true;

compareMethods = false;

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
    alpha = [0.1:0.25:5];

    for i = 1:length(alpha)
    
        [NRGM_forEstim_highway, t1_h]= task1(seq_input_highway,alpha(i), show_videos_1);
        [NRGM_forEstim_fall,t1_f] = task1(seq_input_fall,alpha(i), show_videos_1);
        [NRGM_forEstim_traffic,t1_t]= task1(seq_input_traffic,alpha(i), show_videos_1);

        if (doTask2 || doTask3)
            
            % Evaluation functions for TASK 1 (TASK 2 and TASK 3)
            [NRGM_TP_h(i), NRGM_FP_h(i), NRGM_FN_h(i), NRGM_TN_h(i), NRGM_Precision_h(i), NRGM_Accuracy_h(i), NRGM_Specificity_h(i), NRGM_Recall_h(i), NRGM_F1_h(i)] = task2(NRGM_forEstim_highway,gt_input_highway(t1_h:end));
            [NRGM_TP_f(i), NRGM_FP_f(i), NRGM_FN_f(i), NRGM_TN_f(i), NRGM_Precision_f(i), NRGM_Accuracy_f(i), NRGM_Specificity_f(i), NRGM_Recall_f(i), NRGM_F1_f(i)] = task2(NRGM_forEstim_fall,gt_input_fall(t1_f:end));
            [NRGM_TP_t(i), NRGM_FP_t(i), NRGM_FN_t(i), NRGM_TN_t(i), NRGM_Precision_t(i), NRGM_Accuracy_t(i), NRGM_Specificity_t(i), NRGM_Recall_t(i), NRGM_F1_t(i)] = task2(NRGM_forEstim_traffic,gt_input_traffic(t1_t:end));

        end

    end

    %% TASK 2
    if doTask2
        
        disp('--------TASK 2--------');
        % Plot TP, TN, FP, FN
        plot_metrics_t2(alpha, NRGM_TP_h, NRGM_TP_f, NRGM_TP_t, NRGM_TN_h, NRGM_TN_f, NRGM_TN_t, NRGM_FP_h, NRGM_FP_f, NRGM_FP_t, NRGM_FN_h, NRGM_FN_f, NRGM_FN_t);
                
        % Plot F1 Score
        plot_f1_t2(alpha, NRGM_F1_h, NRGM_F1_f, NRGM_F1_t);
            
    end

    %% TASK 3
    if doTask3
        
        disp('--------TASK 3--------');
        % Plot Precision VS Recall
        plot_precision_recall_t3(NRGM_Recall_h, NRGM_Recall_f, NRGM_Recall_t, NRGM_Precision_h, NRGM_Precision_f, NRGM_Precision_t);
    
        % Calculate the area under the curve
        NRGM_Area_h = trapz(flip(NRGM_Recall_h), NRGM_Precision_h);
        disp(['Area under the curve for the Highway: ', num2str(NRGM_Area_h)])

        NRGM_Area_f = trapz(flip(NRGM_Recall_f), NRGM_Precision_f);
        disp(['Area under the curve for the Fall: ', num2str(NRGM_Area_f)])

        NRGM_Area_t = trapz(flip(NRGM_Recall_t), NRGM_Precision_t);
        disp(['Area under the curve for the Traffic: ', num2str(NRGM_Area_t)])
    end


    
end % of task1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TASK 4: Recursive Gaussian Modeling
if doTask4

    disp('--------TASK 4--------');
    
    alpha = [0.1:0.25:5];
    ro = [0.1:0.1:1];
    
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
            
            [RGM_forEstim_highway,t1_h]= task4(seq_input_highway, alpha(i), ro(j), show_videos_4);
            [RGM_forEstim_fall,t1_f] = task4(seq_input_fall, alpha(i), ro(j), show_videos_4);
            [RGM_forEstim_traffic,t1_t]= task4(seq_input_traffic, alpha(i), ro(j), show_videos_4);

            %% Evaluation functions for TASK 4 (TASK 2 and TASK 3)
            [RGM_TP_h(i,j), RGM_FP_h(i,j), RGM_FN_h(i,j), RGM_TN_h(i,j), RGM_Precision_h(i,j), RGM_Accuracy_h(i,j), RGM_Specificity_h(i,j), RGM_Recall_h(i,j), RGM_F1_h(i,j)] = task2(RGM_forEstim_highway,gt_input_highway(t1_h:end));
            [RGM_TP_f(i,j), RGM_FP_f(i,j), RGM_FN_f(i,j), RGM_TN_f(i,j), RGM_Precision_f(i,j), RGM_Accuracy_f(i,j), RGM_Specificity_f(i,j), RGM_Recall_f(i,j), RGM_F1_f(i,j)] = task2(RGM_forEstim_fall,gt_input_fall(t1_f:end));
            [RGM_TP_t(i,j), RGM_FP_t(i,j), RGM_FN_t(i,j), RGM_TN_t(i,j), RGM_Precision_t(i,j), RGM_Accuracy_t(i,j), RGM_Specificity_t(i,j), RGM_Recall_t(i,j), RGM_F1_t(i,j)] = task2(RGM_forEstim_traffic,gt_input_traffic(t1_t:end));

        end
    end
    
    if doTask5
        %% Plot data for Task 5:

        % Plot TP, TN, FP, FN:
        plot_surfs_t5(ro, alpha, RGM_TP_h, RGM_TP_f, RGM_TP_t, 'True Positives');
        plot_surfs_t5(ro, alpha, RGM_TN_h, RGM_TN_f, RGM_TN_t, 'True Negatives');
        plot_surfs_t5(ro, alpha, RGM_FP_h, RGM_FP_f, RGM_FP_t, 'False Positives');
        plot_surfs_t5(ro, alpha, RGM_FN_h, RGM_FN_f, RGM_FN_t, 'False Negatives');
        close all;

        % Plot F1 Score
        plot_surfs_t5(ro, alpha, RGM_F1_h, RGM_F1_f, RGM_F1_t, 'F 1 score');
        plot_precision_recall_t3(RGM_Recall_h, RGM_Recall_f, RGM_Recall_t, RGM_Precision_h, RGM_Precision_f, RGM_Precision_t)    

        pause;

        [max_AUC_h, best_ro_index_h] = calculate_best_ro(RGM_Recall_h, RGM_Precision_h);
        [max_AUC_f, best_ro_index_f] = calculate_best_ro(RGM_Recall_f, RGM_Precision_f);
        [max_AUC_t, best_ro_index_t] = calculate_best_ro(RGM_Recall_t, RGM_Precision_t);

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
    [Alpha_h, T1_h, T2_h, K_h, Rho_h, THFG_h] = load_parameters_t6('highway');
    [Alpha_f, T1_f, T2_f, K_f, Rho_f, THFG_f] = load_parameters_t6('fall');
    [Alpha_t, T1_t, T2_t, K_t, Rho_t, THFG_t] = load_parameters_t6('traffic');
   

% Find out the optimal number of Gaussians (K), the optimal Alpha and rho
    for i = 1:length(K_h)
        disp(['for K = ', num2str(K_h(i)),'...\n'])
        for j = 1:length(Alpha_h)
            for k = 1:length(Rho_h)

                % Run the S&G implementation for the given parameters
                fprintf('Running S&G implementation for Highway...\n');
                [SG_forEstim_highway] = MultG_fun(Alpha_h(j), T1_h, T2_h, K_h(i), Rho_h(k), THFG_h, 'highway');
                fprintf('Running S&G implementation for Fall...\n');
                [SG_forEstim_fall] = MultG_fun(Alpha_f(j), T1_f, T2_f, K_f(i), Rho_f(k), THFG_f, 'fall');
                fprintf('Running S&G implementation for Traffic...\n');
                [SG_forEstim_traffic] = MultG_fun(Alpha_t(j), T1_t, T2_t, K_t(i), Rho_t(k), THFG_t, 'traffic');

                    % Show estimated scene
                if show_video_6
                    % Quick preview
                    for p = 1:((T2-T1)/2)    
                        imshow(SG_forEstim_highway(:,:,p*2));
                        pause(0.001)
                    end
                end

            fprintf('Evaluate S&G implementation...\n');
            [SG_TP_h(i,j,k), SG_FP_h(i,j,k), SG_FN_h(i,j,k), SG_TN_h(i,j,k), SG_Precision_h(i,j,k), SG_Accuracy_h(i,j,k), SG_Specificity_h(i,j,k), SG_Recall_h(i,j,k), SG_F1_h(i,j,k)] = task2(SG_forEstim_highway,gt_input_highway);
            [SG_TP_f(i,j,k), SG_FP_f(i,j,k), SG_FN_f(i,j,k), SG_TN_f(i,j,k), SG_Precision_f(i,j,k), SG_Accuracy_f(i,j,k), SG_Specificity_f(i,j,k), SG_Recall_f(i,j,k), SG_F1_f(i,j,k)] = task2(SG_forEstim_fall,gt_input_fall);
            [SG_TP_t(i,j,k), SG_FP_t(i,j,k), SG_FN_t(i,j,k), SG_TN_t(i,j,k), SG_Precision_t(i,j,k), SG_Accuracy_t(i,j,k), SG_Specificity_t(i,j,k), SG_Recall_t(i,j,k), SG_F1_t(i,j,k)] = task2(SG_forEstim_traffic,gt_input_traffic);

            end
        end
    end
    
    
    if doTask7
        
        %% Plot data for Task 7:

        % Plot TP, TN, FP, FN for each K:
        for K = 1:length(K_h) 
            disp(['for K = ', num2str(K_h(i)),'...\n']);
            plot_surfs_t5(Rho_h, Alpha_h, SG_TP_h, SG_TP_f, SG_TP_t, 'True Positives');
            plot_surfs_t5(Rho_h, Alpha_h, SG_TN_h, SG_TN_f, SG_TN_t, 'True Negatives');
            plot_surfs_t5(Rho_h, Alpha_h, SG_FP_h, SG_FP_f, SG_FP_t, 'False Positives');
            plot_surfs_t5(Rho_h, Alpha_h, SG_FN_h, SG_FN_f, SG_FN_t, 'False Negatives');
            close all;

            % Plot F1 Score for each K:
            plot_surfs_t5(Rho_h, Alpha_h, SG_F1_h, SG_F1_f, SG_F1_t, 'F 1 score');
            plot_precision_recall_t3(SG_Recall_h, SG_Recall_f, SG_Recall_t, SG_Precision_h, SG_Precision_f, SG_Precision_t)    
            
            pause;

            [max_AUC_h, best_ro_index_h] = calculate_best_ro(SG_Recall_h, SG_Precision_h);
            [max_AUC_f, best_ro_index_f] = calculate_best_ro(SG_Recall_f, SG_Precision_f);
            [max_AUC_t, best_ro_index_t] = calculate_best_ro(SG_Recall_t, SG_Precision_t);

            disp(['Area under the curve for the Highway: ', num2str(max_AUC_h), ' with ro = ', num2str(ro(best_ro_index_h))])
            disp(['Area under the curve for the Fall: ', num2str(max_AUC_f), ' with ro = ', num2str(ro(best_ro_index_f))])
            disp(['Area under the curve for the Traffic: ', num2str(max_AUC_t), ' with ro = ', num2str(ro(best_ro_index_t))])
        end
    end
end   
fprintf('\nTask 6 done.\n')

    % Bàsicament falta trobar els parametres que van be per a cada 
    %     sequència amb S&G,  i compararne els resultats amb els millors 
    %     parametres que teniem fins ara. Ho he deixat tot a punt per ser 
    %     executat, he modificat el seu codi S&G per a que ens cridi els 
    %     datasets a on els tenim, i he creat moltes funcions per tenir les 
    %     coses ordenades. Les més important que heu de saber, 
    %     load_parameters_t6, que carrega els parametres de S&G i que cadrà 
    %     anar ajustant per a trobar el millor rendiment. 
    %     L'ideal seria generar algun bucle com amb les task1 i task4 
    %     que vagi provant diferents combinacions, pero com que el model 
    %     triga una mica mes que task1 i task4 us ho deixo a la 
    %     vostra elecció :P     
        
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
    
    
 % task 6

if compareMethods 
    
    % We first compute the foreground model for each sequence using each
    % technique with the best configuration we could find. Then compute the metrics:
    
%     % Non-Recursive Gaussian Modeling    
%     [RGM_forEstim_highway, t1_h,t2_h]= task1(seq_input_highway,alpha(i), show_videos_1);
%     [RGM_forEstim_fall,t1_f,t2_f] = task1(seq_input_fall,alpha(i), show_videos_1);
%     [RGM_forEstim_traffic,t1_t,t2_t]= task1(seq_input_traffic,alpha(i), show_videos_1);
%     
%     % NRGM evaluation
%     [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(NRGM_forEstim_highway,gt_input_highway(t1_h:end));
%     [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(NRGM_forEstim_fall,gt_input_fall(t1_f:end));
%     [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(NRGM_forEstim_traffic,gt_input_traffic(t1_t:end));
% 
%     
%     % Recursive Gaussian Modeling
%     [RGM_forEstim_highway,t1_h,t2_h]= task4(seq_input_highway, alpha, ro, show_videos_4);
%     [RGM_forEstim_fall,t1_f,t2_f] = task4(seq_input_fall, alpha, ro, show_videos_4);
%     [RGM_forEstim_traffic,t1_t,t2_t]= task4(seq_input_traffic, alpha, ro, show_videos_4);
%     
%     % NRGM evaluation
%     [TP_h(i,j), FP_h(i,j), FN_h(i,j), TN_h(i,j), Precision_h(i,j), Accuracy_h(i,j), Specificity_h(i,j), Recall_h(i,j), F1_h(i,j)] = task2(RGM_forEstim_highway,gt_input_highway(t1_h:end));
%     [TP_f(i,j), FP_f(i,j), FN_f(i,j), TN_f(i,j), Precision_f(i,j), Accuracy_f(i,j), Specificity_f(i,j), Recall_f(i,j), F1_f(i,j)] = task2(RGM_forEstim_fall,gt_input_fall(t1_f:end));
%     [TP_t(i,j), FP_t(i,j), FN_t(i,j), TN_t(i,j), Precision_t(i,j), Accuracy_t(i,j), Specificity_t(i,j), Recall_t(i,j), F1_t(i,j)] = task2(RGM_forEstim_traffic,gt_input_traffic(t1_t:end));
% 
%     
%     % Stauffer and Grimson 
%     fprintf('Running S&G implementation for Highway...\n');
%     [SG_forEstim_highway] = MultG_fun(Alpha_h, T1_h, T2_h, K_h, Rho_h, THFG_h, 'highway');
%     fprintf('Running S&G implementation for Fall...\n');
%     [SG_forEstim_fall] = MultG_fun(Alpha_f, T1_f, T2_f, K_f, Rho_f, THFG_f, 'fall');
%     fprintf('Running S&G implementation for Traffic...\n');
%     [SG_forEstim_traffic] = MultG_fun(Alpha_t, T1_t, T2_t, K_t, Rho_t, THFG_t, 'traffic');
%     
%     % Stauffer and Grimson Evaluation
%     fprintf('Evaluate S&G implementation...\n');
%     [TP_h(i), FP_h(i), FN_h(i), TN_h(i), Precision_h(i), Accuracy_h(i), Specificity_h(i), Recall_h(i), F1_h(i)] = task2(SG_forEstim_highway,gt_input_highway);
%     [TP_f(i), FP_f(i), FN_f(i), TN_f(i), Precision_f(i), Accuracy_f(i), Specificity_f(i), Recall_f(i), F1_f(i)] = task2(SG_forEstim_fall,gt_input_fall);
%     [TP_t(i), FP_t(i), FN_t(i), TN_t(i), Precision_t(i), Accuracy_t(i), Specificity_t(i), Recall_t(i), F1_t(i)] = task2(SG_forEstim_traffic,gt_input_traffic);
% 
%     
end


fprintf('\n FINISHED.\n')