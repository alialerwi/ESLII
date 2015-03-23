function [beta_hat beta_sd beta_ci y_hat b_k rss]=linearRegression(x,y,alpha=0.05)

  [m n]=size(x);
  K=size(y,2);
  [xn mu sd]=normalize(x);
  clear x;
  X=[ones(m,1) xn];
  clear xn;
  
  beta_hat=normalEquation(X,y);
  
  b_k=[];
  beta_sd=[];
  beta_ci=[];
  
  for k=1:K
    beta_var=betaVar(X,y(:,k),beta_hat(:,k));
    beta_sd=[beta_sd; (diag(beta_var).^0.5)(:)];
    beta_ci=[beta_ci; confidenceInterval(X,y(:,k),beta_hat(:,k),alpha)];
    b_k=[b_k;repmat(k,n+1,1)];
  end
  
  y_hat=normalPredict(X,beta_hat);
  
  rss=normalRss(X,y,beta_hat);
   
  end