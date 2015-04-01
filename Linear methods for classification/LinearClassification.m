function [model]=LinearClassification(x,y,standardize,type,varargin)

  # linear models implemented: 
  # - linear regression of an indicator matrix
  # - linear discriminant analysis
  # - quadratic discriminant analysis with regularization
  
  # possible to change alpha and gamma in quadratic discriminant analysis
  
  # evaluate arguments in varargin
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i},';'));
  end
    
  [m n]=size(x);
  
  if standardize==1
    [x mu sd]=normalize(x);
    model.mu=mu;
    model.sd=sd;
  end
  
  switch type
  
  # linear regression of an indicator matrix
    case 'indicator_matrix'
    # write y in matricial form
      G=unique(y);
      K=numel(G);
      Y=zeros(m,K);
      for i=1:m
        Y(i,find(G==y(i)))=1;
      end
      x=[ones(m,1) x];
      beta_hat=pinv(x'*x)*x'*Y; 
      
      model.G=G;   
      model.K=K;
      model.Y=Y;
      model.beta=beta_hat;
      
  # linear discriminant analysis
    case 'lda'
    # write y in matricial form
      G=unique(y);
      K=numel(G);
      Y=zeros(m,K);
      for i=1:m
        Y(i,find(G==y(i)))=1;
      end
      
      if ~exist('add1', 'var') || isempty(add1)
        add1=0;
      end
      if add1==1
        x=[ones(m,1) x];
      end
      
      mu_k=zeros(K,1);
      pi_k=zeros(K,1);
      mu_k=zeros(size(x,2),K);
      sigma=zeros(size(x,2),size(x,2));
      for k=1:K
        m_k(k)=sum(y==G(k));
        pi_k(k)=m_k(k)/m;
        mu_k(:,k)=mean(x(y==G(k),:),1);
        sigma=sigma+(1/(m-K))*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)')'*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)');
      end
      model.G=G;
      model.K=K;
      model.Y=Y;
      model.add1=add1;
      model.pi_k=pi_k;
      model.mu_k=mu_k;
      model.sigma=sigma;   
      
  # quadratic discriminant analysis with regularization
    case 'qda'
    # write y in matricial form
      G=unique(y);
      K=numel(G);
      Y=zeros(m,K);
      for i=1:m
        Y(i,find(G==y(i)))=1;
      end
      
      if ~exist('add1', 'var') || isempty(add1)
        add1=0;
      end      
      if add1==1
        x=[ones(m,1) x];
      end
      
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=1;
      end
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=1;
      end
      
      mu_k=zeros(K,1);
      pi_k=zeros(K,1);
      mu_k=zeros(size(x,2),K);
      sigmaALL=zeros(size(x,2),size(x,2));
      sigma=zeros(K,size(x,2)*size(x,2));
      for k=1:K
        m_k(k)=sum(y==G(k));
        pi_k(k)=m_k(k)/m;
        mu_k(:,k)=mean(x(y==G(k),:),1);
        sigmaALL=sigmaALL+(1/(m-K))*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)')'*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)');
        sigma(k,:)=sigma(k,:)+((1/(m_k(k)-1))*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)')'*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)'))(:)';
      end
      
      # scalar covariance matrix
      cov_diag=diag(cov(x));
      covariance=eye(size(x,2),size(x,2));
      for i=1:numel(cov_diag)
        covariance(i,i)=cov_diag(i);
      end
      
      model.G=G;
      model.K=K;
      model.Y=Y;
      model.add1=add1;
      model.alpha=alpha;
      model.gamma=gamma;
      model.pi_k=pi_k;
      model.mu_k=mu_k;
      model.sigma=sigma;
      model.sigmaALL=sigmaALL;
      model.covariance=covariance;
      
  endswitch
  
  # information to retrieve
  model.type=type;
  model.x=x;
  model.y=y;
  
  
  
end