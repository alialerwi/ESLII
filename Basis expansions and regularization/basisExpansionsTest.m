clear, close all, clc

x=-1:0.1:1;
df=7;

basis=BasisExpansions(x,df,'b-splines');
plot(x,basis)

<<<<<<< HEAD
basis2=BasisExpansions(x,df,'natural-cubic');
plot(x,basis2)

y=[1:3 5 4 7:3 2*(2:5) repmat(10, 1,4)]';
x=1:0.085:numel(y);
=======
basis=BasisExpansions(x,df,'natural-cubic');
plot(x,basis)

y=[1:3 5 4 7:3 2*(2:5) repmat(10,1, 4)]';
x=1:numel(y)

basis=BasisExpansions(x,df,'smoothing','y',"[1:3 5 4 7:3 2*(2:5) repmat(10,1, 4)]'");
plot(x,basis)
>>>>>>> 503ee27582da0f69e069d4ea8101d28566715adc
