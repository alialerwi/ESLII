# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
y=[ones(1000,1) xn]*beta+0*normrnd(0,1.5,1000,1);

l=size(x,2);
pls(x,y,9);
#y_hat0=xn*B;
#sum((y-y_hat0).^2)


#x0=[ones(size(xn,1),1) xn];
#y_hat1=x0*pinv(x0'*x0)*x0'*y;
#sum((y-y_hat1).^2)
