function Bcw=CWreducedRank(x,y)
  
  [m n]=size(x);
  x=[ones(m,1) x];
  [u d v]=CCA(x,y);
  
  c_2=(diag(corr(y*u,x*v))).^2;
  lambda=(c_2./(c_2+(n/m)*(1-c_2)))(:)';
  D=eye(numel(lambda));
  for i=1:numel(lambda)
    D(i,i)=lambda(i);
  end
  
  B=pinv(x'*x)*x'*y;
  Bcw=B*u*D*pinv(u);
  
  
end