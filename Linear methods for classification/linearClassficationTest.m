# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5]';
beta_multi=[10 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5;0.005 0.01 0.2 4.3 4 0.5 6 1.7 8 2.9]';
y=[ones(1000,1) xn]*beta>0;

standardize=1;

model=LinearClassification(x,y,standardize,'normal');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)