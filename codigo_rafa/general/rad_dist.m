function [G, N_r, N_a] = rad_dist(P, x, y, nbins, dr)
    l=size(x,1);
    ntimes=size(P, 1);

    N_r = zeros(nbins+1, 1); % for storing the r=0 correlation separately
    G = zeros(nbins+1, 1);
    N_a = sum(P, 2);

    for i=1:l
        if mod(i-1, 100) == 0
            disp(i)
        end
        for j=i:l
            c = sum(P(:,i).*P(:,j)./N_a.^2, 1, "omitnan");
            if i==j
                k=0;
            else
                r=hypot(x(i)-x(j), y(i)-y(j));
                k=ceil(r/dr);
            end
            %fprintf("%d %d %d\n", i, j, k);

            N_r(k+1) = N_r(k+1)+1;
            G(k+1) = G(k+1)+c;
        end
    end
    
    for k=0:nbins
        if N_r(k+1) ~= 0
            G(k+1) = G(k+1)/N_r(k+1);
        else
            G(k+1) = nan;
        end
    end
    G = G*size(x, 1)^2;
end