classdef SaveState < State

	properties (Access = public)

		TacTX
		
	end

	methods (Access = public)

		function run(obj, tactx)


			tactx.State = IdleState();
		end

		function idle(obj, tactx)


			tactx.State = IdleState();
		end

		function save(obj, tactx)


			tactx.State = SaveState();
		end

	end
	
end