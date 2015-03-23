function [beta_hat comb]=forwardStagewise(x,y)
  
  [m n]=size(x);
  
  beta_hat=zeros(n+1,1);
  beta_hat(1)=mean(y);
  comb=0;
  y_hat=normalPredict([ones(m,1) x],beta_hat);
  resid=y-y_hat;
  while max(abs(corr(resid,x)))>0.01
    
    [v p]=max(abs(corr(resid,x)));
    comb=[comb;p];
    beta_hat(p+1)=beta_hat(p+1)+normalEquation(x(:,p),resid);
    y_hat=normalPredict([ones(m,1) x],beta_hat);
    resid=y-y_hat;
  end
  
end