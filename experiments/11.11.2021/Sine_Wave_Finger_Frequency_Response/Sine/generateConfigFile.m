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

signals = {};

for k = 1:length(signalTypes)
    
    duration = config.SLIDING_DISTANCE / slidingVelocity(k);
    time = 0:1/config.SAMPLE_RATE:duration;
    
    signal = generateSignal(signalTypes(k), time, config.SIGNAL_PARAMETER_1(k), config.SIGNAL_PARAMETER_2(k));
    signals{k} = signal;
    
end

config.NUMBER_OF_SLIDINGS = numberOfSlidings;
config.SIGNAL = signals;
config.NORMAL_FORCE = normalForce;
config.SLIDING_VELOCITY = slidingVelocity;

end

function signal = generateSignal(signalType, time, frequency, amplitude)

switch signalType
    
    case 1
        
        signal = amplitude * sin(2 * pi * frequency * time(1:length(time)))';
        
    case 2
        
        signal = amplitude * sawtooth(2 * pi * frequency * time(1:length(time)))';
        
    case 3
        
        signal = amplitude * square(2 * pi * frequency * time(1:length(time)))';
        
    otherwise
        
        error("Please input correct signal type!");
        
end

end
