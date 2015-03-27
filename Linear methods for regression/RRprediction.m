function Yrr=RRprediction(x,Brr)
  
  [m n]=size(x);
  x=[ones(m,1) x];
  Yrr=x*Brr;
end