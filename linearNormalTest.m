# test
clear; close all; clc;
x=10*rand(100,9);
beta=[1 2 3 4 1 2 3 4 1 2]';
y=[ones(100,1) normalize(x)]*beta;
[beta_hat beta_sd beta_ci y_hat rss]=linearRegression(x,y);
f_test=Ftest(x,x(:,1:7),y)
beta
beta_ci

plot(x,y,'.')
hold on 
plot(x,y_hat,'x')
