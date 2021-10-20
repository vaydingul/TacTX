classdef RunState < State

	
	methods (Access = public)

		function run(obj, tactx)

			warning("TacTX is currently in the RUN state.")
			tactx.State = RunState();
		end

		function idle(obj, tactx)

			tactx.NIHandler.stop();			
			tactx.MISCHandler.stop();
			
			tactx.State = IdleState();
		end

		function save(obj, tactx)

			save('trial.mat', 'tactx');
			tactx.State = SaveState();
			
		end

	end
	
end