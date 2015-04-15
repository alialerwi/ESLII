clear, close all, clc

x=-1:0.1:1;
df=7;

basis1=BasisExpansions(x,df,'b-splines');
plot(x,basis1)

basis2=BasisExpansions(x,df,'natural-cubic');
plot(x,basis2)
