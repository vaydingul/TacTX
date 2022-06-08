function config = generateConfigFile(config, varargin)


load('signals.mat', 'z');

config.SIGNAL = z{2, 1}{1}{2};



end

