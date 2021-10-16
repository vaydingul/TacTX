classdef ForceSensorReader < DataReader
	
	properties (Access = public)
		
		Data
		SampleRate

	end

    properties (Access = private)

        Interface
        Device
        Port
        MeasurementType
        CalibrationMatrix
		BiasVector

    end
	methods (Access = public)
		
		function initialize(obj)
    
            obj.Interface = daq('ni');  

            obj.Device = 'Dev1';

            obj.CalibrationMatrix = [-0.008988558	0.01636383	-0.016207209	1.709100556	-0.010353274	-1.714581856
            0.064670016	-2.188230603	-0.010510775	0.972092909	-0.015269682	1.041792839
            1.805711459	0.007669575	1.526170728	-0.045459199	1.933470965	-0.025708347
            0.306797685	-13.27323888	8.678856758	5.656698914	-11.02508507	6.469202187
            -11.5890942	-0.100412191	5.1181421	-10.5413148	6.505246556	10.32580521
            0.136561278	-7.586013116	0.21378772	-7.246447361	-0.092033948	-7.061610822];

			obj.BiasVector = [];

            obj.Ports = {"ai0", "ai1", "ai2", "ai3", "ai4", "ai5"};

            obj.MeasurementType = "Voltage";

			for iPort = 1 : length(Ports)

				addinput(obj.Interface, obj.Device, obj.Ports{iPort}, obj.MeasurementType);

			end

        end

        function read(obj, durationInSeconds)

			obj.Data = read(obj.Interface, seconds(durationInSeconds), 'OutputFormat', 'Matrix');

        end

        function write(obj)

			error("This device does not support data writing!");

        end

        function readwrite(obj)

        end

        function kill(obj)

        end
		
	end

end