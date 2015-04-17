clear, close all, clc

x=-1:0.1:1;
df=10;

#basis=BasisExpansions(x,df,'b-splines');
#plot(x,basis)

#basis=BasisExpansions(x,df,'natural-cubic');
#plot(x,basis)

y=[1:3 5 4 7:-1:3 2*(2:5) repmat(10,1, 4)]';
x=1:numel(y);
df=numel(x)+4;

basis=BasisExpansions(x,df,'smoothing','y',"[1:3 5 4 7:-1:3 2*(2:5) repmat(10,1, 4)]'",'lambda','0');
basis
figure
plot(1:numel(y),y,'o')
hold on
plot(basis)

basis=BasisExpansions(x,df,'smoothing','y',"[1:3 5 4 7:-1:3 2*(2:5) repmat(10,1, 4)]'",'lambda','100');
figure
plot(1:numel(y),y,'o')
hold on
plot(basis)
