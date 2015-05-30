function show_filters( out_vec )
%SHOW_FILTERS Summary of this function goes here
%   Detailed explanation goes here

out_size = size(out_vec);
print_vec = reshape(out_vec, [out_size(1) * out_size(2) * out_size(3), out_size(4)]);

%% Normalization
print_vec = bsxfun(@minus, print_vec, min(print_vec));
print_vec = bsxfun(@rdivide, print_vec, max(print_vec));

%% Print filters
show_centroids(print_vec', out_size(1), out_size(2));

end

