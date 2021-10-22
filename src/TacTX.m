classdef TacTX < TacTX_

    properties (Access = public)

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
               
            obj.NIHandler.Rate = obj.Config.SAMPLE_RATE;
            obj.MISCHandler.Rate = floor(obj.Config.SAMPLE_RATE/10);

            obj.NIHandler.ScansAvailableFunction = @(src, evt) obj.scansAvailableFunction(src, evt);
            obj.NIHandler.ScansAvailableFunctionCount = obj.Config.SCANS_AVAILABLE_FUNCTION_COUNT;

            obj.organize();

        end

        function run(obj)

            obj.State.run(obj);

        end

        function idle(obj)

            obj.State.idle(obj);

        end

        function save(obj, varargin)

            obj.State.save(obj, varargin);

        end

        function organize(obj)

            obj.NIHandler.addDevice(obj.ForceSensor);
            obj.NIHandler.addDevice(obj.Accelerometer);

            if obj.Config.EXPERIMENT_MODE

                obj.NIHandler.addDevice(obj.SignalGenerator);

            end

            obj.MISCHandler.Transducer = obj.FingerTracker;


        end

        function scansAvailableFunction(obj, ~, ~)

            outData = obj.NIHandler.read(obj.NIHandler.ScansAvailableFunctionCount);

            obj.ForceSensor.GaugeVoltage = cat(1, obj.ForceSensor.GaugeVoltage, outData(:, 1:6));
            obj.Accelerometer.GaugeVoltage = cat(1, obj.Accelerometer.GaugeVoltage, outData(:, 7:9));

        end

        

    end

end
