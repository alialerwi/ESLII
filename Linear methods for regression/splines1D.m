function splines=splines1D(x,type,options={},epsilon)

  # spline methods implemented:
  # - general spline 
  # - natural cubic spline 
  # - b spline
  # - smoothing spline
  
  # possible to change M (order of spline), knots (internal knots of the domain), nK (number of knots), lambda 
  # 

  for i=2:2:numel(options) 
    eval(strcat(options{(i-1)}, '=[', num2str(options{i}(:)'),'];'))
  end
  
  x=x(:);
  m=numel(x);
  
  if ~exist('epsilon', 'var') || isempty(epsilon)
    epsilon=[min(x); max(x)];
  end

  if ~exist('M', 'var') || isempty(M)
    M=4;
  end
    
  if ~exist('knots', 'var') || isempty(knots)   
    if ~exist('nK', 'var') || isempty(nK)
      knots=unique(x)(2:(end-1))(:);
      nK=numel(knots);
    else
      knots=linspace(epsilon(1),epsilon(2),nK+2)(2:(end-1))(:);
    end
  else
    nK=numel(knots);
  end

  switch type
  
  # general spline
    case 'general spline'     
      h=zeros(m,M+nK);
      for j=1:M
        h(:,j)=x.^(j-1);
      end
      for l=1:nK
        h(:,M+l)=(x>=knots(l)).*(x-knots(l)).^(M-1);
      end

  # natural cubic spline
    case 'natural cubic spline'     
      h=zeros(m,nK);
      h(:,1)=1;
      h(:,2)=x;
      k=nK-1;
      dK_1=(((x>=knots(k)).*(x-knots(k))).^3-((x>=knots(nK)).*(x-knots(nK))).^3)./(knots(nK)-knots(k));
      for k=1:(nK-2)
        dk=(((x>=knots(k)).*(x-knots(k))).^3-((x>=knots(nK)).*(x-knots(nK))).^3)./(knots(nK)-knots(k));
        h(:,k+2)=dk-dK_1;
      end  
      
  # b spline
    case 'b spline'
      #tau=[repmat(min(x),M,1);knots(:);repmat(max(x),M,1)];
      delta=10^5;
      step=delta/max(1,(M-1));
      if M==1
        tau=[epsilon(1);knots(:);epsilon(2)];
      else
        tau=[((epsilon(1)-delta):step:epsilon(1))';knots(:);(epsilon(2):step:(epsilon(2)+delta))'];
      end
      for m_=1:M
        b=zeros(m,nK+2*M-m_);
        db=zeros(m,nK+2*M-m_);
        ddb=zeros(m,nK+2*M-m_);
        for i=1:(nK+2*M-m_)
          if m_==1
            #if tau(i)==tau(i+1)
            #  b(:,i)=0;
            #else
              b(:,i)=(x>=tau(i))&(x<tau(i+1));
              db(:,i)=0;
              ddb(:,i)=0;
            #end
          else
           # if tau(i)==tau(i+m_-1)||tau(i+m_)==tau(i+1)
           #   b(:,i)=0;
          #  else
              b(:,i)=b_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                b_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1));
              db(:,i)=db_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                b_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                db_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1))+...
                b_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1));
              ddb(:,i)=ddb_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                db_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                db_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                ddb_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1))+...
                db_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1))+...
                db_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1));
            #end    
          end
        end
        b_prev=b;
        db_prev=db;
        ddb_prev=ddb;
      end
      splines.tau=tau;
      h=b;
      
  # smoothing spline
    case 'smoothing spline'
      #tau=[repmat(min(x),M,1);knots(:);repmat(max(x),M,1)];
      delta=10^5;
      step=delta/max(1,(M-1));
      if M==1
        tau=[epsilon(1);knots(:);epsilon(2)];
      else
        tau=[((epsilon(1)-delta):step:epsilon(1))';knots(:);(epsilon(2):step:(epsilon(2)+delta))'];
      end
      for m_=1:M
        b=zeros(m,nK+2*M-m_);
        db=zeros(m,nK+2*M-m_);
        ddb=zeros(m,nK+2*M-m_);
        for i=1:(nK+2*M-m_)
          if m_==1
            #if tau(i)==tau(i+1)
            #  b(:,i)=0;
            #else
              b(:,i)=(x>=tau(i))&(x<tau(i+1));
              db(:,i)=0;
              ddb(:,i)=0;
            #end
          else
           # if tau(i)==tau(i+m_-1)||tau(i+m_)==tau(i+1)
           #   b(:,i)=0;
          #  else
              b(:,i)=b_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                b_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1));
              db(:,i)=db_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                b_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                db_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1))+...
                b_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1));
              ddb(:,i)=ddb_prev(:,i).*(x-tau(i))/(tau(i+m_-1)-tau(i))+...
                db_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                db_prev(:,i)./(tau(i+m_-1)-tau(i))+...
                ddb_prev(:,i+1).*(tau(i+m_)-x)/(tau(i+m_)-tau(i+1))+...
                db_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1))+...
                db_prev(:,i+1).*(-1)/(tau(i+m_)-tau(i+1));
            #end    
          end
        end
        b_prev=b;
        db_prev=db;
        ddb_prev=ddb;
      end
      h=b;
      omega=zeros(size(h,2));
      for j=1:size(h,2)
        for k=1:size(h,2)
          omega(j,k)=sum(ddb(:,j).*ddb(:,k));
        end
      end
      
      splines.tau=tau;
      splines.lambda=lambda;
      splines.omega=omega;
  
  endswitch
  
    splines.epsilon=epsilon;
    splines.M=M;
    splines.nK=nK;
    splines.knots=knots;
    splines.h=h;
  
end
