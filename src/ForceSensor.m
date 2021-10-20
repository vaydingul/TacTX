classdef ForceSensor < Transducer

    properties (Access = public)

        Device
        GaugeVoltage
        ForceTorque
        Bias
        Gain
    end

    methods (Access = public)

        function obj = ForceSensor(varargin)

            obj.Device = NIDevice("Dev1", ...
                {"ai0", "ai1", "ai2", "ai3", "ai4", "ai5"}, ...
                "Voltage", ...
                "Input", ...
                "Differential");

            

            obj.Bias = [-2.163948669433594,0.639072265625000,-1.438094482421875,-2.276571655273437,-0.530919494628906,-0.380003662109375];

            obj.Gain = [-0.008988558	0.01636383	-0.016207209	1.709100556	-0.010353274	-1.714581856
                    0.064670016	-2.188230603	-0.010510775	0.972092909	-0.015269682	1.041792839
                    1.805711459	0.007669575	1.526170728	-0.045459199	1.933470965	-0.025708347
                    0.306797685	-13.27323888	8.678856758	5.656698914	-11.02508507	6.469202187
                    -11.5890942	-0.100412191	5.1181421	-10.5413148	6.505246556	10.32580521
                    0.136561278	-7.586013116	0.21378772	-7.246447361	-0.092033948	-7.061610822];
            
            obj.GaugeVoltage = zeros(1, 6);

            obj.ForceTorque = zeros(1, 6);

            
            if ~isempty(varargin) && mod(nvarargin, 2) == 0

                for k = 1:2:nvarargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function process(obj)

            obj.ForceTorque = (obj.Gain * (obj.GaugeVoltage - obj.Bias)')';
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
