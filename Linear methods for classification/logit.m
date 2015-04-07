function P=logit(X,beta,K)

  if ~exist('K', 'var') || isempty(K)
    K=2;
  end
  [M N]=size(X);
  m=M/(K-1);
  n=(N/(K-1))-1;
  P=zeros((K-1)*m,1);
  for i=1:(K-1)
    P((m*(i-1)+1):(m*i),1)=exp(X((m*(i-1)+1):(m*i),((n+1)*(i-1)+1):((n+1)*i))*beta(((n+1)*(i-1)+1):((n+1)*i),1))./(1+exp(X*beta));
  end
  
end
