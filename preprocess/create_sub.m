function create_sub(target, path_to_data)

    if nargin < 1   
        target = 'Pororo_ENGLISH2_2';
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

    %% Print out to a file
    fid = fopen([path_to_data 'sub/' target '.sub'], 'w');
    smi = fileread([path_to_data 'smi/' target '.smi']);

    idx = 0;
    for i = 1 : size(images, 1)
        idx = idx + 1;
        ts = sscanf(images{idx}, ['pororo_' DISC_NUM '_%d.bmp']);
        if 0 == size(ts, 1)
            ts = sscanf(images{idx}, [target '_%d.bmp']);
        end
        subtitle = get_subtitle(smi, ts);
        %fprintf(fid, '%s %s\n', [TARGET '/' images{idx}], subtitle);
        fprintf(fid, '%s\n', subtitle);
    end
    fclose(fid);
end

function subtitle = get_subtitle(smi, ts)
    tokens = regexp(smi, ['<SYNC Start=' int2str(ts) ...
        '><P Class=.+?>\W*(.*?)\W*<'], 'tokens');
    subtitle = preprocess(tokens{1}{1});
end

function sortedName = dir_sorted(path, format)
    List = dir(path);
    Name = {List.name};
    S = sprintf('%s,', Name{:}); 
    D = sscanf(S, [format ',']); 
    [~, sortIndex] = sort(D);
    sortedName = Name(sortIndex)';
end

function out = preprocess(in)
   out = strrep(in, '<br>', ' ');
   out = strrep(out, '<BR>', ' ');
   out = strrep(out, '.', '');
   out = strrep(out, ',', '');
   out = strrep(out, '-', ' ');
   out = strrep(out, '!', '');
   out = strrep(out, '?', '');
   out = strrep(out, '\n', ' ');
   out = strrep(out, '\n\n', '\n');
   out = strrep(out, '&nbsp;', ' ');
   out = strrep(out, sprintf('%c', 10), ' ');
   out = strrep(out, '  ', ' ');
end