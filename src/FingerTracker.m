classdef FingerTracker < Transducer

    properties (Access = public)

        Device
        FingerPosition

    end

    methods (Access = public)

        function obj = FingerTracker(varargin)

            obj.Device = "";

            if ~isempty(varargin) && mod(nvarargin, 2) == 0

                for k = 1:2:nvarargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function set.FingerPosition(obj, fingerPosition)

            obj.FingerPosition = fingerPosition;

        end
        
        function process(obj)

        end

    end

end
