function beta_hat=ridgeEquation(x,y,lambda) 
  
  [m n]=size(x);
  I=eye(n);
  beta_hat=[mean(y);pinv(x'*x+lambda.*I)*x'*y];

end