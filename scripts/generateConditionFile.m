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

	signals = {};
	for k = 1 : length(signalTypes)

		duration = config.
		signal = generateSignal(signalTypes(k), signalSize);
		signals{k} = signal;

	end



end


function signal = generateSignal(signalType, signalSize)

	switch signalType

	case 1

	case 2

	case 3

	case 4

	case 5

	case 6

	case 7

	case 8


	otherwise

		error("Please input correct signal type!");

	end



end