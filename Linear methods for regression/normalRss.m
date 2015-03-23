function rss=normalRss(X,y,beta_hat)
  
  [m K]=size(y);
  y_hat=normalPredict(X,beta_hat);
  e=y-y_hat;
  rss=trace(e'*e);
  
end