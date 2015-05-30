function [ mat3d_o ] = conv3( mat3d, mat2d )
%CONV3 Summary of this function goes here
%   Detailed explanation goes here

mat3d_o = zeros(size(mat3d, 1) + size(mat2d, 1) - 1, ...
                size(mat3d, 2) + size(mat2d, 2) - 1, ...
                size(mat3d, 3));
for i = 1 : size(mat3d, 3)
   mat3d_o(:, :, i) = conv2(squeeze(mat3d(:, :, i)), mat2d, 'full');
end

end

