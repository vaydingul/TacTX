tactx = TacTX('State', IdleState);
sgn = idinput([10000, 1], 'prbs', [0 1/5], [-3 3]);

tactx.SignalGenerator.Signal = sgn;

disp("NOW!");
tactx.run();

figure;
plot(tactx.ForceSensor.ForceTorque);

figure;
plot(tactx.Accelerometer.Acceleration);

figure;
scatter(tactx.FingerTracker.FingerPosition(:,1),tactx.FingerTracker.FingerPosition(:,2))

figure;
plot(sgn);