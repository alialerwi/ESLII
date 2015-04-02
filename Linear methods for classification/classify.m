function y_hat=classify(x_new,model,varargin)

  # linear models implemented: 
  # - indicator_matrix
  # - linear discriminant analysis
  # - quadratic discriminant analysis with regularization
  # - diagonalized quadratic discriminant analysis with regularization

  # possible to change alpha and gamma in quadratic discriminant analysis
  
  # evaluate arguments in varargin
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i}));
  end
  
  [m n]=size(x_new);
  
  if isfield(model,'mu')
    x_new=normalize(x_new,model.mu,model.sd);
  end
  
  switch model.type
    case 'indicator_matrix'
      [val pos]=max([ones(m,1) x_new]*model.beta,[],2);
      y_hat=model.G(pos);
      
    case 'lda'    
      pi_k=model.pi_k;
      mu_k=model.mu_k;
      sigma=model.sigma;   
      
      if model.add1==1
        x_new=[ones(m,1) x_new];
      end
      
      delta_k=zeros(m,model.K);
      y_hat=zeros(m,1);
      for i=1:m
        for k=1:model.K
          delta_k(i,k)=x_new(i,:)*pinv(sigma)*mu_k(:,k)-(1/2)*mu_k(:,k)'*pinv(sigma)*mu_k(:,k)+log(pi_k(k));
        end
        [val pos]=max(delta_k(i,:));
        y_hat(i)=model.G(pos);
      end
 
    case 'qda'    
      pi_k=model.pi_k;
      mu_k=model.mu_k;
      sigma=zeros(size(model.sigma));
        
      if model.add1==1
        x_new=[ones(m,1) x_new];
      end
      
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=model.alpha;
      end
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=model.gamma;
      end
      sigmaALL=gamma*model.sigmaALL+(1-gamma)*model.covariance;
      
      for k=1:model.K
        sigma(k,:)=((1-alpha)*sigmaALL+alpha*reshape(model.sigma(k,:),size(x_new,2),size(x_new,2)))(:);
      end
      
      delta_k=zeros(m,model.K);
      y_hat=zeros(m,1);
      for i=1:m
        for k=1:model.K
          sigma_k=reshape(sigma(k,:),size(x_new,2),size(x_new,2));
          delta_k(i,k)=-(1/2)*log(det(sigma_k))-(1/2)*(x_new(i,:)-mu_k(:,k)')*pinv(sigma_k)*(x_new(i,:)-mu_k(:,k)')'+log(pi_k(k));
        end
        [val pos]=max(delta_k(i,:));
        y_hat(i)=model.G(pos);
      end
    
    case 'qda-diag'    
      pi_k=model.pi_k;
      mu_k=model.mu_k;
      u=zeros(model.K,size(model.sigma,1)^2);
      d_inv=zeros(model.K,size(model.sigma,1)^2);
        
      if model.add1==1
        x_new=[ones(m,1) x_new];
      end
      
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=model.alpha;
      end
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=model.gamma;
      end
      sigmaALL=gamma*model.sigmaALL+(1-gamma)*model.covariance;
      
      for k=1:model.K
        [u_k d_k v_k]=svd((1-alpha)*sigmaALL+alpha*reshape(model.sigma(k,:),size(x_new,2),size(x_new,2)));
        u(k,:)=u_k(:);
        d_k_inv=eye(size(d_k));
        for i=1:size(d_k,1)
          d_k_inv=d_k^(-1);
        end
        d_inv(k,:)=d_k_inv(:);        
      end
      
      delta_k=zeros(m,model.K);
      y_hat=zeros(m,1);
      for i=1:m
        for k=1:model.K
          u_k=reshape(u(k,:),size(model.sigma),size(model.sigma));
          d_k_inv=reshape(d_inv(k,:),size(model.sigma),size(model.sigma));
          
          delta_k(i,k)=-(1/2)*sum(log(diag(d_k)))-(1/2)*(u_k'*(x_new(i,:)'-mu_k(:,k)))'*d_k_inv*u_k'*(x_new(i,:)'-mu_k(:,k))+log(pi_k(k));
        end
        [val pos]=max(delta_k(i,:));
        y_hat(i)=model.G(pos);
      end
 
  endswitch
  
end