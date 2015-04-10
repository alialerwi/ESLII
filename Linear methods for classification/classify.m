function y_hat=classify(x_new,model,varargin)

  # linear models implemented: 
  # - indicator_matrix
  # - linear discriminant analysis, diagonalized
  # - quadratic discriminant analysis with regularization, diagonalized
  # - reduced rank LDA
  # - logistic regression
  # - multiclass logistic regression
  
  # possible to change alpha and gamma in quadratic discriminant analysis, L and gamma in reduced rank LDA,
  #   lambda threshold and zero in logistic regression, lambda penalty(L0,L1,L2) and zero in multiclass logistic regression

  
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
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=model.gamma;
      end
      sigma=gamma.*model.sigma+(1-gamma).*model.cov_mat;
     
      # diagonalization
      [u d v]=svd(sigma);
      d_sq_inv=eye(size(d));
      for i=1:size(d_sq_inv,1)
        d_sq_inv(i,i)=d(i,i).^(-0.5);
      end
      x_star=(d_sq_inv*u'*x_new')'; 
      mu_k_star=(d_sq_inv*u'*mu_k);

      # calculate discriminant functions
      delta_k=zeros(m,model.K);
      y_hat=zeros(m,1);

      for k=1:model.K
        delta_k(:,k)=(1/2).*sum((x_star-ones(m,1)*mu_k_star(:,k)').^2,2)-ones(m,1)*log(pi_k(k));
      end
      [val pos]=min(delta_k,[],2);
      y_hat=model.G(pos);
 
    case 'qda'    
      pi_k=model.pi_k;
      mu_k=model.mu_k;
      u=zeros(model.K,size(x_new,2)*size(x_new,2));
      d_inv=zeros(model.K,size(x_new,2)*size(x_new,2));
              
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=model.alpha;
      end
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=model.gamma;
      end
      sigmaALL=gamma.*model.sigmaALL+(1-gamma).*model.cov_mat;
      
      # diagonalization
      for k=1:model.K
        [u_k d_k v_k]=svd((1-alpha).*sigmaALL+alpha.*reshape(model.sigma(k,:),size(x_new,2),size(x_new,2)));
        u(k,:)=u_k(:);
        d_k_inv=eye(size(d_k));
        for i=1:size(d_k,1)
          d_k_inv=d_k^(-1);
        end
        d_inv(k,:)=d_k_inv(:);        
      end
      
      # calculate discriminant functions
      delta_k=zeros(m,model.K);
      y_hat=zeros(m,1);
      for k=1:model.K
        u_k=reshape(u(k,:),size(x_new,2),size(x_new,2));
        d_k_inv=reshape(d_inv(k,:),size(x_new,2),size(x_new,2));
        for i=1:m          
          delta_k(i,k)=-(1/2)*sum(log(diag(d_k)))-(1/2)*(u_k'*(x_new(i,:)'-mu_k(:,k)))'*d_k_inv*u_k'*(x_new(i,:)'-mu_k(:,k))+log(pi_k(k));
        end
      end
        [val pos]=max(delta_k,[],2);
        y_hat=model.G(pos);

    case 'RR-lda'
      if ~exist('L', 'var') || isempty(L)
        L=model.L;
      end

      z_new=x_new*model.a(:,1:L);
      model.type='lda';
      y_hat=classify(z_new,model);
      model.type='RR-lda';

    case 'logit'
      if ~exist('threshold', 'var') || isempty(threshold)
        threshold=model.threshold;
      end
      x_new=[ones(m,1) x_new];
      g=logit(x_new,model.beta);
      y_hat=model.G((g>threshold)+1);
      
    case 'multi-logit' 
      x_new=[ones(m,1) x_new];
      X=zeros(m*(model.K-1),(n+1)*(model.K-1));
      for i=1:(model.K-1)
        X((m*(i-1)+1):(m*i),((n+1)*(i-1)+1):((n+1)*i))=x_new;
      end
      P=logit(X,model.beta,model.K);   
      p=reshape(P,m,(model.K-1));
      p=[(ones(m,1)-sum(p,2)) p];
      [val pos]=max(p,[],2);
	    y_hat=model.G(pos);
      
  endswitch
  
end
