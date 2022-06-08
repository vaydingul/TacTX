function config = generateConfigFile(config, varargin)

switch nargin - 1
    case 1
        
        numberOfSlidings = varargin{1};
        normalForce = 0.5;
        slidingVelocity = 4;
        
    case 2
        
        numberOfSlidings = varargin{1};
        normalForce = 0.5;
        slidingVelocity = 4;
        
    case 3
        
        numberOfSlidings = varargin{1};

        normalForce = varargin{2};
        slidingVelocity = varargin{3};
        
  
        
    otherwise
        
        numberOfSlidings = 1;
        normalForce = 0.5;
        slidingVelocity = 4;
        
end



if length(normalForce) == 1
    
    normalForce = normalForce * ones(1, numberOfSlidings);
    
end

if length(slidingVelocity) == 1
    
    slidingVelocity = slidingVelocity * ones(1, numberOfSlidings);
    
end





config.NUMBER_OF_SLIDINGS = numberOfSlidings;
config.NORMAL_FORCE = normalForce;
config.SLIDING_VELOCITY = slidingVelocity;



end
