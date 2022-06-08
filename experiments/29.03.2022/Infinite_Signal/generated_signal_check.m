initExperiment;
config = generateConfigFile(CONFIG, 2, 5, 0.5, 4);
tactx = TacTX('State', IdleState, 'Config', config);


Fs = 5000;
f = 100;
t = 0:1/Fs:1;
s =  sin(2 * pi * f * t)';
s(end) = [];

% tactx.SignalGenerator.Signal = s;%[zeros(1000, 1); s; zeros(1000, 1)];

tactx.SignalGenerator.Signal = tactx.Config.SIGNAL{1};
tactx.biasForceSensor();

disp("NOW!");
tactx.run("RepeatOutput");
