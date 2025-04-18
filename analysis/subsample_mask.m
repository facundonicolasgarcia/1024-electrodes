function mask = subsample_mask(f)
    % returns mask on electrode indexes: contains ones for the subsample
    % electrodes and zeros elsewhere
    i = mod(1:1024, 8); % row of the array of electrodes
    j = floor(mod(1:1024, 64)/ 8)+1; % column
    
    switch f
        case 1
            mask = ones([1024 1]);
        case 2
            mask = (  mod(i, 2) == mod(j, 2)  ) ;
        case 4
            mask = ( ( mod(i, 2) == 1 ) & mod(j, 2) == 1 );
        case 8
            mask = ( mod(i, 4)==mod(j, 4) & mod(i, 2)==1);
        case 16
            mask = ( mod(i, 4) == mod(j, 4) & mod(1, 4) == 1);
        case 32
            mask = ( i==j & (i==1 | i==5));
        case 64
            mask = (i==j & i==1);
    end
end

