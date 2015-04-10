function [f d h]=absolute(x)

  epsilon=10^(-3);
  f=abs(x);
  d=sign(x);
  h=(epsilon.^2)./((x.^2+epsilon.^2).^(1.5));
  
  end
  