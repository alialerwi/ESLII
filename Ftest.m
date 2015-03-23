function f_test=Ftest(xF, xR, y,alpha=0.05)
  
  [m nF]=size(xF);
  [m nR]=size(xR);
  
  [beta_hat beta_sd beta_ci y_hat rssF]=linearRegression(xF,y);
  clear y_hat;
  [beta_hat beta_sd beta_ci y_hat rssR]=linearRegression(xR,y);
  clear y_hat;
  
  F=((rssR-rssF)/(nF-nR))/(rssF/(m-nF-1));
  f_test=1-fcdf(F,nF-nR,m-nF-1);
  if(f_test<alpha)
    fprintf("significant difference between full and reduced models\n")
  end
  
  end

