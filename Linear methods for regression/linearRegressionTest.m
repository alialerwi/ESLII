# test
clear; close all; clc;
x=10*rand(1000,9);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5]';
beta_multi=[10 0.5 1 0.001 1.6 -10^-11 3.2 5 0.00001 0.5;0.005 0.01 0.2 4.3 4 0.5 6 1.7 8 2.9]';
y=[ones(1000,1) xn]*beta;
ym=[ones(1000,1) xn]*beta_multi;

standardize=1;

disp('------------------------------------------------------')
tic
model=LinearRegression(x,y,standardize,'normal');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
model=LinearRegressionMulti(x,ym,standardize,'normal');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))
toc

disp('------------------------------------------------------')
tic
options={'lambda','0.001'};
model=LinearRegression(x,y,standardize,'ridge',options);
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
model=LinearRegression(x,y,standardize,'lar');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
options={'zero_value','10^-10'};
model=LinearRegression(x,y,standardize,'lar-lasso',options);
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
options={'threshold','0.99'};
model=LinearRegression(x,y,standardize,'pcr',options);
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
model=LinearRegression(x,y,standardize,'pls');
model.type
y_hat=predict(x,model);
rss=sum((y-y_hat).^2)
toc

disp('------------------------------------------------------')
tic
model=LinearRegressionMulti(x,ym,standardize,'reduced rank');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))
toc

disp('------------------------------------------------------')
tic
model=LinearRegressionMulti(x,ym,standardize,'curds-whey');
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))
toc

disp('------------------------------------------------------')
tic
options={'lambda','0.01'};
model=LinearRegressionMulti(x,ym,standardize,'hybrid',options);
model.type
y_hat=predict(x,model);
rss=sum(sum((ym-y_hat).^2))
toc