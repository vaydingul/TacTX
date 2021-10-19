classdef IdleState < State

	

	methods (Access = public)

		function run(obj, tactx)
			
			obj.TacTX.NIHandler.preload(get(obj.TacTX.SignalGenerator, 'Signal'));
			obj.TacTX.NIHandler.start('RepeatOutput');
			obj.TacTX.MISCHandler.start();

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