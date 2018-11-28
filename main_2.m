clear all; close all; clc;

name = 'lena';
n = 256;
f0 = load_image(name);
f0 = rescale(crop(f0,n));
clf;
imageplot(f0);

rho = .5;
Lambda = rand(n,n)>rho;
Phi = @(f)f.*Lambda;

y = Phi(f0);
%imageplot(y);

%% Partie 2

K = @(f)grad(f);
KS = @(u)-div(u);
Amplitude = @(u)sqrt(sum(u.^2,3));
F = @(u)sum(sum(Amplitude(u)));

ProxF = @(u,lambda)max(0,1-lambda./repmat(Amplitude(u),[1 1 2])).*u;

ProxFS = @(y,sigma)y-sigma*ProxF(y/sigma,1/sigma);

ProxG = @(f,tau)f + Phi(y - Phi(f));

L = 8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1;
f = y;
g = K(y)*0;
f1 = f;

% fold = f;
% g = ProxFS(g+sigma*K(f1),sigma);
% f = ProxG(f-tau*KS(g),tau);
% f1 = f + theta*(f-fold);

N=200;
for i=1:N
    fold = f;
    g = ProxFS(g+sigma*K(f1),sigma);
    f = ProxG(f-tau*KS(g),tau);
    f1 = f + theta*(f-fold);
    %imageplot((f));
    %pause;
end
    

figure();
subplot(1,2,1);
imshow(y, []);
str = sprintf('Image originale déteriorer rho=%f%%', rho*100);
title(str);
subplot(1,2,2);
imshow(f, []);
title('Image résultat');



