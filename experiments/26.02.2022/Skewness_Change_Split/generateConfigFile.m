function config = generateConfigFile(config, varargin)

switch nargin - 1
    case 1
        
        numberOfSlidings = varargin{1};
        signalTypes = 1;
        normalForce = 0.5;
        slidingVelocity = 4;
        
    case 2
        
        numberOfSlidings = varargin{1};
        signalTypes = varargin{2};
        normalForce = 0.5;
        slidingVelocity = 4;
        
    case 3
        
        numberOfSlidings = varargin{1};
        signalTypes = varargin{2};
        normalForce = varargin{3};
        slidingVelocity = 4;
        
    case 4
        
        numberOfSlidings = varargin{1};
        signalTypes = varargin{2};
        normalForce = varargin{3};
        slidingVelocity = varargin{4};
        
    otherwise
        
        numberOfSlidings = 1;
        signalTypes = 1;
        normalForce = 0.5;
        slidingVelocity = 4;
        
end

if length(signalTypes) == 1
    
    signalTypes = signalTypes * ones(1, numberOfSlidings);
    
end

if length(normalForce) == 1
    
    normalForce = normalForce * ones(1, numberOfSlidings);
    
end

if length(slidingVelocity) == 1
    
    slidingVelocity = slidingVelocity * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_1) == 1
    
    config.SIGNAL_PARAMETER_1 = config.SIGNAL_PARAMETER_1 * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_2) == 1
    
    config.SIGNAL_PARAMETER_2 = config.SIGNAL_PARAMETER_2 * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_3) == 1
    
    config.SIGNAL_PARAMETER_3 = config.SIGNAL_PARAMETER_3 * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_4) == 1
    
    config.SIGNAL_PARAMETER_4 = config.SIGNAL_PARAMETER_4 * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_5) == 1
    
    config.SIGNAL_PARAMETER_5 = config.SIGNAL_PARAMETER_5 * ones(1, numberOfSlidings);
    
end

if length(config.SIGNAL_PARAMETER_6) == 1
    
    config.SIGNAL_PARAMETER_6 = config.SIGNAL_PARAMETER_6 * ones(1, numberOfSlidings);
    
end

signals = {};

for k = 1:length(signalTypes)
    
    duration = config.SLIDING_DISTANCE / slidingVelocity(k);
    time = 0:1/config.SAMPLE_RATE:duration;
    
    signal = generateSignal(signalTypes(k), time, config.SIGNAL_PARAMETER_1(k), config.SIGNAL_PARAMETER_2(k), config.SIGNAL_PARAMETER_3(k), config.SIGNAL_PARAMETER_4(k), config.SIGNAL_PARAMETER_5(k), config.SIGNAL_PARAMETER_6(k));
    signals{k} = signal;
    
end

config.NUMBER_OF_SLIDINGS = numberOfSlidings;
config.SIGNAL = signals;
config.NORMAL_FORCE = normalForce;
config.SLIDING_VELOCITY = slidingVelocity;

end

function signal = generateSignal(signalType, time, mu, sigma, skew1, skew2, kurt1, kurt2)

switch signalType
    
    case 1
        s1 = pearsrnd(mu,sigma,skew1,kurt1,floor(length(time)),1);
        s1 = s1(1 : floor(length(time) / 10));
        s1 = resample(s1, 5, 1);
        
        s2 = pearsrnd(mu,sigma,skew2,kurt2,floor(length(time)),1);
        s2 = s2(1 : floor(length(time) / 10));
        s2 = resample(s2, 5, 1);
        
        signal = 2 * [s1; ...
            s2];
        
    case 2
        s1 = pearsrnd(mu,sigma,skew2,kurt2,floor(length(time)),1);
        s1 = resample(s1, 1, 2);
        
        s2 = pearsrnd(mu,sigma,skew1,kurt1,floor(length(time)),1);
        s2 = resample(s2, 1, 2);
        signal = 2*[s1;...
            s2];
    case 3
        
        signal = 3 * sin(2 * pi * 50 * time(1:length(time)))';
        
    case 4
        
        signal = 3 * sawtooth(2 * pi * 50 * time(1:length(time)))';
        
    case 5
        
        signal = 3 * square(2 * pi * 50 * time(1:length(time)))';
        
        
    otherwise
        
        error("Please input correct signal type!");
        
end

end
