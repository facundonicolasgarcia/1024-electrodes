function [cc_r] = box_count_modified(B,varargin)
c = B;
N1 = sum(B(:));
c = logical(squeeze(c));
dim = ndims(c); % dim is 2 for a vector or a matrix, 3 for a cube

% transpose the vector to a 1-by-n vector
if length(c)==numel(c)
    dim=1;
    if size(c,1)~=1
        c = c';
    end
end

width = max(size(c));    % largest size of the box
p = log(width)/log(2);   % nbre of generations

p = ceil(p);

n = zeros(1,p+1); % pre-allocate the number of box of size r
nr = zeros(1,p+1);
nn_elements = zeros(1,p+1);
nn2_elements = zeros(1,p+1);
%    case 2         %------------------- 2D boxcount ---------------------%
for g=(p-1):-1:0
    siz = 2^(p-g);
    siz2 = round(siz/2);
    
    count_nr = 0;
    sum_elements = 0;
    sum2 = 0;
    n_elements = 0;
    for i=1:siz:(width-siz+1)
        for j=1:siz:(width-siz+1)
            count_nr = count_nr + 1;
            n_elements = sum(sum(B(i:i+siz2,j:j+siz2))); %count the number of elements
            sum_elements = sum_elements + n_elements;
            sum2 = sum2 + sum_elements * sum_elements;
            c(i,j) = ( c(i,j) || c(i+siz2,j) || c(i,j+siz2) || c(i+siz2,j+siz2) ); % counts the boxes not how many elements inside each box
        end
    end
    n(g+1) = sum(sum(c(1:siz:(width-siz+1),1:siz:(width-siz+1))));
    nr(g+1) = count_nr;
    nn_elements(g+1) = sum_elements;
    nn2_elements(g+1) = sum2;
    
    % fprintf(1, '%d\t%g\t%g\t%g\n',g+1, n(g+1), nr(g+1), siz);
end



n = n(end:-1:1);
r = 2.^(0:p); % box size (1, 2, 4, 8...)
nr = nr(end:-1:1); % number of boxes of size r
nn_elements = nn_elements(end:-1:1);
nn2_elements = nn2_elements(end:-1:1);

% slope
% 
% figure
% subplot(211)

s = -diff(log(n))./diff(log(r));

% semilogx(r(1:end-1), s, 's-');

% a=axis;
% axis([a(1) a(2) 0 dim]);
% xlabel('r, box size'); ylabel('- d ln n / d ln r, local dimension');
% title([num2str(dim) 'D box-count']);

% subplot(212)
% loglog(r,n,'s-');
% xlabel('r, box size'); ylabel('n(r), number of boxes');
% title([num2str(dim) 'D box-count']);
% 
% figure
% loglog(r, nn2_elements/(N1*N1), '-o')

cc_r = nn2_elements / N1 / N1;
%cc_r = nn2_elements;

end

%delta_c = -log(1+(1-sample)/cc/sample);























