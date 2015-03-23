# test
clear; close all; clc;
x=10*rand(100,9);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
y=[ones(100,1) normalize(x)]*beta;
k=1;
[beta_hat comb]=forwardStagewise(normalize(x),y);
