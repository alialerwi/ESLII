function [splines1 splines2]=splinesMultiD(x,type,options={},epsilon)

  # spline methods implemented:
  # - multivariate smoothing spline
  
  # possible to change M (order of spline), knots (internal knots of the domain), nK (number of knots), lambda 
  # 

  for i=2:2:numel(options) 
    eval(strcat(options{(i-1)}, '=[', num2str(options{i}(:)'),'];'))
  end
  
  [m n]=size(x);
  splines1=splines1D(x(:,1),type,options);
  splines2=splines1D(x(:,2),type,options);

  
  
  
end
