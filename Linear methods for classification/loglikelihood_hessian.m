function hessian=loglikelihood_hessian(X,beta,K,varargin)
  
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
  
  P=logit(X,beta,K);
  W=weight_matrix(X,P,K);
  
  switch penalty
    case 0
      hessian=-X'*W*X;  
    case 1
    ### not implemented
    case 2
      lambda_mat=lambda*eye(size(beta,1),size(beta,1));
      lambda_mat((n+1)*(0:(K-2))+1,(n+1)*(0:(K-2))+1)=0;
      hessian=-X'*W*X-2*lambda_mat;  
  
  endswitch 
  
end