function config = generateConfigFile(config, varargin)


load('signals.mat', 'sp1', 'sm1');
signals = {};

signals{1} = sp1;
signals{2} = sm1;

config.SIGNAL = signals;

end

