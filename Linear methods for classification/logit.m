function P=logit(X,beta,K)

  if ~exist('K', 'var') || isempty(K)
    K=2;
  end
  [M N]=size(X);
  m=M/(K-1);
  n=(N/(K-1))-1;
  P=zeros((K-1)*m,1);
  
  z=X*beta;
  num=exp(z);

  
  for i=1:m
    id=m*(0:(K-2))+i;
    den=1+sum(exp(z(id,1)));
    P(id,1)=num(id)/den;
  end
   
end
