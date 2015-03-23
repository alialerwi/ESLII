# test
clear; close all; clc;
x=10*rand(100,9);
beta=[1 0 1 0 1 0 1 0 1 0;3 1 0 1 0 1 0 1 0 1]';
y=[ones(100,1) normalize(x)]*beta;
[beta_hat beta_sd beta_ci y_hat b_k rss]=linearRegression(x,y);
#f_test=Ftest(x,x(:,1:7),y)
beta;
beta_ci;

plot(x,y(:,1),'.')
hold on
plot(x,y(:,2),'0')

plot(x,y_hat(:,1),'x')
plot(x,y_hat(:,2),'+')
