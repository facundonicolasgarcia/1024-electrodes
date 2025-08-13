% Code to see the effect of subsampling on the two ppoun correlation
% exponent as well as over the DF
%
%% el codigo original fue usado para analizar imagenes de Nahuel
%%'/Users/dantechialvo/Desktop/Mis_WorkingManuscritos/Nahuel Zamponi/Datos_Clusters_Skeletons'


clear

% Cantor set (here in 1 D)
% dfCalc = 1+log2(p1);
% etaCalc = -1*log2(p1);

 close all
%100 micras 652 pixeles 

w=0;
nodo=0;
 
  p=.8;
  N=128;
 
close all
       clear c c0 x y cc pi pj
    
         
 
 
        
    clear c c1
  
 
 
  u = randcantor(p,N,2);  % Build the canto set
  
 surro=zeros(N,N);
  clear pi pj
[pi,pj]=find(u == 1);
largo=length(pi);
k=0;
for sample=1:-.1:.1
    
    k=k+1;
    samp(k)=sample;
    clear x y 
    
    ceil(sample*largo)
    pikk=randi(largo,ceil(sample*largo),1);  % I choose samples at random location from the image



x=pi(pikk); y=pj(pikk);dr=2;


 
size(x)
 surro=zeros(N,N);
for h=1:length(x)
    surro(x(h),y(h))=1;
end

 
 
%% 
clear corrfun r rw 
[ corrfun, r, rw] = twopointcorr2d(x,y,dr); % computo 2Point Corr


subplot(3,1,1)
title('two point corr')
plot(log10(r),log10(corrfun),'-x')
ejex=log10(r);
ejey=log10(corrfun);
xlabel ('distance r')
ylabel ('Corr(r)')

%axis([0  1  1.1])

%nu=-diff(log(r))./diff(log(corrfun));
coef = polyfit(ejex(1:5),ejey(1:5),1);
etaFit = coef(1);
disp(['two point corr = ' num2str(etaFit)]);
Nnu(k)=etaFit;
hold on
drawnow
grid on
 
subplot(3,1,2)
[n,rr]=boxcount1(surro,'slope');
 
df=-diff(log(n))./diff(log(rr));
% 
disp(['Fractal dimension, Df = ' num2str(mean(df(4:7))) ' +/- ' num2str(std(df(4:7)))]);
ddf(k)=mean(df(3:7));
sdf(k)=std(df(4:7));
hold on


subplot(3,1,3)
spy(u,'oy')
hold on
spy(surro,'xr')
 pause

end

 

 

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
 
 