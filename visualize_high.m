%% Add matcaffe path 
addpath('/Users/Calvin/Github/caffe/matlab/caffe');

use_gpu = 1;

%% initialization
if exist('caffe', 'builtin')
    if caffe('is_initialized')
        caffe('reset');
    else 
        matcaffe_init(use_gpu);
    end
end

%% Inputs
% model_def_file = 'models/bi_ponet/deploy.prototxt';
% model_file = 'models/bi_ponet/ponet_train_iter_1000.caffemodel';
model_def_file = 'models/bvlc_alexnet/deploy.prototxt';
model_file = 'models/bvlc_alexnet/caffe_alexnet_train_iter_100000.caffemodel';
matcaffe_init(use_gpu, model_def_file, model_file);

filename = {'data/images/Pororo_ENGLISH3_1/pororo_1_269202.bmp', ... % 3
            'data/images/Pororo_ENGLISH3_1/pororo_1_152485.bmp', ... % 60
            'data/images/test4.jpg'};
          %'data/images/Pororo_ENGLISH3_1/pororo_1_615181.bmp', ... % 1024
input_data = prepare_batch(filename);
scores = caffe('forward', {input_data});
scores = squeeze(scores{1});

% %% Get weights
% net = caffe('get_weights');
% 
% %% Calc
% w1 = net(1).weights{1};
% w2 = net(2).weights{1};
% w3 = net(3).weights{1};
% w4 = net(4).weights{1};
% w5 = net(5).weights{1};
% 
% %% Show
% show_filters(w1);
% w2_out = deconv(w1, w2);
% pause();
% show_filters(w2_out);
% w3_out = deconv(w2_out, w3);
% pause();
% show_filters(w3_out);
% w4_out = deconv(w3_out, w4);
% pause();
% show_filters(w4_out);
% w5_out = deconv(w4_out, w5);
% pause();
% show_filters(w5_out);
