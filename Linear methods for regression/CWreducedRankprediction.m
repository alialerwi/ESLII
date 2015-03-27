function Ycw=CWreducedRankprediction(x,Bcw)
  
  [m n]=size(x);
  x=[ones(m,1) x];
  Ycw=x*Bcw;

end