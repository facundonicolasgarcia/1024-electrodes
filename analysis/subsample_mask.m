function mask = subsample_mask(f, x, y)
    % returns mask on electrode indexes: contains ones for the subsample
    % electrodes and zeros elsewhere

    arguments
        f (1,1) uint8
        x (1,1) int8 = 0
        y (1,1) int8 = 0
    end

    i = int8(mod(0:1023, 8))-x; % row of the array of electrodes
    j = int8(floor(mod(0:1023, 64)/ 8))-y; % column
    
    switch f
        case 1
            mask = ones([1024 1]);
        case 2
            mask = (  mod(i, 2) == mod(j, 2)  ) ;
        case 4
            mask = ( ( mod(i, 2) == 0 ) & mod(j, 2) == 0 );
        case 8
            mask = ( mod(i, 4)==mod(j, 4) & mod(i, 2)==0);
        case 16
            mask = ( mod(i, 4) == mod(j, 4) & mod(i, 4) == 0);
        case 32
            mask = ( i==j & (i==0 | i==4));
        case 64
            mask = (i==j & i==0);
    end
end

