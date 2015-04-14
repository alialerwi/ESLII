clear, close all, clc

x=-1:0.05:1;
M=4;
K=3;

basis=BasisExpansions(x,M,K,'b-splines');
basis=BasisExpansions(x,M,K,'natural-cubic');
plot(x,basis(:,2))
