function extract_features(path)

if nargin < 1
   path = 'data/images/Pororo_ENGLISH3_1';
end

%% add matcaffe path 
addpath('/Users/Calvin/Github/caffe/matlab/caffe');

%% parameters
use_gpu = 1;
batch_size = 10;

%% inputs
model_def_file = 'models/bvlc_alexnet/deploy_features.prototxt';
model_file = 'models/bvlc_alexnet/caffe_alexnet_train_iter_100000.caffemodel';
matcaffe_init(use_gpu, model_def_file, model_file);

filenames = dir([path '/pororo_1_*.bmp']);
filenames = {filenames.name}';
N = size(filenames, 1);

for i = 1 : N
    filenames{i} = [path '/' filenames{i}];
end

features = zeros(13*13*256, N);

for i = 1 : floor(N / batch_size)
    rows = batch_size * (i-1) + 1 : batch_size * i;
    filename = {filenames{rows}}';
    feat = do_extract_features(filename, batch_size);
    feat = reshape(feat, [size(features, 1) batch_size]);
	features(:, rows) = feat;
end

% reminder
rows = batch_size * i + 1 : N;
filename = {filenames{rows}}';
feat = do_extract_features(filename, batch_size);
feat = reshape(feat, [size(features, 1) batch_size]);
features(:, rows) = feat(:, 1:size(rows,2));

%save('features.mat', 'features'); 

end

function feat = do_extract_features(filename, batch_size)
    input_data = prepare_batch(filename);
    if batch_size > size(input_data, 4)
        input_data_ = zeros(size(input_data, 1), ...
                            size(input_data, 2), ...
                            size(input_data, 3), batch_size, 'single');
        input_data_(:, :, :, 1:size(input_data, 4)) = input_data;
        input_data = input_data_;
    end
    out = caffe('forward', {input_data});
    feat = out{1}; 
end