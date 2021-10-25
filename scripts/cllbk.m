
function cllbk(src, evt)
global tactx
    tactx.scansAvailableFunction(src, evt);
    disp(tactx.ForceSensor.ForceTorque(end, 3))
end