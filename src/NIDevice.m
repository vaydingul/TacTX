classdef NIDevice < Device

    properties (Access = public)

        Name
        Channel
        MeasurementType
        Direction

    end

    methods (Access = public)

        function obj = NIDevice(name, channelName, measurementType, direction)

            obj.Name = name;
            obj.Channel = channelName;
            obj.MeasurementType = measurementType;
            obj.Direction = direction

            obj.checkMeasurementType();
            obj.checkDirection();
        end

		function obj = plus(obj, nidevice)

			if obj.Name ~= nidevice.Name

				error("Name of the devices should be same.")

			else

				obj.addChannel(nidevice.Channel);
				obj.addMeasurementType(nidevice.MeasurementType);
				obj.addDirection(nidevice.Direction);

			end

		end
        

    end

    methods (Access = private)

        function checkMeasurementType(obj)

            if ~iscell(obj.MeasurementType)

                if isstring(obj.MeasurementType)

                    obj.MeasurementType = repmat({obj.MeasurementType}, length(obj.Channel))

                else

                    error("Measurement type should be either a single string or cell array.")

                end

            else

                if length(obj.Channel) ~= length(obj.MeasurementType)

                    error("Number of channel names and measurement types should be matched.")

                end

            end

        end

        function checkDirection(obj)

            if ~iscell(obj.Direction)

                if isstring(obj.Direction)

                    obj.Direction = repmat({obj.Direction}, length(obj.Channel))

                else

                    error("Direction should be either a single string or cell array.")

                end

            else

                if length(obj.Channel) ~= length(obj.Direction)

                    error("Number of channel names and directions should be matched.")

                end

            end

        end

		function addChannel(obj, channel)
			obj.Channel = {obj.Channel channel};
        end

        function addMeasurementType(obj, measurementType)
			obj.MeasurementType = {obj.MeasurementType measurementType};
        end

        function addDirection(obj, direction)
			obj.Direction = {obj.Direction direction};
        end

    end

end
