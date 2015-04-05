function g=logit(x,beta)
  g=1./(1+exp(-x*beta));
end
