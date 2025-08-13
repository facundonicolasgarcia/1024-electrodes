% Code to see the effect of subsampling on the two ppoun correlation
% exponent as well as over the DF
%
%% el codigo original fue usado para analizar imagenes de Nahuel
%%'/Users/dantechialvo/Desktop/Mis_WorkingManuscritos/Nahuel Zamponi/Datos_Clusters_Skeletons'

clear all
close all
clc

% Cantor set (here in 1 D)
% dfCalc = 1+log2(p1);
% etaCalc = -1*log2(p1);

% 100 micras 652 pixeles

p = 0.8;
N = 128;

clear x y pi pj

u = randcantor(p,N,2);  % Build the Cantor set
figure; imagesc(u);
hold on

surro = zeros(N,N);

clear pi pj
[pi,pj] = find(u == 1);
largo = length(pi);
%%

k = 0;
for sample = 1:-.1:.1 %probability s of remaining in the cantor set
    
    k = k + 1;
    samp(k)= sample;
    clear x y
    
    ceil(sample*largo)
    pikk = randi(largo,ceil(sample*largo),1);  % I choose samples at random location from the image
    
    x = pi(pikk); 
    y = pj(pikk);
    dr = 2;
        
    
    size(x)
    surro = zeros(N,N);
    for h = 1:length(x)
        surro(x(h),y(h))=1;
    end
    
    
    % box count - for theoretical plot
  
    clear cc_r
    cc_r = box_count_modified(surro);
    cc_sample(k,:) = cc_r; 
        
    %
    clear corrfun r rw
    [ corrfun r rw] = twopointcorr(x,y,dr); % computo 2Point Corr
    
    subplot(3,1,1)
    title('two point corr')
    plot(log10(r),log10(corrfun),'-x')
    ejex = log10(r);
    ejey = log10(corrfun);
    xlabel ('distance r')
    ylabel ('Corr(r)')
    
    %axis([0  1  1.1])
    
    %nu=-diff(log(r))./diff(log(corrfun));
    coef = polyfit(ejex(1:5),ejey(1:5),1);
    etaFit = coef(1);
    disp(['two point corr = ' num2str(etaFit)]);
    Nnu(k)= etaFit;
    hold on
    drawnow
    grid on
    
    subplot(3,1,2)
    [n,rr] = boxcount2(surro,'slope');
    
    df=-diff(log(n))./diff(log(rr));
    %
    disp(['Fractal dimension, Df = ' num2str(mean(df(4:7))) ' +/- ' num2str(std(df(4:7)))]);
    ddf(k) = mean(df(3:7));
    sdf(k) = std(df(4:7));
    hold on
    
    
    subplot(3,1,3)
    spy2(u,'oy')
    hold on
    spy2(surro,'xr')
%   pause
    
end

figure;
semilogx(rr,-log(1+(1./cc_sample)),'-o')



%delta_c = (-log(1+((1-s)/s)*1./cc_sample))/abs(log(rr));
%%

figure

for k=2:length(samp)-2
    clear cc_s delta_c
    s = (1.0 - samp(k))/samp(k);
    cc_s(:) = cc_sample(k,:);
    rk = rr(k);
    delta_c = (-log(1+s./cc_s)/abs(log(rk)));
%    loglog(rr, 128*128*128*128*delta_c, '-o')
    loglog(rr, delta_c, '-o')

    hold on
    clear table
    table = [log(rr') log(delta_c')];
    fprintf(1,'%g\n',s);
    dlmwrite(sprintf('delta_c%g.dat', samp(k)), table, 'delimiter', '\t');
end
grid on

%%

figure;
subplot(3,1,1)

plot(samp,Nnu,'-o')
title('\eta versus subsampling')
xlabel('Subsampling fraction')
ylabel('\eta')
subplot(3,1,2)
title('df (+/- sd) versus subsampling')
errorbar(samp,ddf,sdf,'-x')
xlabel('Subsampling fraction')
ylabel('df')
subplot(3,1,3)
plot(ddf,Nnu,'-x')
xlabel('df')
ylabel('\eta')

