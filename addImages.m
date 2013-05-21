function [ new_img ] = addImages( img1, img2 )
%ADDIMAGES Summary of this function goes here
%   Detailed explanation goes here
    [w1, h1, t1] = size(img1);
    [w2, h2, t2] = size(img2);
    if (w1 ~= w2) || (h1 ~= h2),
        new_img = uint8(img1);
    else
        new_img = zeros(w1, h1, t1, 'uint8');
        for i = 1:size(img1,1), 
            for j = 1:size(img1,2),
                if (img2(i,j,1) ~= 0 && img2(i,j,2) ~= 0  && img2(i,j,3) ~= 0),
                    new_img(i,j,1) = uint8(img2(i,j,1));
                    new_img(i,j,2) = uint8(img2(i,j,2));
                    new_img(i,j,3) = uint8(img2(i,j,3));
                else
                    new_img(i,j,1) = uint8(img1(i,j,1));
                    new_img(i,j,2) = uint8(img1(i,j,2));
                    new_img(i,j,3) = uint8(img1(i,j,3));
                end
            end
        end
    end
end


