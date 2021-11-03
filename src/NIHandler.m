classdef NIHandler < DAQHandler

    properties (Access = public)

        Interface
        Mode
        
        DataFormat
        DataAcqusitionObject

    end
    
    properties
        
        ScansAvailableFunction
        ScansAvailableFunctionCount
        Rate
    end

   

    methods (Access = public)

        function obj = NIHandler(varargin)

            obj.Interface = "ni";
            obj.Mode = "Background";

            obj.DataAcqusitionObject = daq("ni");
            obj.Rate = 1000;
            obj.DataFormat = 'Matrix';

            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

            obj.DataAcqusitionObject.Rate = obj.Rate;

        end

        function addDevice(obj, varargin)

            if nargin > 1 && isa(varargin{1}.Device, 'NIDevice')

                obj.addNIDevice(varargin{1}.Device);

            end

        end

        function addInput(obj, varargin)

            if nargin > 1 && isa(varargin{1}, 'NIDevice')

                obj.addInputByNIDevice(varargin{1});

            end

        end

        function addOutput(obj, varargin)

            if nargin > 1 && isa(varargin{1}, 'NIDevice')

                obj.addOutputByNIDevice(varargin{1});

            end

        end

        function outData = read(obj, span)

            outData = read(obj.DataAcqusitionObject, span, 'OutputFormat', obj.DataFormat);
            
        end

        function write(obj, inData)

            write(obj.DataAcqusitionObject, inData);

        end

        function outData = readWrite(obj, inData)

            outData = readwrite(obj.DataAcqusitionObject, inData);

        end

        function start(obj, varargin)

            start(obj.DataAcqusitionObject, varargin{:});

        end

        function stop(obj)

            stop(obj.DataAcqusitionObject);

        end

        function removeChannel(obj)

            error("Not implemented!");

        end

        function flush(obj)

            flush(obj.DataAcqusitionObject);

        end

        function preload(obj, outData)

            preload(obj.DataAcqusitionObject, outData);

        end



    end

    methods

        function set.ScansAvailableFunction(obj, functionHandle)

            obj.ScansAvailableFunction = functionHandle;
            obj.DataAcqusitionObject.ScansAvailableFcn = obj.ScansAvailableFunction;
            
        end

        function set.ScansAvailableFunctionCount(obj, count)

            obj.ScansAvailableFunctionCount = count;
            obj.DataAcqusitionObject.ScansAvailableFcnCount = obj.ScansAvailableFunctionCount;

        end

        function set.Rate(obj, rate)

            obj.Rate = rate;
            obj.DataAcqusitionObject.Rate = rate;

        end
        

    end
    
    methods (Access = private)

        function addNIDevice(obj, nidevice)

            for k = 1:length(nidevice.Channel)

                if strcmp(nidevice.Direction{k}, "Input")

                    addinput(obj.DataAcqusitionObject, nidevice.Name, nidevice.Channel{k}, nidevice.MeasurementType{k});

                elseif strcmp(nidevice.Direction{k}, "Output")

                    addoutput(obj.DataAcqusitionObject, nidevice.Name, nidevice.Channel{k}, nidevice.MeasurementType{k});

                end

                obj.DataAcqusitionObject.Channels(end).TerminalConfig = nidevice.TerminalConfig{k};
            end

        end

        function addInputByNIDevice(obj, nidevice)

            for k = 1:length(nidevice.Channel)

                if strcmp(nidevice.Direction{k}, "Input")

                    addinput(obj.DataAcqusitionObject, nidevice.Name, nidevice.Channel{k}, nidevice.MeasurementType{k});

                end

                obj.DataAcqusitionObject.Channels(end).TerminalConfig = nidevice.TerminalConfig{k};

            end

        end

        function addOutputByNIDevice(obj, nidevice)

            for k = 1:length(nidevice.Channel)

                if strcmp(nidevice.Direction{k}, "Output")

                    addoutput(obj.DataAcqusitionObject, nidevice.Name, nidevice.Channel{k}, nidevice.MeasurementType{k});

                end

                obj.DataAcqusitionObject.Channels(end).TerminalConfig = nidevice.TerminalConfig{k};
                
            end

        end

    end

end
