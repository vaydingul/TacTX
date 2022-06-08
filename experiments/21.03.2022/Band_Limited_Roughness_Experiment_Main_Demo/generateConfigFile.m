function config = generateConfigFile(config, varargin)


load('trials.mat', 'trials');
load('signals.mat', 'sp1', 'sm1');
signals = {};

signals{1} = 1.2 * sp1;
signals{2} = 1.2 * sm1;

config.SIGNAL = signals;
config.TRIALS = trials;
config.NUMBER_OF_TRIALS = size(trials, 1);
end

