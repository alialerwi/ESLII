function l=loglikelihood(X,Y,beta,K)
  l=sum(y.*log(logit(x,beta))+(1-y).*log(1-logit(x,beta)));
  
  exp(X((m*(i-1)+1):(m*i),((n+1)*(i-1)+1):((n+1)*i))*beta(((n+1)*(i-1)+1):((n+1)*i),1))./(1+exp(X*beta))
  
end
