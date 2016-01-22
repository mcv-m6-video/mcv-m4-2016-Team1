
function [foreground] = classify_foreground(m,v,alpha,img)

[M,N] = size(img);

foreground = zeros(M,N);

for i = 1:M
    for j = 1:N
        if (img(i,J) - m(i,j) >= alpha * (v(i,j)+2))
            foreground(i,j) = 1;
        else
            foreground(i,j) = 0;
        end
    end
end
