function [beta_min rss_hist]=forwardSelection(x,y,k)

  [m n]=size(x);
  
  idx=1:n;
  xset=ones(1,n);
  rss_hist=[];
  for i=1:min(n,k)
    rss_min=Inf;
    for j=find(idx.*xset)
      xregr=zeros(size(x));
      xregr(:,[find(xset==0) j])=x(:,[find(xset==0) j]);
      
      beta_hat=normalEquation(xregr,y);
      rss=normalRss(xregr,y,beta_hat);
      if rss<rss_min
        rss_min=rss;
        p=j;
        beta_min=beta_hat;
      end
    end
    rss_hist=[rss_hist;rss_min];
    xset(:,p)=0;
 
  end
  
  end