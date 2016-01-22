function [seq_stabilized, gt_stabilized] = stabilize_sequence(sequence, gt)
assert(size(sequence,1)==size(gt,1) && size(sequence,2)==size(gt,2));

global params;
N = length(sequence);
seq_stabilized = cell(1,N);
gt_stabilized = cell(1,N);

seq_stabilized{1} = sequence{1};
gt_stabilized{1} = gt{1};

x_disp_vector = zeros(1,N);
y_disp_vector = zeros(1,N);
dx_vector = zeros(1,N);
dy_vector = zeros(1,N);

for i=2:N
    image_current = sequence{i};
    image_prev = sequence{i-1};
    [flow,~] = block_matching(image_prev,image_current);
    
    X = mean(flow(:,:,1));
    Y = mean(flow(:,:,2));
    
    x_disp = mean(X(:));
    x_disp_vector(i) = x_disp_vector(i-1) + x_disp;
    dx_vector(i) = x_disp;
    
    y_disp = mean(Y(:));
    y_disp_vector(i) = y_disp_vector(i-1) + y_disp;
    dy_vector(i) = y_disp;
    
    if(params.verbose_stabilization)
        disp(['Stabilization: ',num2str(100*(i-1)/(N-1)),'%'])
    end
    
end
dx_smooth = smooth(x_disp_vector,'rlowess');
dy_smooth = smooth(y_disp_vector,'rlowess');
% figure(1)
% plot(1:N,x_disp_vector,'r',1:N,dx_smooth,'b');
% legend('accumulated dx', 'smoothed accum dx')
% figure(2)
% plot(1:N,y_disp_vector,'r',1:N,dy_smooth,'b');
% legend('accumulated dy', 'smoothed accum dy')
% figure(3)
% plot(1:N,dx_vector,'r',1:N,zeros(1,N),'b');
% legend('dx','zero displacement')
% figure(4)
% plot(1:N,dy_vector,'r',1:N,zeros(1,N),'b');
% legend('dy','zero displacement')

y_dispfinal=0;
x_dispfinal=0;
for i=2:N
    image_current = sequence{i};
    
    switch(params.stv_method)
        case 'non_smooth'
            x_disp = x_disp_vector(i) - x_disp_vector(i-1);
            y_disp = y_disp_vector(i) - y_disp_vector(i-1);
        case 'smooth'
            x_disp = (x_disp_vector(i)-dx_smooth(i)) - (x_disp_vector(i-1)-dx_smooth(i-1));
            y_disp = (y_disp_vector(i)-dy_smooth(i)) - (y_disp_vector(i-1)-dy_smooth(i-1));
        otherwise
            error('Wrong stabilization method. Use smooth or non_smooth');
    end

    image_current_padded = padarray(image_current,[params.maxblock_disp_i, params.maxblock_disp_j]);
    gt_current_padded = padarray(gt{i},[params.maxblock_disp_i, params.maxblock_disp_j]);
    
    i0=1+params.maxblock_disp_i;i1=size(image_current_padded,1)-params.maxblock_disp_i;
    j0=1+params.maxblock_disp_j;j1=size(image_current_padded,2)-params.maxblock_disp_j;
    
    if(abs(x_disp)>x_dispfinal)
        x_dispfinal=x_disp;
    end
    if(abs(y_disp)>y_dispfinal)
        y_dispfinal=y_disp;
    end

    
    image_stabilized = image_current_padded((i0+round(y_disp)):(i1+round(y_disp)),(j0+round(x_disp)):(j1+round(x_disp)),:);
    gt_stabilized{i} = gt_current_padded((i0+round(y_disp)):(i1+round(y_disp)),(j0+round(x_disp)):(j1+round(x_disp)),:);
    
    seq_stabilized{i} = image_stabilized;
    
end
% for i=1:N
%     seq_stabilized{i} = seq_stabilized{i}((1+params.maxblock_disp_i):(end-params.maxblock_disp_i),(1+params.maxblock_disp_j):(end-params.maxblock_disp_j),:);
%     gt_stabilized{i} = gt_stabilized{i}((1+params.maxblock_disp_i):(end-params.maxblock_disp_i),(1+params.maxblock_disp_j):(end-params.maxblock_disp_j),:);
% end
disp('hei')

end