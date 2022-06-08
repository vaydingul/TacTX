initExperiment;
config = generateConfigFile(CONFIG, 1, 1 , 0.5, 4);
tactx = TacTX('State', IdleState, 'Config', config);

tactx.SignalGenerator.Signal = tactx.Config.SIGNAL{1};
tactx.biasForceSensor()

disp("NOW!");
tactx.run("RepeatOutput");

%%
tactx.idle();

figure;
plot(tactx.ForceSensor.ForceTorque(2:end, 1:3));


