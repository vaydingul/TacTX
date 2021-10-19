classdef (Abstract = true) State < handle
	
	methods (Abstract = true)
		
		run(obj)
		idle(obj)
		save(obj)

	end
end