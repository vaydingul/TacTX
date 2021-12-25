classdef TacTX < TacTX_

    properties (Access = public)

        NIHandler
        MISCHandler
        ForceSensor
        Accelerometer
        SignalGenerator
        FingerTracker

        State
        Config

    end

    methods (Access = public)

        function obj = TacTX(varargin)

            obj.NIHandler = NIHandler();
            obj.MISCHandler = MISCHandler();
            obj.ForceSensor = ForceSensor();
            obj.Accelerometer = Accelerometer();
            obj.SignalGenerator = SignalGenerator();
            obj.FingerTracker = FingerTracker();

            if ~isempty(varargin) && mod(nargin, 2) == 0

                for k = 1:2:nargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end

            obj.NIHandler.Rate = obj.Config.SAMPLE_RATE;
            obj.MISCHandler.Rate = floor(obj.Config.SAMPLE_RATE / 10);

            obj.NIHandler.ScansAvailableFunction = @(src, evt) obj.scansAvailableFunction(src, evt);
            obj.NIHandler.ScansAvailableFunctionCount = obj.Config.SCANS_AVAILABLE_FUNCTION_COUNT;

            obj.organize();

        end

        function run(obj, varargin)

            obj.State.run(obj, varargin{:});

        end

        function idle(obj)

            obj.State.idle(obj);

        end

        function save(obj, varargin)

            obj.State.save(obj, varargin);

        end

        function organize(obj)

            obj.NIHandler.addDevice(obj.ForceSensor);
            obj.NIHandler.addDevice(obj.Accelerometer);

            if obj.Config.EXPERIMENT_MODE

                obj.NIHandler.addDevice(obj.SignalGenerator);

            end

            obj.MISCHandler.Transducer = obj.FingerTracker;

        end

        function [forceRead, accelerationRead] = scansAvailableFunction(obj, ~, ~)

            outData = obj.NIHandler.read(obj.NIHandler.ScansAvailableFunctionCount);

            forceRead = outData(:, 1:6);
            accelerationRead = outData(:, 7:9);
            obj.ForceSensor.GaugeVoltage = cat(1, obj.ForceSensor.GaugeVoltage, forceRead);
            obj.Accelerometer.GaugeVoltage = cat(1, obj.Accelerometer.GaugeVoltage, accelerationRead);

        end

        function biasForceSensor(obj)

            obj.run();
            pause(1.0);
            obj.idle();
            obj.ForceSensor.Bias = mean(obj.ForceSensor.GaugeVoltage, 1);
            obj.save('biasing.mat');
            pause(1.0);
            obj.idle();

        end

        function plot(obj, varargin)

            ixs = 'all';
            forceTorque = [1 3];
            accelerometer = [1 3];
            isFftRequired = true

            switch length(varargin)

                case 1

                    ixs = varargin{1}

                case 2

                    ixs = varargin{1}
                    forceTorque = varargin{2}

                case 3

                    ixs = varargin{1}
                    forceTorque = varargin{2}
                    accelerometer = varargin{3}

                case 4

                    ixs = varargin{1}
                    forceTorque = varargin{2}
                    accelerometer = varargin{3}
                    isFftRequired = varargin{4}

            end

            subplotRow = length(forceTorque) + length(accelerometer) + 1;
            subplotCol = 1 + isFftRequired;

            f = figure;

            cnt = 1
            axs = [];

            for k = 1:length(forceTorque)


                if strcmp(ixs, 'all')

                    ix = 1:size(obj.ForceSensor.GaugeVoltage, 1);

                else

                    ix = ixs;

                end

                ax = subplot(subplotRow, subplotCol, 2*cnt-1);
                axs(cnt) = ax;

                plot(obj.ForceSensor.ForceTorque(ix, forceTorque(k)));
                title(['Force Sensor ' num2str(forceTorque(k))]);
                cnt = cnt + 1;
            end

            for k = 1:length(accelerometer)


                if strcmp(ixs, 'all')

                    ix = 1:size(obj.Accelerometer.GaugeVoltage, 1);

                else

                    ix = ixs;

                end

                ax = subplot(subplotRow, subplotCol, 2*cnt-1);
                axs(cnt) = ax;

                plot(obj.Accelerometer.Acceleration(ix, accelerometer(k)));
                title(['Accelerometer ' num2str(accelerometer(k))]);
                cnt = cnt + 1;
            end


            if strcmp(ixs, 'all')

                ix = 1:size(obj.SignalGenerator.Signal, 1);

            else

                ix = ixs;

            end

            ax = subplot(subplotRow, subplotCol, 2*cnt-1);
            axs(cnt) = ax;

            plot(obj.SignalGenerator.SignalProcessed(ix));
            title(['Signal']);
            cnt = cnt + 1;

            if isFftRequired
                
                cnt = 1;
                for k = 1:length(forceTorque)


                    if strcmp(ixs, 'all')

                        ix = 1:size(obj.ForceSensor.GaugeVoltage, 1);

                    else

                        ix = ixs;

                    end

                    ax = subplot(subplotRow, subplotCol, 2*cnt);
                    axs(cnt) = ax;

                    [f, w] = fft_data(obj.ForceSensor.ForceTorque(ix, forceTorque(k)), obj.Config.SAMPLE_RATE);
                    stem(log10(f), w);
                    title(['FFT Force Sensor ' num2str(forceTorque(k))]);
                    cnt = cnt + 1;
                end

                for k = 1:length(accelerometer)


                    if strcmp(ixs, 'all')

                        ix = 1:size(obj.Accelerometer.GaugeVoltage, 1);

                    else

                        ix = ixs;

                    end

                    ax = subplot(subplotRow, subplotCol, 2*cnt);
                    axs(cnt) = ax;
                    [f, w] = fft_data(obj.Accelerometer.Acceleration(ix, accelerometer(k)), obj.Config.SAMPLE_RATE);
                    stem(log10(f), w);
                    title(['FFT Accelerometer ' num2str(accelerometer(k))]);
                    cnt = cnt + 1;
                end


                if strcmp(ixs, 'all')

                    ix = 1:size(obj.SignalGenerator.Signal, 1);

                else

                    ix = ixs;

                end

                ax = subplot(subplotRow, subplotCol, 2*cnt);
                axs(cnt) = ax;
                [f, w] = fft_data(obj.SignalGenerator.SignalProcessed(ix), obj.Config.SAMPLE_RATE);
                stem(log10(f), w)
                title(['Signal']);
                cnt = cnt + 1;

            end

            linkaxes(axs, 'x');

        end

    end

end
