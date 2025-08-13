function dist = scaling(values, counts, L, n, expon, lambda1, lambda2, delta1, delta2)
%SCALING Summary of this function goes here
%   Detailed explanation goes here

    dist = NaN(numel(delta1), numel(delta2));
    
    for i=1:numel(delta1)
        % disp("delta1 ="+string(delta1(i)));
        for j=1:numel(delta2)
            % disp("  delta2 ="+string(delta2(j)));
            a=lambda1+delta1(i);
            b=expon*(lambda1+delta1(i))+lambda2+delta2(j);
            
            X = cell(numel(values), 1);
            Y = cell(numel(values), 1);
    
            for k=1:numel(values)
                X{k} = log10(values{k})+log10(L(k))*a;
                Y{k} = log10(counts{k}/sum(counts{k}))+log10(L(k))*b;
            end

            dist(i,j) = distancia_funciones(X, Y, n);
        end
    end
end