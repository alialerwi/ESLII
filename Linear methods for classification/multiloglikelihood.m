function [l p]=multiloglikelihood(X,Y,beta,K)
  
  if ~exist('K', 'var') || isempty(K)
    K=2;
  end
  [M N]=size(X);
  m=M/(K-1);
  n=(N/(K-1))-1;
  
  P=logit(X,beta,K);
  
  y=reshape(Y,m,K-1);
  y=[sum(y,2)==0 y];
  p=reshape(P,m,K-1);
  p=[(ones(m,1)-sum(p,2)) p];
  l=sum(log(sum(y.*p,2)));

end
