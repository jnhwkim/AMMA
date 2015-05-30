function [ w2_out ] = deconv( w1, w2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

w2_group = size(w1, 4) / size(w2, 3);
w2_chunk = size(w2, 4) / w2_group;
w2_out   = zeros(size(w1, 1) + size(w2, 1) - 1, ...
                 size(w1, 2) + size(w2, 2) - 1, ...
                 size(w1, 3), size(w2, 4));

for i = 1 : size(w2, 4)
    w1_range = floor((i-1) / w2_chunk) * size(w2, 3) + 1 : ...
               floor((i-1) / w2_chunk) * size(w2, 3) + size(w2, 3);
    for j = w1_range
        mat3d = squeeze(w1(:, :, :, j));
        mat2d = squeeze(w2(:, :, mod(j - 1, size(w2, 3)) + 1, i));
        w2_out(:, :, :, i) = ...
            w2_out(:, :, :, i) + conv3(mat3d, mat2d) / size(w2, 3);
    end
end

end

