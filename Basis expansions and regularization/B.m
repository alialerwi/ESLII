function [basis dbasis ddbasis]=B(x,df,varargin)

  x=x(:);
  if ~exist('M', 'var') || isempty(M)
    M=4;
  end
  K=df-M
  #epsilon=linspace(min(x),max(x),K+2)
  #epsilon=linspace(min(x),max(x),K)
  epsilon=unique(x)(:)';
  size(epsilon)
  tau=[linspace((-10^-3)*range(x)+min(x),min(x),M+1)(1:(end-1)) epsilon linspace(max(x),(10^-3)*range(x)+max(x),M+1)(2:end)]
  size(tau)
  for m=1:M
    b=zeros(numel(x),K+2*M-m);
    db=zeros(numel(x),K+2*M-m);
    ddb=zeros(numel(x),K+2*M-m);
    penalty=zeros(K+2*M-m,K+2*M-m);
    for i=1:(K+2*M-m)
      if m==1
        b(:,i)=(x>=tau(i+m-1))&(x<tau(i+m));
        db(:,i)=0;
        ddb(:,i)=0;
      else
        b(:,i)=b_prev(:,i).*(x-tau(i))/(tau(i+m-1)-tau(i))+...
          b_prev(:,i+1).*(tau(i+m)-x)/(tau(i+m)-tau(i+1));
        db(:,i)=b_prev(:,i).*(1/(tau(i+m-1)-tau(i)))+db_prev(:,i).*(x-tau(i))/(tau(i+m-1)-tau(i))+...
          b_prev(:,i+1).*(-1/(tau(i+m)-tau(i+1)))+db_prev(:,i+1).*(tau(i+m)-x)/(tau(i+m)-tau(i+1));
        ddb(:,i)=db_prev(:,i).*(1/(tau(i+m-1)-tau(i)))+ddb_prev(:,i).*(x-tau(i))/(tau(i+m-1)-tau(i))+db_prev(:,i).*(1/(tau(i+m-1)-tau(i)))+...
          db_prev(:,i+1).*(-1/(tau(i+m)-tau(i+1)))+ddb_prev(:,i+1).*(tau(i+m)-x)/(tau(i+m)-tau(i+1))+db_prev(:,i+1).*(-1/(tau(i+m)-tau(i+1)));
        
        #for r=1:(K+2*M-m)
        #  (db_prev(:,i)./(tau(i+m-1)-tau(i)))+...
        #  (ddb_prev(:,i).*(x-tau(i))/(tau(i+m-1)-tau(i)))+...
        #  (db_prev(:,i)./(tau(i+m-1)-tau(i)))+...
        #  (-db_prev(:,i+1)./(tau(i+m)-tau(i+1)))+...
        #  (ddb_prev(:,i+1).*(tau(i+m)-x)/(tau(i+m)-tau(i+1)))+...
        #  (-db_prev(:,i+1)./(tau(i+m)-tau(i+1)));
        #  
        #  (db_prev(:,i)./(tau(i+m-1)-tau(i))).*((db_prev(:,r)./(tau(r+m-1)-tau(r)))+...
        #  (ddb_prev(:,r).*(x-tau(r))/(tau(r+m-1)-tau(r)))+...
        #  (db_prev(:,r)./(tau(r+m-1)-tau(r)))+...
        #  (-db_prev(:,r+1)./(tau(r+m)-tau(r+1)))+...
        #  (ddb_prev(:,r+1).*(tau(r+m)-x)/(tau(r+m)-tau(r+1)))+...
        #  (-db_prev(:,r+1)./(tau(r+m)-tau(r+1))))  
        #end
        
      end
    end
    b_prev=b;
    db_prev=db;
    ddb_prev=db;
  end
  basis=b;
  dbasis=db;
  ddbasis=ddb;
  
end