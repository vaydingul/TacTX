classdef IdleState < State

	

	methods (Access = public)

		function run(obj, tactx, varargin)
			
			tactx.NIHandler.flush();

            
            if tactx.Config.EXPERIMENT_MODE
                
                tactx.NIHandler.preload(tactx.SignalGenerator.SignalProcessed);
                
            end
			
			tactx.NIHandler.start(varargin);
			
			if tactx.Config.PRACTICE_MODE
				
				tactx.MISCHandler.start();

			end
			
			tactx.State = RunState();


		end

		function idle(obj, tactx)
			
			warning("TacTX is currently in the IDLE state.")
			tactx.State = IdleState();


		end

		function save(obj, tactx, varargin)
            
            if nargin > 2
                
                save(char(varargin{1}), 'tactx');
                
            else
                
                save('trial.mat', 'tactx');
                
            end

			tactx.ForceSensor.GaugeVoltage = zeros(1,6);
			tactx.Accelerometer.GaugeVoltage = zeros(1,3);
			tactx.ForceSensor.ForceTorque = zeros(1,6);
			tactx.Accelerometer.Acceleration = zeros(1,3);
			tactx.State = SaveState();
    

		end

	end
	
end