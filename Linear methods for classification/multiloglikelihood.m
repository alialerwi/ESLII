function [l p]=multiloglikelihood(X,Y,beta,K,varargin)

  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', num2str(varargin{i}),';'));
  end
  if ~exist('K', 'var') || isempty(K)
    K=2;
  end
  if ~exist('lambda', 'var') || isempty(lambda)
    lambda=0;
  end
  if ~exist('penalty', 'var') || isempty(penalty)
    penalty=0;
  end
  
  # calculate original sizes
  [M N]=size(X);
  m=M/(K-1);
  n=(N/(K-1))-1;
  
  # calculate probabilities
  P=logit(X,beta,K);
  
  y=reshape(Y,m,K-1);
  y=[sum(y,2)==0 y];
  p=reshape(P,m,K-1);
  p=[(ones(m,1)-sum(p,2)) p];
  
  # calculate log-likelihood
  switch penalty
    case -1
      l=sum(log(sum(y.*p,2)));
    case 0
      lambda_vec=lambda*ones(size(beta));
      lambda_vec((n+1)*(0:(K-2))+1,1)=0;
      l=sum(log(sum(y.*p,2)))-sum(lambda_vec);
    case 1
      lambda_vec=lambda*ones(size(beta));
      lambda_vec((n+1)*(0:(K-2))+1,1)=0;
      l=sum(log(sum(y.*p,2)))-sum(lambda_vec.*(abs(beta)));  
    case 2
      lambda_vec=lambda*ones(size(beta));
      lambda_vec((n+1)*(0:(K-2))+1,1)=0;
      l=sum(log(sum(y.*p,2)))-sum(lambda_vec.*(beta.^2));  
  endswitch
  
end
