classdef SignalGenerator < Transducer

	properties (Access = public)

		Device
		Signal
		Repetition
		Bias
		Scale 
	end

	methods (Access = public)

		function obj = ForceSensor(varargin)
			
			obj.Device = NIDevice("Dev2",...
								{"ai4", "ai12", "ai5"},...
								"Voltage",...
								"Input");
			obj.Signal = [];
			obj.Repetition = 1;
			obj.Bias = 1;
			obj.Scale = 1;
			
			if ~isempty(varargin) && mod(nvarargin, 2) == 0

                for k = 1:2:nvarargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

		end

	

		function process(obj)

			obj.Signal = repmat((obj.Signal + obj.Bias) * obj.Scale, 1, obj.Repetition);

		end
	end

end