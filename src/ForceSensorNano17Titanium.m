classdef ForceSensorNano17Titanium < Transducer

    properties (Access = public)

        Device
        GaugeVoltage
        ForceTorque
        Bias
        Gain
    end

    methods (Access = public)

        function obj = ForceSensorNano17Titanium(varargin)

            obj.Device = NIDevice("Dev1", ...
                {"ai0", "ai1", "ai2", "ai3", "ai4", "ai5"}, ...
                "Voltage", ...
                "Input", ...
                "Differential");

            

            obj.Bias = [0, 0, 0, 0, 0, 0];
            
            obj.Gain = [-0.00245   0.02466   0.05585  -0.83458  -0.04315   0.85113;
 		-0.02502   0.92010   0.01425  -0.45519   0.02270  -0.51853 ;     
 		0.95748   0.03776   0.92538   0.04615   0.98824   0.03969;
 		-0.34745   5.54086   5.35949  -2.47291  -5.19643  -3.34585;
 		 -6.00849  -0.40893   2.53702   5.20801   3.58517  -5.02455 ;
 	 -0.18358   3.37833  -0.18652   3.33038  -0.09424   3.68362];
            
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
            angle = 60; % in degrees
            transformationMatrix = [cosd(angle) sind(angle);
                                    -sind(angle) cosd(angle)];
            obj.ForceTorque(:, 1:2) = obj.ForceTorque(:, 1:2) * transformationMatrix';
            obj.ForceTorque(:, 3) = -obj.ForceTorque(:, 3);
            obj.ForceTorque(:, 1:3) = obj.ForceTorque(:, 1:3) ./ [0.32/0.4905 0.33/0.4905 0.4/0.4905]'';
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
