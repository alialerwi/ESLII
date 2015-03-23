# test
clear; close all; clc;
#x=10*rand(100,9);
#beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
x=10*rand(100,3);
beta=[3 0.5 3 0.001]';
y=[ones(100,1) normalize(x)]*beta+0.5*stdnormal_rnd(100,1);
k=1;
[beta_hat comb rss]=subsetSelection(x,y,k);
X=[ones(100,1) normalize(x(:,comb))];
y_hat=normalPredict(X,beta_hat);
rss1=normalRss(X,y,beta_hat)
