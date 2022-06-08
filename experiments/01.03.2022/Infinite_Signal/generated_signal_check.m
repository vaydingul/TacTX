initExperiment;
config = generateConfigFile(CONFIG, 2, 3, 0.5, 4);
tactx = TacTX('State', IdleState, 'Config', config);

Fs = 5000;
f = 100;
t = 0:1/Fs:10;
s =  sin(2 * pi * f * t)';
tactx.SignalGenerator.Signal = s;%4 * ones(10000, 1);%[tactx.Config.SIGNAL{1}];

% tactx.SignalGenerator.Signal = tactx.Config.SIGNAL{1};

disp("NOW!");
tactx.run("RepeatOutput");
%%
pause(3.0);
tactx.idle;


tactx.SignalGenerator.Signal = tactx.Config.SIGNAL{2};
disp("NOW!");
tactx.run("RepeatOutput");

pause(3.0);
tactx.idle;

%%
rms(tactx.Config.SIGNAL{1})
rms(tactx.Config.SIGNAL{2})
var(tactx.Config.SIGNAL{1})
var(tactx.Config.SIGNAL{2})
std(tactx.Config.SIGNAL{1})
std(tactx.Config.SIGNAL{2})
mean(tactx.Config.SIGNAL{1})
mean(tactx.Config.SIGNAL{2})
skewness(tactx.Config.SIGNAL{1})
skewness(tactx.Config.SIGNAL{2})
kurtosis(tactx.Config.SIGNAL{1})
kurtosis(tactx.Config.SIGNAL{2})