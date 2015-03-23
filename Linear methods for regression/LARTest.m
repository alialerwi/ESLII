# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
y=[ones(1000,1) xn]*beta+0*normrnd(0,1.5,1000,1);

alpha=0.1;
beta_hat0=LAR(x,y,alpha);
beta_hat1=LAR(x,y,alpha,lasso=1);

sum((beta-beta_hat0).^2)
sum((beta-beta_hat1).^2)