function [model]=LineaRmulti(x,y,standardize,type,varargin)

  # linear models for multiple outputs. Implemented: 
  # - normal equation
  # - reduced rank regression
  # - smooth reduced rank regression 
  # - hybrid shrinkage
  
  # possible to change l for reduced rank regression, lambda for hybrid shrinkage
  
  # evaluate arguments in varargin
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i},';'));
  end
  
  [m n]=size(x);
  [m K]=size(y);
  
  if standardize==1
    [x mu sd]=normalize(x);
    model.mu=mu;
    model.sd=sd;
  end
  
  switch type
  
  # normal equation
    case 'normal'
      x=[ones(m,1) x];
      beta_hat=pinv(x'*x)*x'*y;
      
  # reduced rank regression
    case 'reduced rank'
      if ~exist('l', 'var') || isempty(l)
        l=min(K,n);
      end
      [u d v]=svd(cov(y,x));
      beta_hat=[mean(y,1);pinv(x'*x)*x'*(y*u(:,1:l))*pinv(u(:,1:l))];
      corr_coeff=diag(corr(y*u,x*v));
      
  # smooth reduced rank regression        
    case 'curds-whey'
      [u d v]=svd(cov(y,x));
      c=diag(corr(y*u,x*v));
      lambda_y=c.^2./(c.^2+(n/m).*(1-c.^2));
      Delta=eye(numel(lambda_y));
      for i=1:size(Delta,1)
        Delta(i,i)=lambda_y(i);
      end
      beta_hat=[mean(y,1);pinv(x'*x)'*x'*y*u*Delta*pinv(u)];
      
  # hybrid shrinkage
    case 'hybrid'
      if ~exist('lambda', 'var') || isempty(lambda)
        lambda=0.01;
      end
      [u d v]=svd(cov(y,x));
      c=diag(corr(y*u,x*v));
      lambda_y=c.^2./(c.^2+(n/m).*(1-c.^2));
      Delta=eye(numel(lambda_y));
      for i=1:size(Delta,1)
        Delta(i,i)=lambda_y(i);
      end
      beta_hat=[mean(y,1);pinv(x'*x+lambda*eye(n))'*x'*y*u*Delta*pinv(u)];    

  endswitch
  
  # information to retrieve
  model.type=type;
  model.x=x;
  model.y=y;
  model.beta=beta_hat;
  
  
end