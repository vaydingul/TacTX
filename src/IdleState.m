classdef IdleState < State

	

	methods (Access = public)

		function run(obj, tactx)

			obj.TacTX.NIHandler.start('RepeatOutput');

			tactx.State = RunState();


		end

		function idle(obj, tactx)


			tactx.State = IdleState();


		end

		function save(obj, tactx)


			tactx.State = SaveState();


		end

	end
	
end