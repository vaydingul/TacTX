initExperiment;
config = generateConfigFile(CONFIG, 1,2  , 0.5, 4);
tactx = TacTX('State', IdleState, 'Config', config);

tactx.SignalGenerator.Signal = 2*tactx.Config.SIGNAL{1};


disp("NOW!");
tactx.run("RepeatOutput");

%%
tactx.idle();

figure;
plot(tactx.ForceSensor.ForceTorque);

figure;
plot(tactx.Accelerometer.Acceleration);


