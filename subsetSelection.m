function [beta_min comb_min rss_min]=subsetSelection(x,y,k)
  
  [m n]=size(x);
  combs=nchoosek(1:n,k);
  
  rss_min=Inf;
  comb_min=[];
  beta_min=[];
  for i=1:size(combs,1)
  comb=combs(i,:);
    [beta_hat beta_sd beta_ci y_hat b_k rss]=linearRegression(x(:,comb),y,alpha=0.05);
    if rss<rss_min
      rss_min=rss;
      comb_min=comb;
      beta_min=beta_hat;
    end  
  end
  
end