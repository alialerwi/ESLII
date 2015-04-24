function hessian=loglikelihood_hessian(X,beta,K,options={})
  
  for i=2:2:numel(options) 
    eval(strcat(options{(i-1)}, '=[', num2str((options{i})(:)'),'];'))
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
    case {-1,0}
      hessian=-X'*W*X;  
    case 1
      epsilon=10^(-4);
      lambda_mat=lambda*eye(size(beta,1),size(beta,1));
      lambda_mat((n+1)*(0:(K-2))+1,(n+1)*(0:(K-2))+1)=0;
      sign_dev=((epsilon.^2)./((beta.^2+epsilon.^2).^(1.5))).^0.5;
      hessian=-X'*W*X-lambda_mat.*(sign_dev*sign_dev');#numerical approximation of sign derivative
    case 2
      lambda_mat=lambda*eye(size(beta,1),size(beta,1));
      lambda_mat((n+1)*(0:(K-2))+1,(n+1)*(0:(K-2))+1)=0;
      hessian=-X'*W*X-2*lambda_mat; 
  
  endswitch 
  
end