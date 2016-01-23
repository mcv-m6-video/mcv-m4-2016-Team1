function seq_stabilized = stabilize_sequence(sequence)
    global params;
    N = length(sequence);
    seq_stabilized = cell(1,N);
    
    image_prev = sequence{1};
    seq_stabilized{1} = sequence{1};
    updated_stabilization = zeros(size(image_prev,1), size(image_prev,2), 2);
    for i=2:N
        image_current = sequence{i};
        [flow,~] = block_matching(image_prev,image_current);
        
        updated_stabilization = updated_stabilization + flow;
        X = updated_stabilization(:,:,1);
        Y = updated_stabilization(:,:,2);
        
        x_disp = mean(X(:));
        y_disp = mean(Y(:));
        
        image_stabilized = zeros(size(image_current),'uint8');
        if(y_disp>=0 && x_disp>=0)
            image_stabilized((round(abs(y_disp))+1):end,(round(abs(x_disp))+1):end,:) = image_current((round(abs(y_disp))+1):end,(round(abs(x_disp))+1):end,:);
        elseif(y_disp>=0 && x_disp<0)
            image_stabilized((round(abs(y_disp))+1):end,1:(end-round(abs(x_disp))),:) = image_current((round(abs(y_disp))+1):end,1:(end-round(abs(x_disp))),:);
        elseif(y_disp<0 && x_disp>=0)
            image_stabilized(1:(end-round(abs(y_disp))),(round(abs(x_disp))+1):end,:) = image_current(1:(end-round(abs(y_disp))),(round(abs(x_disp))+1):end,:);
        else
            image_stabilized(1:(end-round(abs(y_disp))),1:(end-round(abs(x_disp))),:) = image_current(1:(end-round(abs(y_disp))),1:(end-round(abs(x_disp))),:);
        end
        seq_stabilized{i} = image_stabilized;
        
        image_prev = image_current;
        
        if(params.verbose_stabilization)
            disp(['Stabilization: ',num2str(100*(i-1)/(N-1)),'%'])
        end
    end

end