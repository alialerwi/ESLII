clear, close all, clc

x=-100:0.1:100;
M=2;
K=5;

basis=BasisExpansions(x,M,K,'b-splines');
basis=BasisExpansions(x,M,K,'natural-cubic');
plot(x,basis)

