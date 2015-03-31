function [model]=LineaR(x,y,standardize,type,varargin)

  # linear models implemented: 
  # - normal equation
  # 
  
  # possible to change 
  
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
  endswitch
  
  # information to retrieve
  model.type=type;
  model.x=x;
  model.y=y;
  model.beta=beta_hat;
  
  
end