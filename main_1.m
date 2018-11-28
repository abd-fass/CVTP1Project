clear all; close all; clc;
%%%
name = 'lena';
n = 512;
f0 = load_image(name);

rho = 0.5;
Lambda = rand(n,n)>rho;
Phi = @(f)f.*Lambda;

y = Phi(f0);


SoftThresh = @(x,T)x.*max(0, 1-T./max(abs(x),1e-10));
Jmax = log2(n)-1;
Jmin = Jmax-3;
options.ti = 0; % use orthogonality.
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
SoftThreshPsi=@(f,T)Psi(SoftThresh(PsiS(f),T));

%Mask
rho = .5; % a varié
Lambda = rand(n,n)>rho;

%% Boucle SoftThrash
f01=f0.*Lambda;
%y=f01;
y = Phi(f0);
F=50;
T = linspace(20,0,F); % le 20 est à varié
for i=1:F
    y_res=SoftThreshPsi(y,T(i));
    y=f01+y_res.*not(Lambda);
    
end

figure();
subplot(1,2,1);
imshow(uint8(f01));
title('Image originale détériorer à 80%');
subplot(1,2,2);
imshow(uint8(y));
title('Image résultat du seuillage itératif SoftThrash');

%% Boucle HardThrash

HardThresh = @(x,T)x.*(abs(x)>T);
HardThreshPsi=@(f,T)Psi(HardThresh(PsiS(f),T));

%Mask
rho = .5; % a varié
Lambda = rand(n,n)>rho;

f01h=f0.*Lambda;
%yh=f01h;
yh = Phi(f0);
F=50;
T = linspace(1,250,F); % le 20 est à varié
for i=1:F
    yh_res=HardThreshPsi(yh,T(i));
    yh=f01h+yh_res.*not(Lambda);    
end

figure();
subplot(1,2,1);
imshow(uint8(f01h));
title('Image originale détériorer à 80%');
subplot(1,2,2);
imshow(uint8(yh));
title('Image résultat du seuillage itératif HardThrash');










