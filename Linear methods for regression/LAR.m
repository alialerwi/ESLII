function beta_hat=LAR(x,y,alpha=0.01,lasso=0)
  
  [m n]=size(x);
  [xn mu sd]=normalize(x);
  X=[ones(m,1) xn];
  clear xn;
  
  y_hat=zeros(m,1);
  active=[1 repmat(0,1,n)];
  beta_hat=[mean(y);zeros(n,1)];
  for i=1:(min(m-1,n)/alpha)
    r=y-X(:,find(active))*beta_hat(find(active));
    [v pos]=max(abs(corr(r,X)));
    active(pos)=1;
    delta=zeros(n+1,1);
    delta(find(active))=pinv(X(:,find(active))'*X(:,find(active)))*X(:,find(active))'*r;
    beta_hat=beta_hat+alpha.*delta;
    if lasso==1
      active(find(beta_hat(find(active)==0)))=0;
    end
    y_hat=y_hat+alpha.*X(:,find(active))*delta(find(active));
  end
  
  
end 