function pls(x,y,l)
  
  [m n]=size(x);
  xn=normalize(x);
  b=zeros(n,1);
  y_hat=mean(y)*ones(m,1);
  for j=1:l
    phi=xn'*y;
    z=xn*phi;
    theta=(z'*y)/(z'*z);
    y_hat=y_hat+theta*z;
    b=b+phi*theta;
    xn=xn-z*(z'*xn)/(z'*z);
  end
  sum((y-y_hat).^2);

b0=mean(y)
b
sum((y-b0-xn*b).^2)
end
