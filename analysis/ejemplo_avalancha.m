%% Ejemplo avalanchas

close all
clear all
clc

acti = rand(1000, 1); %ejemplo con una serie aleatoria, reemplazar por la serie de neuronas activas
thre=0.2;  % thresholds para definir una avalancha

%acti is the timeseries at each time step of the neurons being active
T = length(acti);

clear dur suma ti

ava = 0;
sumaava = 0;
dura = 0;
flag = 0;
eve = 0;

%%%%%%%%%%%%%%%% MAIN LOOP TO SEARCG FOR AVALANCHES
for t=1:T-1
   
    if (acti(t)) > thre; flag = 1;end
    if (acti(t)) <= thre; flag = 0;end
    
    if flag == 1 & (acti(t)) > thre
        sumaava = sumaava + (acti(t));
        dura = dura+1;
    end
    
    
    if flag == 0 & (acti(t+1)) > thre
        eve=eve+1;
        
        ti(eve)=t;
        
        
    end
    
    if flag == 1 & (acti(t+1)) <= thre
        ava=ava+1;
        suma(ava)=sumaava +(thre*dura); % size avalanche number ava es sumaava
        dur(ava)=dura;
        sumaava=0;
        dura=0;
    end
    
    
    
end
%%%%%%%%%%%%%%%%END OF MAIN LOOP TO SEARCG FOR AVALANCHES

%% Agregado por Facundo
% compute spatial average and fluctuations
avg=mean(acti);
fluctuation=acti-avg;

% compute activity
activity=(abs(fluctuation)>thre);
[durations, sizes] = avalanche_hunter(activity);
%% THESE ARE CALCULATIONS OF HISTOGRAMS ETC
ti1=ti;
clear ejex ejey

%
%%%%%%%%%%%%%%%%%%%% LOGARITHMIC BINING
pasito=.25;
kk=0;
clear ejex1 ejey1
for i1=0.: pasito: sqrt(max(suma))+pasito
    
    low=2^i1;
    up=2^(i1+pasito);
    
    adentro=find(suma > low & suma <= up) ;
    if length(adentro) > 0
        kk=kk+1;
        ejey1(kk)=length(adentro);
        ejex1(kk)=low+(up/2);
    end
end
ejex1=log10(ejex1);
ejey1=log10(ejey1);



kk=0;
clear ejexD1 ejeyD1
for i1=0.: pasito: sqrt(max(dur))+pasito
    
    low=2^i1;
    up=2^(i1+pasito);
    
    adentro=find(dur > low & dur <= up) ;
    if length(adentro) > 0
        kk=kk+1;
        ejeyD1(kk)=length(adentro);
        ejexD1(kk)=low+(up/2) ;
    end
end

%%
figure(1);
subplot(2, 3, 1);
plot(ejex1,ejey1,'-o')
hold on
ylabel('Size')
drawnow
grid on

subplot(2, 3, 2);
plot(ejexD1,ejeyD1,'-o')
hold on
ylabel('Durat')
drawnow
grid on

subplot(2, 3, [4 5]);
loglog(dur,suma,'x')
ylabel('Size')
xlabel('Duration')
grid on
hold on

%%
[dur_counts, dur_values] = hist(durations, 10);
[size_counts, size_values] = hist(sizes, 10);

figure(2);
subplot(2,1,1);
plot(durations);
subplot(2,1 ,2);
plot(sizes);

figure(3);
% Subplot Sizes (top-left)
subplot(2, 2, 1);
plot(size_values, size_counts, '-o', Color='red');
%title('Size');
xlabel('Size');

% Subplot Durations (top-right)
subplot(2, 2, 2);
plot(dur_values, dur_counts, '-o', color='red');
%title('Duration');
xlabel('Duration');

% Subplot Sizes vs Durations
subplot(2, 2, [3 4]);
loglog(durations, sizes, 'x', Color='red');
%title('Sizes vs Durations');
xlabel('Duration');
ylabel('Size');
