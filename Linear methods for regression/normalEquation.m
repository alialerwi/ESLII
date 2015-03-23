function beta_hat=normalEquation(X,y)

  beta_hat=pinv(X'*X)*X'*y;  
  
  end