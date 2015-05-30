%% Extract vgg features (14*14*512) from
%% Pororo Animation
path_to_image = '/Volumes/Oculus/data/Pororo/images/';

addpath('preprocess');

%% Extract features from individual discs.
for season = 2 : 4
    for disc = 1 : 4
        target = sprintf('Pororo_ENGLISH%d_%d', season, disc);
        %extract_vgg(target, path_to_image);
        %create_cp(target);
        create_sub(target);
    end
end