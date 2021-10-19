tactx = TacTX('State', IdleState);
sgn = idinput([1000, 1], 'prbs', [0 1/5], [-3 3]);

tactx.SignalGenerator.Signal = sgn;

tactx.run()

