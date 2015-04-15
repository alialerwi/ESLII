clear, close all, clc

x=-1:0.1:1;
df=7;

basis1=BasisExpansions(x,df,'b-splines');
plot(x,basis1)

basis2=BasisExpansions(x,df,'natural-cubic');
plot(x,basis2)

y=[1:3 5 4 7:3 2*(2:5) repmat(10, 1,4)]';
x=1:0.085:numel(y);