function d = distancia_funciones(X, Y, n)

    % X, Y cell arrays con abscisas y ordenadas de distintas funciones
    % n numero de puntos equiespaciados donde interpolar
    x1 = max(cellfun(@min, X));
    x2 = min(cellfun(@max, X));
        
    nfunc = numel(X);

    x = linspace(x1, x2, n);
    y = NaN([nfunc n]);

    for s=1:numel(X)
        y(s, :) = interp1(X{s},Y{s},x);
    end

    d = sum(abs(y-repmat(mean(y, 1), nfunc, 1)), 'all')/n;
    
end