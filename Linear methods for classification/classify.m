function y_hat=classify(x_new,model,varargin)

  # linear models implemented: 
  # - indicator_matrix
  # - linear discriminant analysis

  
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
      
  endswitch
  
end