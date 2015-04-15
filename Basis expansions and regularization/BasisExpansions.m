function [basis]=BasisExpansions(x,M,K,type)

  # basis expansion methods implemented:
  #  - B-splines
  #  - natural cubic splines
  #
  
  # possible to change
  
  x=x(:);
  
  switch type
    case 'b-splines'
      epsilon=linspace(min(x),max(x),K+2);
      tau=[linspace((-10^-15)*range(x)+min(x),min(x),M) epsilon(2:(end-1)) linspace(max(x),(10^-15)*range(x)+max(x),M)];
      for m=1:M
        b=zeros(numel(x),K+2*M-m);
        for i=1:(K+2*M-m)
          if m==1
              b(:,i)=(x>=tau(i+m-1))&(x<tau(i+m));
          else
              b(:,i)=b_prev(:,i).*(x-tau(i))/(tau(i+m-1)-tau(i))+b_prev(:,i+1).*(tau(i+m)-x)/(tau(i+m)-tau(i+1));
          end
        end
        b_prev=b;
      end
      basis=b;

    case 'natural-cubic'
      epsilon=linspace(min(x),max(x),K+2)(2:(end-1));
      N=ones(size(x,1),1);
      N=[N x];
      
      k=K-1;
      dK_1=((((x>=epsilon(k)).*(x-epsilon(k))).^3)-(((x>=epsilon(end)).*(x-epsilon(end))).^3))./(epsilon(end)-epsilon(k));
      for k=1:(K-2)
        dk=((((x>=epsilon(k)).*(x-epsilon(k))).^3)-(((x>=epsilon(end)).*(x-epsilon(end))).^3))./(epsilon(end)-epsilon(k));
        N=[N (dk-dK_1)];
      end
      basis=N;
      
    
  endswitch
  

end