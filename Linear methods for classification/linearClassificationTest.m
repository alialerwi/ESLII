# test
clear; close all; clc;
x=sign(rand(1000,3)-0.5);
beta=[0 1 -0.1 0.2]';
#y=[ones(1000,1) x]*beta>0;

y=[ones(1000,1) x]*beta;
u=zeros(1000,1);
  u(y<=-0.7)="a";
  u(y>0)="b";
  u(y>0.7)="c";   

y=u;
  
standardize=1;

y_hat=zeros(size(y));
perf=100*mean(y==y_hat)
y_hat=ones(size(y));
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'indicator_matrix');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'lda');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'RR-lda');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'qda','alpha','0.1','gamma','0.9');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'logit');
model.type
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'multi-logit');
model.type
loglikelihood=model.loglikelihood
y_hat=classify(x,model);
perf=100*mean(y==y_hat)

model=LinearClassification(x,y,standardize,'L-multi-logit','lambda','1000','penalty','2');
model.type
loglikelihood=model.loglikelihood
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
