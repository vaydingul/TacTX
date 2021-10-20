classdef NIDevice < Device

    properties (Access = public)

        Name
        Channel
        MeasurementType
        Direction
        TerminalConfig

    end

    methods (Access = public)

        function obj = NIDevice(name, channelName, measurementType, direction, terminalConfig)

            obj.Name = name;
            obj.Channel = channelName;
            obj.MeasurementType = measurementType;
            obj.Direction = direction
            obj.TerminalConfig = terminalConfig;

            obj.checkMeasurementType();
            obj.checkDirection();
            obj.checkTerminalConfig();
            
        end

        function obj = plus(obj, nidevice)

            if obj.Name ~= nidevice.Name

                error("Name of the devices should be same.")

            else

                obj.addChannel(nidevice.Channel);
                obj.addMeasurementType(nidevice.MeasurementType);
                obj.addDirection(nidevice.Direction);
                obj.addTerminalConfig(nidevice.TerminalConfig);
            end

        end

    end

    methods (Access = private)

        function checkMeasurementType(obj)

            if ~iscell(obj.MeasurementType)

                if isstring(obj.MeasurementType)

                    obj.MeasurementType = repmat({obj.MeasurementType}, 1, length(obj.Channel))

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

                    obj.Direction = repmat({obj.Direction}, 1, length(obj.Channel))

                else

                    error("Direction should be either a single string or cell array.")

                end

            else

                if length(obj.Channel) ~= length(obj.Direction)

                    error("Number of channel names and directions should be matched.")

                end

            end

        end

        function checkTerminalConfig(obj)

            if ~iscell(obj.TerminalConfig)

                if isstring(obj.TerminalConfig)

                    obj.TerminalConfig = repmat({obj.TerminalConfig}, 1, length(obj.Channel))

                else

                    error("Terminal config should be either a single string or cell array.")

                end

            else

                if length(obj.Channel) ~= length(obj.TerminalConfig)

                    error("Number of channel names and terminal configs should be matched.")

                end

            end

        end

        function addChannel(obj, channel)

            if isstring(channel)
                obj.Channel = cat(2, obj.Channel, {channel});
            elseif iscell(channel)
                obj.Channel = cat(2, obj.Channel, channel);
            else
                error("Channel must be a string scalar or a  cell array.")
            end

        end

        function addMeasurementType(obj, measurementType)

            if isstring(measurementType)
                obj.MeasurementType = cat(2, obj.MeasurementType, {measurementType});
            elseif iscell(measurementType)
                obj.MeasurementType = cat(2, obj.MeasurementType, measurementType);
            else
                error("Measurement type must be a string scalar or a  cell array.")
            end

        end

        function addDirection(obj, direction)

            if isstring(direction)
                obj.Direction = cat(2, obj.Direction, {direction});
            elseif iscell(direction)
                obj.Direction = cat(2, obj.Direction, direction);
            else
                error("Direction must be a string scalar or a  cell array.")
            end

        end

        function addTerminalConfig(obj, terminalConfig)

            if isstring(terminalConfig)
                obj.TerminalConfig = cat(2, obj.TerminalConfig, {terminalConfig});
            elseif iscell(terminalConfig)
                obj.TerminalConfig = cat(2, obj.TerminalConfig, terminalConfig);
            else
                error("Terminal config must be a string scalar or a  cell array.")
            end

        end

    end

end
