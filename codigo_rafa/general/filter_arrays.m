function map=filter_arrays(ids)
    map = floor((0:1023)/64) == ids(1)-1;
    for i = ids(2:end)
        map = map | floor((0:1023)/64) == i-1;
    end
end