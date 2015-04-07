function l=multiloglikelihood(x,y,beta)
  
  l=sum(y.*log(logit(x,beta))+(1-y).*log(1-logit(x,beta)));

end
