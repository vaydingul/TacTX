classdef FingerTracker < Transducer

    properties (Access = public)

        Device
        FingerPosition

    end

    methods (Access = public)

        function obj = FingerTracker(varargin)

            obj.Device = "";

            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function process(obj)

        end
        
    end
    
    methods
        
         function set.FingerPosition(obj, fingerPosition)

            obj.FingerPosition = fingerPosition;

        end
        
    end

end
