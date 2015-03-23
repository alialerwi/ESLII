function ci=confidenceInterval(X,y,beta_hat,alpha)
  
  [m n]=size(X);
  beta_var=betaVar(X,y,beta_hat);
  se=sqrt(diag(beta_var))(:);
  ci=beta_hat-tinv((1-alpha/2),m-n).*se;
  ci=[ci beta_hat];
  ci=[ci beta_hat+tinv((1-alpha/2),m-n).*se];
  
end

