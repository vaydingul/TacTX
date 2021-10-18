classdef NIHandler < DAQHandler

    properties (Access = public)

        Interface
        Mode
        Rate

    end

    properties (Access = private)

        DAQObject

    end

    methods

        function obj = NIHandler(varargin)

            obj.Interface = "ni";
            obj.Mode = "Background";

            obj.DAQObject = daq("ni");
			obj.Rate = 1000;

            obj.DAQObject.Rate = obj.Rate;

        end

		function addInputChannel(obj)
			
			
		
		end

        function read(obj)
        end

        function write(obj)
        end

        function readWrite(obj)
        end

    end

end
