classdef MISCHandler < Handler

    properties (Access = public)
        Rate
        Timer
        Transducer
    end

    methods (Access = public)

        function obj = MISCHandler(varargin)

            obj.Rate = 100;
            obj.Transducer = FingerTracker();

            obj.Timer = timer('TimerFcn', @(~, ~) obj.read, ...
                'StartFcn', '', ...
                'StopFcn', '', ...
                'Period', 1 / obj.Rate, ...
                'StartDelay', 0, ...
                'BusyMode', 'queue', ...
                'ExecutionMode', 'fixedRate');

            if ~isempty(varargin) && mod(varargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

        end

        function outData = read(obj)

            pointerLocation = get(0, 'PointerLocation');
            screenSize = get(0, 'MonitorPositions');
            outData = pointerLocation ./ screenSize(3:4);

            obj.Transducer.FingerPosition = cat(1, obj.Transducer.FingerPosition, outData);
        
        end

        function start(obj)

            start(obj.Timer);

        end

        function stop(obj)

            stop(obj.Timer);

        end

    end

end
