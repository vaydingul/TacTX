global tactx
initRandomMeasurement;
tactx = TacTX('State', IdleState, 'Config', CONFIG);
tactx.NIHandler.ScansAvailableFunction = @(src,evt) cllbk(src,evt);
sgn = idinput([200000, 1], 'prbs', [0 1/20], [-3 3]);

tactx.SignalGenerator.Signal = sgn;

disp("NOW!");
tactx.run();

tactx.idle();

figure;
plot(tactx.ForceSensor.ForceTorque);

figure;
plot(tactx.Accelerometer.Acceleration);

figure;
scatter(tactx.FingerTracker.FingerPosition(:,1),tactx.FingerTracker.FingerPosition(:,2))

figure;
plot(sgn);

