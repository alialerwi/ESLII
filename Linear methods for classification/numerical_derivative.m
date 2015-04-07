function numgrad=numerical_derivative(fun,x)
  epsilon=10^(-3);
  numgrad=zeros(numel(x),1);
  perturb=zeros(numel(x),1);
  for j=1:numel(x)
    perturb(j)=epsilon;
    fun_down=fun(x-perturb);
    fun_up=fun(x+perturb);
    numgrad(j)=(fun_up-fun_down)/(2*epsilon);
    perturb(j)=0;
  end
end
