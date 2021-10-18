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
			obj.DAQObject.Rate = 1000;

        end

		function read(obj)
		end

		function write(obj)
		end

		function readwrite(obj)
		end



    end

end
