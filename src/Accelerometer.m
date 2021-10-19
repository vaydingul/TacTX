classdef Accelerometer < Transducer

    properties (Access = public)

        Device
        GaugeVoltage
        Acceleration
        Bias
        Scale
    end

    methods (Access = public)

        function obj = Accelerometer(varargin)

            obj.Device = NIDevice("Dev2", ...
                {"ai4", "ai12", "ai5"}, ...
                "Voltage", ...
                "Input");
            obj.GaugeVoltage = [];
            obj.Acceleration = [];

            obj.Bias = [1.6571 1.6695 1.6571];
            obj.Scale = [1.3168 0.33 0.33];

            if ~isempty(varargin) && mod(nvarargin, 2) == 0

                for k = 1:2:nvarargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function process(obj)

            obj.Acceleration = (obj.GaugeVoltage - obj.Bias) ./ obj.Scale;

        end

    end

    methods

        function set.GaugeVoltage(obj, gaugeVoltage)

            obj.GaugeVoltage = gaugeVoltage;
            obj.process();
        end

    end

end
