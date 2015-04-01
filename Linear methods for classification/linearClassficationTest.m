# test
clear; close all; clc;
x=sign(rand(1000,3)-0.5);
beta=[0 1 -0.1 0.2]';
y=[ones(1000,1) x]*beta>0;

standardize=1;

model=LinearClassification(x,y,standardize,'indicator_matrix');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'lda');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'qda');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'rda','alpha','0.05');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)