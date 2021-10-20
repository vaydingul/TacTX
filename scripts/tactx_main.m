tactx = TacTX('State', IdleState);
sgn = idinput([1275, 1], 'prbs', [0 1/5], [-3 3]);

tactx.SignalGenerator.Signal = sgn;

disp("NOW!");
tactx.run()

