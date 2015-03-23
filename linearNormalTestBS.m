# test
clear; close all; clc;
x=10*rand(1000,9);
beta=[1 0.5 1 0.001 1.6 0 3.2 5 1 0.5]';
y=[ones(1000,1) normalize(x)]*beta+normrnd(0,1.5,1000,1);

k=1;
[beta_hat p_value]=backwardSelection(normalize(x),y,k);

