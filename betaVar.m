function beta_var=betaVar(X,y,beta_hat)
  
  [m n]=size(X);
  
  y_hat=normalPredict(X,beta_hat);
  
  sigma2=(1/(m-n))*sum((y-y_hat).^2);
  beta_var=(pinv(X'*X).*sigma2);
    
  end
  