function numhessian=numerical_hessian(fun,x)
  epsilon=10^(-3);
  numhessian=zeros(numel(x));
  perturb=zeros(numel(x),1);
  for i=1:numel(x)
      perturb(i)=epsilon;
      x_up=x+perturb;
      x_down=x-perturb;
      numhessian(i,i)=(fun(x_up)+fun(x_down)-2*fun(x))/(epsilon^2);
      perturb(i)=0;
    for j=1:numel(x)
      if j~=i
	perturb(j)=epsilon;
	numhessian(i,j)=(fun(x_up+perturb)+fun(x_down-perturb)-fun(x_down+perturb)-fun(x_up-perturb))/(4*epsilon^2);
	perturb(j)=0;
      end
    end

  end
end
