classdef (Abstract = true) DAQHandler < Handler

    properties (Abstract = true)

        Interface
        Mode % Data acquisition mode (Background or Foreground)

    end

    methods (Abstract = true)

        addInput(obj)
        read(obj)
        readWrite(obj)
        start(obj)
        stop(obj)
        removeChannel(obj)
        flush(obj)
        addOutput(obj)
        write(obj)
        preload(obj)

    end

end
