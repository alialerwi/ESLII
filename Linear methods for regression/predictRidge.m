function y_hat=predictRidge(x,beta_hat,mu,sd)
  
  [m n]=size(x);
  if ~exist('mu', 'var') || isempty(mu)||~exist('sd', 'var') || isempty(sd)
		y_hat=[ones(m,1) x]*beta_hat;
	else
    x=normalize(x,mu,sd);
    y_hat=[ones(m,1) x]*beta_hat;
  end

end