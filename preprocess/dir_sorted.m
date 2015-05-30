function sortedName = dir_sorted(path, format)
    List = dir(path);
    Name = {List.name};
    S = sprintf('%s,', Name{:}); 
    D = sscanf(S, [format ',']); 
    [~, sortIndex] = sort(D);
    sortedName = Name(sortIndex)';
end