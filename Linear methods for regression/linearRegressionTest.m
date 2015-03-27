# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5]';
y=[ones(1000,1) xn]*beta+0*stdnormal_rnd(1000,1);

standardize=1;

model=LineaR(x,y,standardize,'normal');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'ridge','lambda','0.01');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'lar');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'lar-lasso','zero_value','10^-10');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'pcr','threshold','0.99');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'pls','threshold');
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)