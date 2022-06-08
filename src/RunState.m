classdef RunState < State

	
	methods (Access = public)

		function run(obj, tactx, ~)

			warning("TacTX is currently in the RUN state.")
			tactx.State = RunState();
		end

		function idle(obj, tactx)

			tactx.NIHandler.stop();			
			tactx.MISCHandler.stop();
			%tactx.NIHandler.flush();

			tactx.State = IdleState();
		end

		function save(obj, tactx)

			warning("TacTX is currently in the RUN state. To save the data, it should be switched to the IDLE state.")
			tactx.State = SaveState();
			
		end

	end
	
end