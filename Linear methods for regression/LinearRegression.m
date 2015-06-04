function [model]=LinearRegression(x,y,standardize,type,options={})

  # linear models implemented: 
  # - normal equation
  # - ridge regression
  # - least angle regression
  # - least angle regression - lasso modification
  # - least angle regression - FS0 modification
  # - principal components regression
  # - partial least squares regression
  # - general spline, natural cubic spline, b spline
  
  # possible to change lambda for ridge, alpha for lar and lar_lasso, 
  #   zero_value for lar_lasso, threshold for pcr, l for pls, 
  # 
  
  # evaluate arguments in options
  for i=2:2:numel(options) 
    eval(strcat(options{(i-1)}, '=[', num2str((options{i})(:)'),'];'))
  end
  
  [m n]=size(x);
  [m K]=size(y);
  
  if standardize==1
    [x mu sd]=normalize(x);
    model.mu=mu;
    model.sd=sd;
  end
  
  switch type
  
  # normal equation
    case 'normal'
      x=[ones(m,1) x];
      beta_hat=pinv(x'*x)*x'*y;
      
  # ridge regression
    case 'ridge'
      if ~exist('lambda', 'var') || isempty(lambda)
        lambda=0.01;
      end
      x=[ones(m,1) x];
      lambda_mat=lambda*eye(n+1);
      lambda_mat(1,1)=0;
      beta_hat=pinv(x'*x+lambda_mat)*x'*y;
      
  # least angle regression
    case 'lar'
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=0.1;
      end      
      # initialize
      beta_hat=zeros(n+1,1);
      beta_hat(1)=mean(y);
      y_hat=[ones(m,1) x]*beta_hat;
      r=y-y_hat;
      
      active=zeros(n,1);
      steps=1/alpha;
      # find feature most correlated with residual
      for i=1:min(m-1,n)
        # add most correlated feature to active set
        [v pos]=max(abs(corr(x,r)));
        competitor=pos;
        active(pos)=1;
        x0=[ones(m,1) x(:,find(active))];
        delta=pinv(x0'*x0)*x0'*r;
        # move beta of selected feature from 0 to <xj,r>
        for st=1:steps
          beta_hat(find(active)+1)=beta_hat(find(active)+1)+alpha.*delta(2:end);
          y_hat=[ones(m,1) x]*beta_hat;
          r=y-y_hat;
          # stop if some other feature has as much correlation with r as selected feature
          [v competitor]=max(abs(corr(x,r)));
          if competitor!=pos
            break
          end
        end
        
      end
      
  # least angle regression - lasso modification      
    case 'lar-lasso'
      if ~exist('alpha', 'var') || isempty(alpha)
        alpha=0.1;
      end  
      if ~exist('zero_value', 'var') || isempty(zero_value)
        zero_value=10^-5;
      end    
      # initialize
      beta_hat=zeros(n+1,1);
      beta_hat(1)=mean(y);
      y_hat=[ones(m,1) x]*beta_hat;
      r=y-y_hat;
      
      active=zeros(n,1);
      steps=1/alpha;
      # find feature most correlated with residual
      i=0;
      nstep=0;
      while i<min(m-1,n)
        i=i+1;
        nstep=nstep+1;
        # add most correlated feature to active set
        [v pos]=max(abs(corr(x,r)));
        competitor=pos;
        active(pos)=1;
        x0=[ones(m,1) x(:,find(active))];
        delta=pinv(x0'*x0)*x0'*r;
        # move beta of selected feature from 0 to <xj,r>
        for st=1:steps
          beta_hat(find(active)+1)=beta_hat(find(active)+1)+alpha.*delta(2:end);
          y_hat=[ones(m,1) x]*beta_hat;
          r=y-y_hat;
          # stop if some other feature has as much correlation with r as selected feature
          [v competitor]=max(abs(corr(x,r)));
          if competitor!=pos
            break
          end
        end
        # lasso modification
        lasso_flag=find((abs(beta_hat)<zero_value)&[1; active]);
        if !isempty(lasso_flag)
          beta_hat(lasso_flag)=0;
          active(lasso_flag-1)=0;
          i=i-1;
        end
        model.nstep=nstep;
      end
    
  # principal components regression
    case 'pcr'
      if ~exist('threshold', 'var') || isempty(threshold)
        threshold=0.99;
      end  
      [u d v]=svd(cov(x));
      var_cum=0;
      for i=1:n
        var_cum=var_cum+d(i,i);
        if var_cum>=threshold*n
          ured=u(:,1:i);
          break
        end
      end
      z=x*ured;
      theta_hat=zeros(n,1);
      for j=1:numel(theta_hat)
        theta_hat(j)=(z(:,j)'*y)/(z(:,j)'*z(:,j));
      end
      beta_hat=zeros(n+1,1);
      beta_hat(2:(n+1),1)=ured*theta_hat;
      beta_hat(1)=mean(y);
      model.variance_threshold=threshold;
      model.theta_hat=theta_hat;
      
  # partial least squares regression
    case 'pls'
      if ~exist('l', 'var') || isempty(l)
        l=n;
      end  
      y_hat=mean(y);
      x0= x;
      Z=[];
      PHI=[];
      THETA=[];
      P=[];
      beta_hat=zeros(n,1);
      for i=1:l
        phi=x0'*y;
        PHI=[PHI phi];
        z=x0*phi;
        Z=[Z z];
        theta_hat=(z'*y)/(z'*z); 
        THETA=[THETA;theta_hat];
        p=(z'*x0)/(z'*z);
        P=[P p'];
        y_hat=y_hat+theta_hat*z;
        x0=x0-z*(z'*x0)/(z'*z);
      end
      beta_hat=[mean(y);PHI*pinv(P'*PHI)*THETA];
      model.l=l;
      model.Z=Z;
      model.PHI=PHI;
      model.THETA=THETA;
      model.P=P;
      
  # general spline or natural cubic spline or b spline regression
    case {'general spline','natural cubic spline','b spline'}
      splines=splines1D(x,type,options);
      beta_hat=pinv(splines.h'*splines.h)*splines.h'*y;
      #beta_hat=pinv(splines.h'*splines.h)*splines.h'*y
      if strcmp(type,'b spline')
        model.tau=splines.tau;
      end
      
      model.epsilon=splines.epsilon;
      model.nK=splines.nK;
      model.M=splines.M;
      model.knots=splines.knots;
      model.h=splines.h;
    
  # smoothing spline regression
    case {'smoothing spline'}
      splines=splines1D(x,type,options);
      beta_hat=pinv(splines.h'*splines.h+splines.lambda.*splines.omega)*splines.h'*y;
      #beta_hat=pinv(splines.h'*splines.h)*splines.h'*y
      if strcmp(type,'b spline')
        model.tau=splines.tau;
      end
      
      model.epsilon=splines.epsilon;
      model.nK=splines.nK;
      model.M=splines.M;
      model.knots=splines.knots;
      model.h=splines.h;
      model.omega=splines.omega;
      model.lambda=splines.lambda;
      model.S=splines.S;
      
  endswitch
  
  # information to retrieve
  model.type=type;
  model.x=x;
  model.y=y;
  model.beta=beta_hat;
  
  
end
