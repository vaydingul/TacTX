classdef IdleState < State

	

	methods (Access = public)

		function run(obj, tactx)
			
			tactx.NIHandler.preload(tactx.SignalGenerator.Signal);
			tactx.NIHandler.start('RepeatOutput');
			tactx.MISCHandler.start();

			tactx.State = RunState();


		end

		function idle(obj, tactx)
			
			warning("TacTX is currently in the IDLE state.")
			tactx.State = IdleState();


		end

		function save(obj, tactx)

			save('trial.mat', 'obj');
			tactx.State = SaveState();


		end

	end
	
end