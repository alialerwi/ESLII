function [z x_approx]=pca(x,k)
  
  [m n]=size(x)
  mu=mean(x,1);
  covMat=(1/(m-1)).*(x-ones(m,1)*mu)'*(x-ones(m,1)*mu);
  [u d v]=svd(covMat);
  z=x*u(:,1:k);
  x_approx=z*u(:,1:k)';
  
end