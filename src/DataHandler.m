classdef (Abstract = true) DataHandler < handle

    properties (Access = public)

		Data
		SampleRate
		
    end

    methods (Access = public)

        function initialize(obj)

        end

        function read(obj)

        end

        function write(obj)

        end

		function kill(obj)

		end

    end

end
