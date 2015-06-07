function epe=EPE(y,y_hat)
  # integrated squared prediction error
  epe=sum((y(:)-y_hat(:)).^2)/length(y);
end
