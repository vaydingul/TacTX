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

            obj.NIHandler = NIHandler();
            obj.MISCHandler = MISCHandler();
            obj.ForceSensor = ForceSensor();
            obj.Accelerometer = Accelerometer();
            obj.SignalGenerator = SignalGenerator();
            obj.FingerTracker = FingerTracker();

            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

            obj.NIHandler.ScansAvailableFunction = @(src, evt) obj.scansAvailableFunction(src, evt);
            obj.NIHandler.ScansAvailableFunctionCount = 100;

            obj.NIHandler.ScansRequiredFunction = @(src, evt) obj.scansRequiredFunction(src, evt);
            obj.NIHandler.ScansRequiredFunctionCount = 500;

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

        function scansAvailableFunction(obj, ~, ~)

            outData = obj.NIHandler.read(obj.NIHandler.ScansAvailableFunctionCount);

            obj.ForceSensor.GaugeVoltage = cat(1, obj.ForceSensor.GaugeVoltage, outData(:, 1:6));
            obj.Accelerometer.GaugeVoltage = cat(1, obj.Accelerometer.GaugeVoltage, outData(:, 7:9));

        end

        function scansRequiredFunction(obj, ~, ~)

            obj.NIHandler.write(obj.SignalGenerator.SignalProcessed(obj.SignalGenerator.Buffer:obj.SignalGenerator.Buffer + obj.NIHandler.ScansRequiredFunctionCount));
            obj.SignalGenerator.Buffer = obj.SignalGenerator.Buffer + 500;

        end

    end

end
