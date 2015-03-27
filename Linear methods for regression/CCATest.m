# test
clear; close all; clc;
x=10*rand(1000,9);
[m n]=size(x);
[xn mu sd]=normalize(x);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5;1 5 0.1 0.1 6 0 0.2 5 1 5;1 2 3 4 5 6 7 8 9 10]';
y=[ones(1000,1) xn]*beta;
[m K]=size(y);

u=CCA(x,y);

