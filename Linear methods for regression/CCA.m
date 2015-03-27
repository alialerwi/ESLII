function [u d v]=CCA(x,y)
  
  [m n]=size(x);
  [m K]=size(y);
  
  y_mu=ones(m,1)*mean(y,1);
  x_mu=ones(m,1)*mean(x,1);
  covMat=(1/(m-1))*(y-y_mu)'*(x-x_mu);
  [u d v]=svd(covMat);
  
    
