classdef TacTX < handle

	properties (Access = public)
		
		Handler
		Transducer
		State
		Config

	end
	
	methods (Access = public)
		function obj = TacTX(varargin)

			

			if ~isempty(varargin) && mod(nvarargin, 2) == 0

                for k = 1:2:nvarargin

                    obj.(varargin{k}) = varargin{k + 1};

                end

            end
			
		end
	end
end