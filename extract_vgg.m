function extract_features(target, path_to_image)

if nargin < 1   
    target = 'Pororo_ENGLISH3_1';
end
if nargin < 2
    path_to_image = 'data/images/';
end

path_to_caffe = '/Users/Calvin/Github/caffe/';
path = [path_to_image target];

%% add matcaffe path 
addpath('/Users/Calvin/Github/caffe/matlab/caffe');

%% parameters
use_gpu = 1;
batch_size = 10;

%% inputs

model_def_file = [path_to_caffe 'models/VGG_ILSVRC_16_layers/deploy_conv4_features.prototxt'];
model_file = [path_to_caffe '/models/VGG_ILSVRC_16_layers/VGG_ILSVRC_16_layers.caffemodel'];
matcaffe_init(use_gpu, model_def_file, model_file);

DATA_ROOT = [path_to_image target '/'];
PROD_NUM = sscanf(target, 'Pororo_ENGLISH%d_%d');
DISC_NUM = PROD_NUM(2);

filenames = dir_sorted([DATA_ROOT '/*.bmp'], ...
                    ['pororo_' DISC_NUM '_%d.bmp']);
if 0 == size(filenames, 1)
    filenames = dir_sorted([DATA_ROOT '/*.bmp'], ...
                    [target '_%d.bmp']);
end
if 0 == size(filenames, 1)
    disp('Cannot found images!');
end
    
N = size(filenames, 1);

for i = 1 : N
    filenames{i} = [path '/' filenames{i}];
end

features = zeros(14*14*512, N);

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

save([path_to_image '../mat/' target '_vgg.mat'], 'features'); 

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