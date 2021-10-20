classdef SignalGenerator < Transducer

	properties (Access = public)

		Device
		Signal
        SignalProcessed
		Repetition
		Bias
		Scale 
		
	end

	properties

		Buffer
		BufferStep

	end

	methods (Access = public)

		function obj = SignalGenerator(varargin)
			
			obj.Device = NIDevice("Dev2",...
								{"ao1"},...
								"Voltage",...
								"Output", ...
								"SingleEnded");
								
            obj.Repetition = 1;
			obj.Bias = 0;
			obj.Scale = 1;                
			obj.Signal = [];
			obj.Buffer = 1;
			
            if ~isempty(varargin) && mod(nvarargin, 2) == 0
                
                for k = 1:2:nvarargin
                    
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

		function set.Buffer(obj, buffer)

			if buffer + obj.BufferStep > length(obj.SignalProcessed) 

				buffer = 1;

			end

			obj.Buffer = buffer;

		end
	end

end