clear 
close all

% Cantor set (here in 1 D)
% dfCalc = 1+log2(p1);
% etaCalc = -1*log2(p1);
%https://en.wikipedia.org/wiki/List_of_fractals_by_Hausdorff_dimension
%%deterministic the df =log _{3}(2) 0.6309
L = 1024;   % side length
dim = 2; % dimensions
%p = 0.7; % characteristic probability
minimun_number=20; % just the smallest number of points that make sense
N = L^dim; % total number of sites
dr = 1;
cutoff = 20;
sample = 64;

P = 0.7:0.025:0.99;

eta = zeros(1,length(P));
eta_err = zeros(1,length(P));
df = zeros(1,length(P));
df_err = zeros(1,length(P));

for j = 1:length(P)
    p = P(j);
    aux = zeros(sample,L/2);
    disp(j);
     muestras(j)=0;
    for i = 1:sample
        u = randcantor(p,N,1);  % Build the canto set
        x=find(u == 1);
        dr=1;
        if length(x) > minimun_number
        [corrfun r rw] = twopointcorr2d(x,dr); % computo 2Point Corr
        aux(i,1:length(r)) = corrfun;
        muestras(j)=muestras(j)+1;
        end
    end
    
    
    
    z = sum(aux,1)./sum(logical(aux),1);
    z = z(1:cutoff);
    r = dr*(1:length(z));
    r = r(1:cutoff);
    
    x = log(r);
    y = log(z);
    
    dx = (max(x)-min(x))/(L^(1/3));
    [xhist,xbins] = histcounts(x,min(x):dx:max(x));
    
    xcorrect = zeros(1,length(xhist));
    ycorrect = zeros(1,length(xhist));
    
    for i = 1:length(xhist)
        cond = (x >= xbins(i)).*(x < xbins(i+1));
        X = x(cond==1);
        Y = y(cond==1);
        xcorrect(i) = mean(X);
        ycorrect(i) = mean(Y);
    end
    
    %plot(xcorrect,ycorrect,'o');
    
    %coef = polyfit(xcorrect,ycorrect,1);
    %etaFit = coef(1);
    
    a = fitlm(xcorrect,ycorrect);
    coef = table2array(a.Coefficients);
    eta(j) = coef(2,1);
    eta_err(j) = coef(2,2);
    
    
    [a,b,c] = boxcount1(u,'slope');
    
    df(j) = mean(c(1:6));
    df_err(j) = std(c(1:6))^2;
    
end

% analitic 
nulo=(find(muestras == 0));
eta(nulo)=[];
eta_err(nulo)=[];
P(nulo)=[];
df(nulo)=[];
df_err(nulo)=[];

subplot(2,1,1)
p1 =P;

dfCalc = 1+log2(p1);
etaCalc = -1*log2(p1);
plot(etaCalc,dfCalc,'.-');


hold on
errorbar(-eta,df,df_err,df_err,eta_err,eta_err,'.');
xlabel('1 + \eta');ylabel('df');
title('Hyperscaling relation in the Random Cantor Set');
legend('Analytical','Numerical');

subplot(2,1,2)
plot(P,df,'-o',P,-eta,'-x')
legend('df','1+\eta');


ylabel('1 + \eta ; df');
xlabel('P')