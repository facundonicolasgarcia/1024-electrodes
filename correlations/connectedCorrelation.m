function [C, N] = connectedCorrelation(u, x, y, nbins, dr)
    l=length(x);
    ntimes=size(u, 1);

    N = zeros(nbins+1, 1); % for storing the r=0 correlation separately
    C = zeros(nbins+1, 1);
    
    for i=1:l
        for j=i:l
            c = sum(u(:,i).*u(:,j), 1)/ntimes;
            if i==j
                k=0;
            else
                r=hypot(x(i)-x(j), y(i)-y(j));
                k=ceil(r/dr);
            end

            N(k+1) = N(k+1)+1;
            C(k+1) = C(k+1)+c;
        end
    end
    
    for k=0:nbins
        if N(k+1) ~= 0
            C(k+1) = C(k+1)/N(k+1);
        else
            C(k+1) = nan;
        end
    end
    C = C/C(1);
end