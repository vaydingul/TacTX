classdef SignalGenerator < Transducer

	properties (Access = public)

		Device
		Signal
        SignalProcessed
		Repetition
		Bias
		Scale 
		
	end


	methods (Access = public)

		function obj = SignalGenerator(varargin)
			
			obj.Device = NIDevice("Dev3",...
								{"ao0"},...
								"Voltage",...
								"Output", ...
								"SingleEnded");
								
            obj.Repetition = 1;
			obj.Bias = 0;
			obj.Scale = 1;                
			obj.Signal = [];
			
            if ~isempty(varargin) && mod(nargin, 2) == 0
                
                for k = 1:2:nargin
                    
                    obj.(varargin{k}) = varargin{k + 1};
                    
                end
                
            end

		end

		function process(obj)
            
			obj.SignalProcessed = repmat((obj.Signal + obj.Bias) * obj.Scale, obj.Repetition);
            
		end
	end

	methods

		function set.Signal(obj, signal)

			obj.Signal = signal;
            obj.process();
		end
		
	end

end