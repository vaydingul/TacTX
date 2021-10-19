classdef (Abstract = true) Handler < handle

    properties

        Interface
        Mode

    end

    methods

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
