function [flow, tracked_img] = block_matching(image_prev, image_current)
    global params;
    assert(isequal(size(image_prev),size(image_current)));
    %% Background method
%     image_prev = rgb2gray(image_prev);
%     image_current = rgb2gray(image_current);
    
    orig_size = size(image_current);
    tracked_img = zeros(orig_size);
    new_size = round(orig_size(1:2)./params.block_size).*params.block_size;
    image_prev = imresize(image_prev,new_size);
    image_current = imresize(image_current,new_size);
        
    
    divisions_i = repmat(params.block_size(1),[1,new_size(1)/params.block_size(1)]);
    divisions_j = repmat(params.block_size(2),[1,new_size(2)/params.block_size(2)]);
    divisions_k = size(image_current,3);
    blocks = mat2cell(image_current,divisions_i,divisions_j,divisions_k);
    
    flow = zeros([size(blocks,1),size(blocks,2),2]);

    disp_i = -params.maxblock_disp_i:params.i_step:params.maxblock_disp_i;
    disp_j = -params.maxblock_disp_j:params.j_step:params.maxblock_disp_j;
    
    count=0;
    for i=1:size(blocks,1)
        for j=1:size(blocks,2)
            id_i0 = (i-1)*params.block_size(1) + 1;
            id_i1 = i*params.block_size(1);
            id_j0 = (j-1)*params.block_size(2) + 1;
            id_j1 = j*params.block_size(2);
            
            current_block = blocks{i,j};
            
            switch params.block_error_cost
                case 'MSE'
                    
                case 'Hists'
                    hist_curr = zeros(params.hist_bins*divisions_k,1);
                    for k=1:divisions_k
                        id_k_0 = (k-1)*params.hist_bins+1;
                        id_k_1 = k*params.hist_bins;
                        hist_curr(id_k_0:id_k_1) = imhist(current_block(:,:,k),params.hist_bins);
                        hist_curr(id_k_0:id_k_1) = hist_curr(id_k_0:id_k_1)/sum(hist_curr(id_k_0:id_k_1));
                    end
                otherwise
                    error(['Invalid error cost: ', params.block_error_cost,'. Use MSE or Hists']);
            end
            
            min_cost = inf;
            min_cost_d = [disp_j(1),disp_i(1)];
            tracked_block = zeros(size(current_block));
            for di=disp_i
                for dj=disp_j
                    id_i0_d = id_i0 + di;
                    id_i1_d = id_i1 + di;
                    id_j0_d = id_j0 + dj;
                    id_j1_d = id_j1 + dj;
                    
                    if(id_i0_d<1 || id_i1_d>new_size(1) || id_j0_d<1 || id_j1_d>new_size(2))
                        continue;
                    end
                    prev_block = image_prev(id_i0_d:id_i1_d,id_j0_d:id_j1_d,:);
                    
                    cost = inf;
                    switch params.block_error_cost
                        case 'MSE'
                            SE = (double(current_block)-double(prev_block)).^2;
                            cost = mean(SE(:));
                        case 'Hists'
                            hist_prev = zeros(params.hist_bins*divisions_k,1);
                            for k=1:divisions_k
                                id_k_0 = (k-1)*params.hist_bins+1;
                                id_k_1 = k*params.hist_bins;
                                hist_prev(id_k_0:id_k_1) = imhist(prev_block(:,:,k),params.hist_bins);
                                hist_prev(id_k_0:id_k_1) = hist_prev(id_k_0:id_k_1)/sum(hist_prev(id_k_0:id_k_1));
                            end
                            cost = 0;
                            for k=1:divisions_k
                                id_k_0 = (k-1)*params.hist_bins+1;
                                id_k_1 = k*params.hist_bins;
                                cost = cost + bhattacharyya_distance(hist_prev(id_k_0:id_k_1),hist_curr(id_k_0:id_k_1));
%                                 cost = cost + pdist2(hist_prev(id_k_0:id_k_1),hist_curr(id_k_0:id_k_1),'mahalanobis');
                            end
                        otherwise
                            error(['Invalid error cost: ', params.block_error_cost,'. Use MSE or Hists']);
                    end
                    if cost < min_cost
                        min_cost = cost;
                        min_cost_d = [dj,di];
                        tracked_block = prev_block;
                    end
                end
            end
            flow(i,j,:) = reshape(-min_cost_d,[1,1,2]);
            tracked_img(id_i0:id_i1,id_j0:id_j1,:) = tracked_block;
            count = count+1;
            if params.verbose_block_matching
                disp(['Block matching progress: ', num2str(100*count/(size(blocks,1)*size(blocks,2))),'%%'])
            end
        end
    end

    flow = imresize(flow,[orig_size(1),orig_size(2)]);


end

function distance = bhattacharyya_distance(h1, h2)
%     assert(isequal(size(h1),size(h2)));
    N = length(h1);
    
    prod = h1.*h2;
    prod_sqrt = sqrt(prod);
    distance = sqrt(1 - (1/sqrt(mean(h1(:))*mean(h2(:))*N^2)).*sum(prod_sqrt(:)));

end