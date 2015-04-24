function y_hat=predict(x_new,model,options={})

  # linear models implemented: 
  # - normal equation
  # - normal equation, multiple output
  # - ridge regression
  # - least angle regression
  # - least angle regression - lasso modification
  # - least angle regression - FS0 modification
  # - principal components regression
  # - partial least squares
  # - reduced rank regression, multiple output
  # - smooth reduced rank regression, multiple output
  # - hybrid shrinkage, multiple output
  # - general spline, natural cubic spline, b spline
  
  # evaluate arguments in options
  for i=2:2:numel(options) 
    eval(strcat(options{(i-1)}, '=[', num2str((options{i})(:)'),'];'))
  end
  
  [m n]=size(x_new);
  
  if isfield(model,'mu')
    x_new=normalize(x_new,model.mu,model.sd);
  end
  
  switch model.type
    case {'normal','normal.multi','ridge','lar','lar-lasso','pcr','pls','reduced rank','curds-whey','hybrid'}
      y_hat=[ones(m,1) x_new]*model.beta;
    case {'general spline','natural cubic spline','b spline'}
      options={'knots',model.knots,'M',model.M};
      splines=splines1D(x_new,model.type,options,model.epsilon);
      y_hat=splines.h*model.beta;
  endswitch
  
end