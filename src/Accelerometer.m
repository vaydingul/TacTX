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

            obj.Device = NIDevice("Dev3", ...
                {"ai0", "ai4", "ai1"}, ...
                "Voltage", ...
                "Input", ...
                "SingleEnded");
            
            obj.Bias = [1.6571 1.6695 1.6571];
            obj.Scale = [0.3168 0.33 0.33];
            
            obj.GaugeVoltage = zeros(1, 3);
            obj.Acceleration = zeros(1, 3);

            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

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
