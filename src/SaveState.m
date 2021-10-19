classdef SaveState < State

	properties (Access = public)

		TacTX
		
	end

	methods (Access = public)

		function run(obj, tactx)

			warning("You should first switch to the IDLE state. You are being switched to the IDLE state.")
			tactx.State = IdleState();
		end

		function idle(obj, tactx)

			
			tactx.State = IdleState();
		end

		function save(obj, tactx)

			warning("TacTX is currently in the SAVE state.")
			tactx.State = SaveState();
		end

	end
	
end