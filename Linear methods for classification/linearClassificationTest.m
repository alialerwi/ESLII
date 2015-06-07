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

disp('------------------------------------------------------')
tic
model=LinearClassification(x,y,standardize,'indicator_matrix');
disp(strcat('model type:',' ',model.type));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
model=LinearClassification(x,y,standardize,'lda');
disp(strcat('model type:',' ',model.type));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
model=LinearClassification(x,y,standardize,'RR-lda');
disp(strcat('model type:',' ',model.type));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
options={'alpha','0.1','gamma','0.9'};
model=LinearClassification(x,y,standardize,'qda',options);
disp(strcat('model type:',' ',model.type));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
model=LinearClassification(x,y,standardize,'logit');
disp(strcat('model type:',' ',model.type));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
options={'lambda','10','penalty','-1'};
model=LinearClassification(x,y,standardize,'multi-logit',options);
disp(strcat('model type: ',model.type,', ','penalty: L',num2str(model.penalty)));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
options={'lambda','10','penalty','0'};
model=LinearClassification(x,y,standardize,'multi-logit',options);
disp(strcat('model type: ',model.type,', ','penalty: L',num2str(model.penalty)));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
options={'lambda','10','penalty','1'};
model=LinearClassification(x,y,standardize,'multi-logit',options);
disp(strcat('model type: ',model.type,', ','penalty: L',num2str(model.penalty)));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')
tic
options={'lambda','10','penalty','2'};
model=LinearClassification(x,y,standardize,'multi-logit',options);
disp(strcat('model type: ',model.type,', ','penalty: L',num2str(model.penalty)));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
toc

disp('------------------------------------------------------')

x=[1:18]';
y=[sign(sin(x))](:);

tic
options={'lambda','1'};
standardize=0;
model=LinearClassification(x,y,standardize,'smoothing spline',options);
y_hat=classify(x,model);
perf=100*mean(y==y_hat)
plot(x,y_hat,'*')
hold on 
plot(x,y,'o')

disp(strcat('model type: ',model.type,', '));
disp(strcat('loglikelihood: ',num2str(model.loglikelihood)));
x_new=[1:0.3:5]';
y_real=[sign(sin(x_new))];
y_hat=classify(x_new,model);
perf=100*mean(y_real==y_hat)
toc

