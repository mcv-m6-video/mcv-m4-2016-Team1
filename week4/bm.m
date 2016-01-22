close all; clc

im = imread('peppers.png');

im_k = imresize(im, [100 100]);
im_k = im_k(:,:,1);

block_size_width = 10;
block_size_heigth = 10;
search_area = 10;
error_type = 'MSE';

% shift

im_k_plus_1 = uint8(zeros(size(im_k,1),size(im_k,2)));

im_k_plus_1(:, block_size_heigth:end) = im_k(:, 1:size(im_k,1)-block_size_heigth+1,1);

% end shift

final_image_compensated = uint8(zeros(size(im_k,1),size(im_k,2)));

for i = 1 : block_size_heigth : size(im_k,1) - block_size_heigth
    for j = 1 : block_size_width : size(im_k,2) - block_size_width
        
        im_block = im_k(j:j+block_size_heigth,i:i+block_size_width);
        
        difference_of_pixels = zeros(size(im_k,1) - block_size_heigth, size(im_k,2) - block_size_width);
        
        min_mse = inf;
        min_psnr = inf;
        
        index_row = -1;
        index_col = -1;
        
        for z = 1 : size(im_k_plus_1,1) - block_size_heigth
            for x = 1 : size(im_k_plus_1,2) - block_size_width
                
                if abs(i - z) < search_area && abs(j - x) < search_area
                    
                    im_block_to_compare = im_k_plus_1(z:z+block_size_heigth,x:x+block_size_width);
                    
                    switch error_type
                        case 'MSE'
                            
                            [rows, columns] = size(im_block);
                            
                            squaredErrorImage = (double(im_block) - double(im_block_to_compare)) .^ 2;
                            mse = sum(sum(squaredErrorImage)) / (rows * columns);
                            
                            if min_mse > mse
                                min_mse = mse;
                                index_row = z;
                                index_col = x;
                            end
                            
                            PSNR = 10 * log10( 256^2 / mse);
                            
                            if min_psnr > PSNR
                                min_psnr = PSNR;
                                index_row = z;
                                index_col = x;
                            end
                            
                        otherwise
                    end
                end
            end
        end
        
        final_image_compensated(index_col:index_col+block_size_heigth,index_row:index_row+block_size_width) = im_k(index_col:index_col+block_size_heigth, index_row:index_row+block_size_width);
    end
end

figure()
imshow(final_image_compensated)