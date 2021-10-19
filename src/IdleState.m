classdef IdleState < State

	properties (Access = public)

		TacTX
		
	end

	methods (Access = public)

		function run(obj)


			obj.TacTX.State = RunState();

			
		end

		function idle(obj)


			obj.TacTX.State = IdleState();


		end

		function save(obj)


			obj.TacTX.State = SaveState();


		end

	end
	
end