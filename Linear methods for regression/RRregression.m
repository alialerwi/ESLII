function Brr=RRregression(x,y,k)
  
  [m n]=size(x);
  x=[ones(m,1) x];
  u=CCA(x,y);
  Brr=pinv(x'*x)*x'*(y*u(:,1:k))*pinv(u(:,1:k));
  
end