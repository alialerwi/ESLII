function [xn, mu ,sd]=normalize(x,mu,sd)
  
  [m n]=size(x);
  
  if ~exist('mu', 'var') || isempty(mu)
		mu=mean(x,1);
	end

	if ~exist('sd', 'var') || isempty(sd)
		sd=std(x,[],1);
		sd(sd==0)=1;
	end
	
	xn=(x-ones(m,1)*mu)./(ones(m,1)*sd);
  
  end