initExperiment;
CONFIG = generateConfigFile(CONFIG);
tactx = TacTX('Config', CONFIG, 'State', IdleState);

tactx.SignalGenerator.Signal = tactx.Config.SIGNAL{1};

tactx.biasForceSensor();

tactx.run('RepeatOutput');
disp('NOW')
pause(5.);
disp('STOP')
tactx.idle();

scatter(tactx.FingerTracker.FingerPosition(:,1),tactx.FingerTracker.FingerPosition(:,2))



