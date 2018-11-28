clear all; close all; clc;

%%%
w = 10; % Widthw of thepatches.
n = w*w; % Dimension n=wxw of the data to be sparse coded .
p = 2*n; % Number of atoms p in the dictionary.
m = 20*p; % Number m of patches used for the training.
k = 4; % Target sparsity
%
sd = .06; % Gaussian noiss standard deviation
n0 = 256; % Image size
f0 = rescale(crop(load_image('barb'), n0));
f = f0+sd*randn(n0);
imageplot(clamp(f));

q = 3*m;
x = floor(rand(1, 1, q)*(n0-w)) +1;
y = floor(rand(1, 1, q)*(n0-w) ) +1;

[dY,dX] = meshgrid (0:w-1,0:w-1);
Xp = repmat(dX,[1 1 q] )+repmat(x, [w w 1]);
Yp = repmat(dY, [1 1 q])+repmat(y,[w w 1]);
Y = f(Xp+(Yp-1)*n0);
Y = reshape(Y, [n q]);

Y = Y - repmat(mean(Y),[n 1]);
[tmp, I] = sort(sum(Y.^2),'descend');
Y = Y(:,I(1:m));



