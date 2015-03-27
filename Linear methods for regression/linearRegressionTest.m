# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5]';
beta_multi=[10 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5;0.005 0.01 0.2 4.3 4 0.5 6 1.7 8 2.9]';
y=[ones(1000,1) xn]*beta;
ym=[ones(1000,1) xn]*beta_multi;

standardize=1;

model=LineaR(x,y,standardize,'normal');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaRmulti(x,ym,standardize,'normal');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))

model=LineaR(x,y,standardize,'ridge','lambda','0.001');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'lar');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'lar-lasso','zero_value','10^-10');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'pcr','threshold','0.99');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaR(x,y,standardize,'pls');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)

model=LineaRmulti(x,ym,standardize,'reduced rank');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))

model=LineaRmulti(x,ym,standardize,'curds-whey');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))

model=LineaRmulti(x,ym,standardize,'hybrid','lambda','0.01');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))