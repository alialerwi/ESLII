function a=test(x,varargin,f)
  for i=2:2:numel(varargin) 
   eval(strcat(varargin{(i-1)}, '=', varargin{i},';'));
  end
  whos
  x
  if exist('f','var')
    f
  end
  
end