function create_cp(target, path_to_data)

    if nargin < 1   
        target = 'Pororo_ENGLISH2_1';
    end
    if nargin < 2
        path_to_data = '/Volumes/Oculus/data/Pororo/';
    end

    DATA_ROOT = [path_to_data 'images/' target '/'];
    CP_ROOT = [path_to_data 'CP_13/' target '/'];
    PROD_NUM = sscanf(target, 'Pororo_ENGLISH%d_%d');
    DISC_NUM = PROD_NUM(2);

    images = dir_sorted([DATA_ROOT '/*.bmp'], ...
                        ['pororo_' DISC_NUM '_%d.bmp']);
    if 0 == size(images, 1)
        images = dir_sorted([DATA_ROOT '/*.bmp'], ...
                        [target '_%d.bmp']);
    end
    if 0 == size(images, 1)
        disp('Cannot found images!');
    end
    cpes = dir_sorted([CP_ROOT '/cp_*'], ['cp_' target '_ep%d.mat']);

    %% Check if # of images and # of labels are the same.
    count = 0;
    for i = 1 : size(cpes, 1)
        load([CP_ROOT cpes{i}]);
        count = count + size(cp, 1);
        assert(max(max(cp)) > 0);
    end
    assert(size(images, 1) == count);

    %% Print out to a file
    fid = fopen([path_to_data 'label/' target '.txt'], 'w');

    idx = 0;
    for i = 1 : size(cpes, 1)
        load([CP_ROOT cpes{i}]);
        for j = 1 : size(cp, 1)
            idx = idx + 1;
            label = make_label(cp, j);
            fprintf(fid, '%s %d\n', [target '/' images{idx}], label);
        end
    end
    fclose(fid);
end
function label = make_label(cp, j)
    label = 0;
    for i = 1 : size(cp, 2)
        label = label + cp(j, i) * 2^(i-1);
    end
end
