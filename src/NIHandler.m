classdef NIHandler < DAQHandler

    properties (Access = public)

        Interface
        Mode
        Rate

    end

    properties (Access = private)

        DataAcqusitionObject

    end

    methods

        function obj = NIHandler(varargin)

            obj.Interface = "ni";
            obj.Mode = "Background";

            obj.DataAcqusitionObject = daq("ni");
            obj.Rate = 1000;

            obj.DataAcqusitionObject.Rate = obj.Rate;

        end

        function addInput(obj, varargin)

        end

        function outData = read(obj, varargin)

        end

        function outData = readWrite(obj, inData)

        end

        function start(obj)

        end

        function stop(obj)

        end

        function removeChannel(obj)

        end

        function flush(obj)

        end

        function addOutput(obj, varargin)

        end

        function write(obj, inData, varargin)

        end

        function preload(obj)

        end

    end

end
