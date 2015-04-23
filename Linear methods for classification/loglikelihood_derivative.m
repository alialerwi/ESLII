function derivative=loglikelihood_derivative(X,Y,beta,K,options={})

  for i=2:2:numel(options) 
   eval(strcat(options{(i-1)}, '=', num2str(options{i}),';'));
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
  
  switch penalty
    case {-1,0}
      derivative=X'*(Y-P);
    case 1
      lambda_vec=lambda*ones(size(beta));
      lambda_vec((n+1)*(0:(K-2))+1,1)=0;
      derivative=X'*(Y-P)-lambda_vec.*sign(beta);
    case 2
      lambda_vec=lambda*ones(size(beta));
      lambda_vec((n+1)*(0:(K-2))+1,1)=0;
      derivative=X'*(Y-P)-2*lambda_vec.*beta;
  
  endswitch
  
end