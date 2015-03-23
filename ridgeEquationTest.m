# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
y=[ones(1000,1) xn]*beta+normrnd(0,1.5,1000,1);

lambda=0.01;
beta_hat=ridgeEquation(xn,y,lambda);
y_hat0=predictRidge(xn,beta_hat);
rss=ridgeRss(x,y,beta_hat,lambda,mu,sd)
rss=ridgeRss(xn,y,beta_hat,lambda)
[z x_approx]=pca(x,2);
