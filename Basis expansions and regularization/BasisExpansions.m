function [basis]=BasisExpansions(x,df,type,varargin)

  # basis expansion methods implemented:
  #  - B-splines
  #  - natural cubic splines
  #  - smoothing splines
  
  # possible to change M in b-splines, lambda in smoothing splines
  
  # evaluate arguments in varargin
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i},';'));
  end
  
  x=x(:);
  
  switch type
    case 'b-splines'
      [basis dbasis ddbasis]=B(x,df,varargin);
      
    case 'natural-cubic'
      M=4;
      K=df;
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
	
    case 'smoothing'
      if ~exist('lambda', 'var') || isempty(lambda)
        lambda=0;
      end
      
      #df=length(x)+4;
      [basis dbasis ddbasis]=B(x,df,varargin);
      penalty=zeros(size(ddbasis,2),size(ddbasis,2));
      for j=1:size(ddbasis,2)
        for k=1:size(ddbasis,2)
          penalty(j,k)=ddbasis(:,j)'*ddbasis(:,k);
        end
      end
      
      #size(basis)
      #size(ddbasis)
      #size(penalty)

      theta=pinv(basis'*basis+lambda*penalty)*basis'*unique(y);
      #theta=pinv(basis'*basis)*basis'*y;
      basis=basis*theta;
      #basis=theta;
      
  endswitch
  
end

