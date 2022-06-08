function config = generateConfigFile(config, varargin)


load('trials.mat', 'trials');
load('signals.mat', 'z');
signals = {};

signals{1} = z{1, 1}{1}{2};
signals{2} = z{1, 3}{1}{2};

config.SIGNAL = signals;
config.TRIALS = trials;
config.NUMBER_OF_TRIALS = size(trials, 1);
end

