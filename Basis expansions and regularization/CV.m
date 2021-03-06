function cv=CV(y,y_hat,S)
  # cross validation curve for smoothing regression
  cv=sum(((y(:)-y_hat(:))./(1-diag(S)(:))).^2)/length(y);
end
