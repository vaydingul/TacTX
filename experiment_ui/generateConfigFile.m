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

    for k = 1:length(signalTypes)

        duration = config.SLIDING_DISTANCE / slidingVelocity(k);
        signalSize = duration * config.SAMPLE_RATE;

        signal = generateSignal(signalTypes(k), signalSize, config.PRBS_CLOCK_PERIOD);
        signals{k} = signal;

    end
    
    config.NUMBER_OF_SLIDINGS = numberOfSlidings;
	config.SIGNAL = signals;
	config.NORMAL_FORCE = normalForce;
	config.SLIDING_VELOCITY = slidingVelocity;

end

function signal = generateSignal(signalType, signalSize, prbsClockPeriod)

    switch signalType

        case 1

            signal = [zeros(floor(signalSize / 2), 1); ...
                    idinput([floor(signalSize / 2), 1], 'prbs', [0 1/prbsClockPeriod], [-3 3])];

        case 2

            signal = [idinput([floor(signalSize / 2), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]); ...
                                                                        zeros(floor(signalSize / 2), 1)];

        case 3

            signal = [zeros(1, int16(signalSize / 3)), ...
                    idinput([int16(signalSize / 3), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]), ...
                    zeros(1, int16(signalSize / 3))];

        case 4

            signal = [idinput([int16(signalSize / 3), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]), ...
                                                                        zeros(1, int16(signalSize / 3)), ...
                                                                        idinput([int16(signalSize / 3), 1], 'prbs', [0 1/prbsClockPeriod], [-3 3])];

        case 5

            signal = [zeros(1, int16(signalSize / 6)), ...
                    idinput([int16(signalSize / 6), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]), ...
                    zeros(1, int16(signalSize / 6)), ...
                    idinput([int16(signalSize / 6), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]), ...
                    zeros(1, int16(signalSize / 6)), ...
                    idinput([int16(signalSize / 6), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3])];

        case 6

            signal = [idinput([int16(signalSize / 6), 1], 'rbs', [0 1/prbsClockPeriod], [-3 3]), ...
                                                                        zeros(1, int16(signalSize / 6)), ...
                                                                        idinput([int16(signalSize / 6), 1], 'prbs', [0 1/prbsClockPeriod], [-3 3]), ...
                                                                        zeros(1, int16(signalSize / 6)), ...
                                                                        idinput([int16(signalSize / 6), 1], 'prbs', [0 1/prbsClockPeriod], [-3 3]), ...
                                                                        zeros(1, int16(signalSize / 6))];

        otherwise

            error("Please input correct signal type!");

    end

end
