classdef ForceSensorNano17 < Transducer

    properties (Access = public)

        Device
        GaugeVoltage
        ForceTorque
        Bias
        Gain
    end

    methods (Access = public)

        function obj = ForceSensorNano17(varargin)

            obj.Device = NIDevice("Dev1", ...
                {"ai0", "ai1", "ai2", "ai3", "ai4", "ai5"}, ...
                "Voltage", ...
                "Input", ...
                "Differential");

            

            obj.Bias = [-0.953381958007812,0.217216186523438,-2.560197448730469,-2.699037475585937,-0.704587707519531,-0.866604309082031];
            
            obj.Gain = [-0.008988558	0.01636383	-0.016207209	1.709100556	-0.010353274	-1.714581856
                    0.064670016	-2.188230603	-0.010510775	0.972092909	-0.015269682	1.041792839
                    1.805711459	0.007669575	1.526170728	-0.045459199	1.933470965	-0.025708347
                    0.306797685	-13.27323888	8.678856758	5.656698914	-11.02508507	6.469202187
                    -11.5890942	-0.100412191	5.1181421	-10.5413148	6.505246556	10.32580521
                    0.136561278	-7.586013116	0.21378772	-7.246447361	-0.092033948	-7.061610822];
            
            obj.GaugeVoltage = zeros(1, 6);

            obj.ForceTorque = zeros(1, 6);

            
            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function process(obj)

            obj.ForceTorque = (obj.Gain * (obj.GaugeVoltage - obj.Bias)')';
            angle = 0; % in degrees
            transformationMatrix = [cosd(angle) sind(angle);
                                    -sind(angle) cosd(angle)];
            obj.ForceTorque(:, 1:2) = obj.ForceTorque(:, 1:2) * transformationMatrix';
            obj.ForceTorque(:, 3) = -obj.ForceTorque(:, 3);
            obj.ForceTorque(:, 4:6) = obj.ForceTorque(:, 4:6) / 1000;
        end

    end

    methods

        function set.GaugeVoltage(obj, gaugeVoltage)

            obj.GaugeVoltage = gaugeVoltage;
            obj.process();
        end

    end

end
