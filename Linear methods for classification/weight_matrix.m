function W=weight_matrix(X,P,K)
  
  if ~exist('K', 'var') || isempty(K)
    K=2;
  end
  [M N]=size(X);
  m=M/(K-1);
  n=(N/(K-1))-1;
  
  W=zeros(m*(K-1),m*(K-1));
  for i=1:(K-1)
    for j=1:(K-1)
      w=zeros(m,m);
      if i==j
        diagonal=P((m*(i-1)+1):(m*i),1).*(1-P((m*(i-1)+1):(m*i),1));
        for t=1:m
          w(t,t)=diagonal(t);
        end
        W((m*(i-1)+1):(m*i),(m*(j-1)+1):(m*j))=w;
      else
        diagonal=-P((m*(i-1)+1):(m*i),1).*(P((m*(j-1)+1):(m*j),1));
        for t=1:m
          w(t,t)=diagonal(t);
        end
        W((m*(i-1)+1):(m*i),(m*(j-1)+1):(m*j))=w;
      end
    end
  end
  
 end