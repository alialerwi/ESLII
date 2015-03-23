function rss=ridgeRss(x,y,beta_hat,lambda,mu,sd)
  
  if ~exist('mu', 'var') || isempty(mu)||~exist('sd', 'var') || isempty(sd)
		y_hat=predictRidge(x,beta_hat);
	else
    y_hat=predictRidge(x,beta_hat,mu,sd);
  end
  e=y-y_hat;
  rss=e'*e+lambda.*beta_hat'*beta_hat;  
  
end