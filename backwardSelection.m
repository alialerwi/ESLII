function [beta_hat p_value]=backwardSelection(x,y,k)

  [m n]=size(x);
  flag=ones(n,1);
  for i=n:-1:max(0,k)
    
    [beta_hat beta_sd beta_ci y_hat b_k rss]=linearRegression(x,y,alpha=0.05);
    z=beta_hat./beta_sd;
    p_value=2*(1-tcdf(abs(z),m-numel(beta_hat)));
    
    if sum(p_value==0)==numel(p_value)
      break;
    end
    
    [v p]=max(min(p_value(2:end),flag));
    p
    flag(p)=0;
    x(:,p)=0;
    
  end
  
  end