classdef (Abstract = true) Handler < handle

    properties (Abstract = true)

        Interface
        Mode

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
