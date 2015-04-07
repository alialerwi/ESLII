function l=multiloglikelihood(x,y,beta)
  
  [m n]=size(x);
  l=0;
  for i=1:m
    l=l+x(i,:)*beta*y(i,:)'-log(1+sum(exp(x(i,:)*beta)));
  end



end
