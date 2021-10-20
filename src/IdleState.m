classdef IdleState < State

	

	methods (Access = public)

		function run(obj, tactx)
			
			tactx.NIHandler.flush();
			tactx.NIHandler.preload(tactx.SignalGenerator.SignalProcessed(1 : floor(length(tactx.SignalGenerator.SignalProcessed)/2)));
			tactx.SignalGenerator.Buffer = tactx.SignalGenerator.Buffer + floor(length(tactx.SignalGenerator.SignalProcessed)/2);
			
			tactx.NIHandler.start("Continuous");
			tactx.MISCHandler.start();

			tactx.State = RunState();


		end

		function idle(obj, tactx)
			
			warning("TacTX is currently in the IDLE state.")
			tactx.State = IdleState();


		end

		function save(obj, tactx)

			save('trial.mat', 'tactx');
			tactx.State = SaveState();


		end

	end
	
end