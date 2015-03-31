function y_hat=classify(x_new,model,varargin)

  # linear models implemented: 
  # - normal equation

  
  # evaluate arguments in varargin
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i}));
  end
  
  [m n]=size(x_new);
  
  if isfield(model,'mu')
    x_new=normalize(x_new,model.mu,model.sd);
  end
  
  switch model.type
    case 'normal'
      y_hat=[ones(m,1) x_new]*model.beta;
  endswitch
  
end