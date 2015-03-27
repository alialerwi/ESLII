# test
clear; close all; clc;
x=10*rand(1000,9);
[m n]=size(x);
[xn mu sd]=normalize(x);
beta=[1 0 1 0 1 0 1 0 1 0;0 1 0 1 0 1 0 1 0 1;1 -1 1 -1 1 -1 1 -1 1 -1;0 1 4 1 1 1 2 1 3 1;1 -0 1 -0.3 1.002 -0.0001 9 -.2 0.5 2]';
y=[ones(1000,1) xn]*beta;
[m K]=size(y);

u=CCA(normalize(x),y);
Brr=RRregression(normalize(x),y,5);
Yrr=RRprediction(normalize(x),Brr);

sum(sum((y-Yrr).^2))

