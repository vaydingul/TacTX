classdef () MISCHandler < Handler

    properties (Access = public)
        Rate
		Timer
    end

	methods (Access = public)


		function obj = MISCHandler(rate)
			obj.Rate = rate;
			obj.Timer = timer('TimerFcn', @obj.read,...
							'StartFcn', '',...
							'StopFcn', '',...
							'Period', 1 / obj.Rate,...
							'StartDelay', 0,...
							'TasksToExecute', 3,...
							'BusyMode', 'queue',...
							'ExecutionMode', 'fixedRate',...
							)
		end
	
		function outData = read(obj)

            pointerLocation = get(0, 'PointerLocation');
            screenSize = get(0, 'MonitorPositions');
            outData = pointerLocation ./ screenSize(3:4);            

		end
	end

	

end
