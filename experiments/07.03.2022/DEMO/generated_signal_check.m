initExperiment;
config = generateConfigFile(CONFIG, 2, 4, 0.5, 4);
tactx = TacTX('State', IdleState, 'Config', config);

tactx.SignalGenerator.Signal = [tactx.Config.SIGNAL{1}];
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