function [model]=LinearClassification(x,y,standardize,type,varargin)

  # linear models implemented: 
  # - linear regression of an indicator matrix
  # - linear discriminant analysis, diagonalized
  # - quadratic discriminant analysis with regularization, diagonalized
  # - reduced rank LDA
  
  # possible to change alpha and gamma in quadratic discriminant analysis, L in reduced rank LDA,
  #   lambda threshold and zero in logistic regression
  
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

  # write y in matricial form
  G=unique(y);
  K=numel(G);
  Y=zeros(m,K);
  for i=1:m
    Y(i,find(G==y(i)))=1;
  end
  
  switch type
  
  # linear regression of an indicator matrix
    case 'indicator_matrix'
      x=[ones(m,1) x];
      beta_hat=pinv(x'*x)*x'*Y; 
      
      model.beta=beta_hat;
      
  # linear discriminant analysis
    case 'lda'
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=1;
      end

      pi_k=zeros(K,1);
      mu_k=zeros(size(x,2),K);
      sigma=zeros(size(x,2),size(x,2));
      for k=1:K
        m_k(k)=sum(y==G(k));
        pi_k(k)=m_k(k)/m;
        mu_k(:,k)=mean(x(y==G(k),:),1);
        sigma=sigma+(1/(m-K))*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)')'*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)');
      end
      
      # scalar covariance matrix
      cov_diag=diag(cov(x));
      cov_mat=eye(size(x,2),size(x,2));
      for i=1:numel(cov_diag)
        cov_mat(i,i)=cov_diag(i);
      end

      model.gamma=gamma;
      model.pi_k=pi_k;
      model.mu_k=mu_k;
      model.sigma=sigma;   
      model.cov_mat=cov_mat;
      
  # quadratic discriminant analysis with regularization
    case 'qda'   
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=1;
      end
      if ~exist('gamma', 'var') || isempty(gamma)
        gamma=1;
      end
      
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
      cov_mat=eye(size(x,2),size(x,2));
      for i=1:numel(cov_diag)
        cov_mat(i,i)=cov_diag(i);
      end
      
      model.alpha=alpha;
      model.gamma=gamma;
      model.pi_k=pi_k;
      model.mu_k=mu_k;
      model.sigma=sigma;
      model.sigmaALL=sigmaALL;
      model.cov_mat=cov_mat;
      
  # reduced rank linear discriminant analysis
    case 'RR-lda'
      if ~exist('L', 'var') || isempty(L)
        L=max([1 (K-1)]);
      end
      
      pi_k=zeros(K,1);
      mu_k=zeros(size(x,2),K);
      mu_ALL=mean(x,1);
      W=zeros(size(x,2),size(x,2));
      B=zeros(size(x,2),size(x,2));

      for k=1:K
        m_k(k)=sum(y==G(k));
        pi_k(k)=m_k(k)/m;
        mu_k(:,k)=mean(x(y==G(k),:),1);
        W=W+(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)')'*(x(y==G(k),:)-ones(m_k(k),1)*mu_k(:,k)');
        B=B+m_k(k).*(mu_k(:,k)-mu_ALL')*(mu_k(:,k)-mu_ALL')';
      end
      [u_w d_w v_w]=svd(W);
      d_w_sq=eye(size(d_w));
      d_w_sq_inv=eye(size(d_w));
      for i=1:size(d_w,1)
        d_w_sq(i,i)=d_w(i,i).^0.5;
	d_w_sq_inv(i,i)=d_w(i,i).^(-0.5);
      end
      W_sq_inv=u_w*d_w_sq_inv*v_w';
      B_star=W_sq_inv'*B*W_sq_inv;
      [u_star d_bstar v_bstar]=svd(B_star);
      a=W_sq_inv*u_star;
      z=x*a(:,1:L);

      model=LinearClassification(z,y,0,'lda');
      model.z=z;
      model.a=a; 
      model.L=L;

  # linear regression of an indicator matrix
    case 'logit'
      if ~exist('lambda', 'var') || isempty(lambda)
        lambda=0.0;
      end
      if ~exist('threshold', 'var') || isempty(threshold)
        threshold=0.5;
      end
      if ~exist('zero', 'var') || isempty(zero)
        zero=10^(-5);
      end
      x=[ones(m,1) x];
      beta=zeros(n+1,1);
      w=eye(m,m);
      delta=Inf;
it=0;
      while delta>zero
it=it+1
	beta_old=beta;
        p=logit(x,beta);
        derivative=x'*(y-p);
        for j=1:m
          w(j,j)=p(i).*(1-p(i));
        end
        hessian=-x'*w*x;
        z=x*beta+pinv(w)*(y-p);
        beta=-pinv(hessian)*x'*w*z;

	perf_old=mean(y==(logit(x,beta_old)>threshold));
	perf_new=mean(y==(logit(x,beta)>threshold));
	delta=perf_new-perf_old;
	
      end
      model.lambda=lambda;
      model.threshold=threshold;   
      model.beta=beta;

  endswitch
  
  # information to retrieve
  model.G=G;
  model.K=K;
  model.Y=Y;
  model.type=type;
  model.x=x;
  model.y=y;
  
end
