classdef TacTX < handle

	properties (Access = public)
		
		%Handler
		%Transducer
		%State
		%Config

		NIHandler
		MISCHandler
		ForceSensor
		Accelerometer
		SignalGenerator
		FingerTracker

		State
		Config
	end
	
	methods (Access = public)

		function obj = TacTX(varargin)

			%obj.Handler = {};
			%obj.Transducer = {};
			%obj.State = {};
			%obj.Config = {};
			
			obj.NIHandler = NIHandler;
			obj.MISCHandler = MISCHandler;
			obj.ForceSensor = ForceSensor;
			obj.Accelerometer = Accelerometer;
			obj.SignalGenerator = SignalGenerator;
			obj.FingerTracker = FingerTracker;

			if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

			obj.match();
			
		end

		function run(obj)

			obj.State.run(obj);

		end

		function idle(obj)

			obj.State.idle(obj);

		end

		function save(obj)

			obj.State.save(obj);

		end

	end

	methods (Access = private)

		function match(obj)

			obj.NIHandler.addDevice(obj.ForceSensor);
			obj.NIHandler.addDevice(obj.Accelerometer);
			obj.NIHandler.addDevice(obj.SignalGenerator);
			obj.MISCHandler.Transducer = obj.FingerTracker;

		end

	end
end