function [g, r, rw] = twopointcorr2d(x,y,dr,blksize,verbose)
    
    %validate input     
    if length(x)~=length(y)
        error('Length of x should be same as length of y'); 
    elseif  numel(dr)~=1
        error('dr needs to have numel==1');
    elseif numel(x)~=length(x) || numel(y)~=length(y)
        error('Require x and y to be 1D arrays');
    end
    
    x = reshape(squeeze(x),[length(x) 1]);
    y = reshape(squeeze(y),[length(y) 1]);
    
    %validate/set blksize
    if nargin < 4
        blksize = 1000;
    elseif numel(blksize)~=1
        error('blksize must have numel = 1');
    elseif blksize < 1
        blksize = 1;
    elseif isinf(blksize) || isnan(blksize)
        blksize = length(x);
    end
    
    %validate/set verbose
    if nargin ~= 5
        verbose = false;
    elseif numel(verbose)~=1
        error('verbose must have numel = 1');
    end   
        
        
    %real height/width
    width = max(x)-min(x);
    height = max(y)-min(y);
    
    %number of particles
    totalPart = length(x);
    
    %largest radius possible
    maxR = sqrt((width/2)^2 + (height/2)^2);
    
    %r bins and area bins
    r = dr:dr:maxR;
    av_dens = totalPart/width/height;
    rareas = ((2*pi*r* dr)*av_dens);
    
    %preallocate space for corrfun/rw
    g = r*0;
    rw = r*0;
    
    %number of steps to be considered
    numsteps = ceil(totalPart / blksize);
    
    for j = 1:numsteps
 
        %loop through all particles and compute the correlation function
        indi = (j-1)*blksize+1;
        indf = min(totalPart,j*blksize);
        
        if verbose
            disp(['Step ' num2str(j) ' of ' num2str(numsteps) '. ' ...
                'Analyzing points ' num2str(indi) ' to '  num2str(indf)...
                ' of total ' num2str(totalPart)]);
        end
        
      
        [corrfunArr, rwArr] = ...
            arrayfun(@ (xj,yj) onePartCorr(xj,yj,x,y,r,rareas),...
            x(indi:indf),y(indi:indf),'UniformOutput',false);

        rw = rw + sum(cell2mat(rwArr),1);
        
        g =  g + sum(cell2mat(corrfunArr),1);
      
    end
   
    g = g ./ rw;
    
    %truncate values that have not had contirbutions
    g = g(rw~=0);
    r = r(rw~=0);
    rw = rw(rw~=0);
    
end

function [corrfun, rw] = onePartCorr(xj,yj,x,y,r,rareas)

    %compute radiuses in the (xj,yj) centered coordinate system
    rho=hypot(x-xj,y-yj);
    rho=rho(logical(rho))';

    %compute maximum unbiased rho
    maxRho = min([max(x)-xj,xj-min(x),max(y)-yj,yj-min(y)]);
    
    %truncate to highest unbiased rho
    rho=rho(rho<maxRho);
    
    %indicate for which r-values the correlation function is computed
    rw=r*0;
    rw(r<maxRho)=1;

    %compute count with correct binning
    count=histc( rho,[-inf r]');
    count=count(2:end);

    %normalize density
    corrfun = count./rareas;  


end