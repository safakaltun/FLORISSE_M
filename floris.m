classdef floris<handle
    properties
        inputData
        outputData
        outputDataAEP
    end
    methods        
        % Initialization
        function self = floris(self,modelType,turbType,siteType,visualizationType)
            addpath('functions');
            if nargin <= 3; visualizationType = '2d'; end;
            if nargin <= 2; siteType  = '9turb';      end;
            if nargin <= 1; turbType  = 'NREL5MW';    end;
            if nargin <= 0; modelType = 'default';    end;
            self.inputData = floris_loadSettings(modelType,turbType,siteType,visualizationType);
        end
       
        % Optimization methods can be added here
        % ....
        % ....
        
        % FLORIS single execution
        function [self,outputData] = run(self,inputData)
            if exist('inputData') == 0; inputData = self.inputData; end;
            [self.inputData,self.outputData] = floris_run(inputData);
            if nargout > 0; outputData = self.outputData; end;
        end
        
        % Visualize single FLORIS plot
        function visualize(self)
            inputData  = self.inputData;
            outputData = self.outputData;
            if isstruct(outputData) == 0
                disp('outputData is not available/not formatted properly.');
                disp(' Please run a SINGLE simulation, then call this function.');
            end; 
            floris_visualization(inputData,outputData);
        end;
        
        % FLORIS for a range of wind speeds and directions
        function [self,outputDataAEP] = AEP(self,windRose)
            % WindRose is an N x 2 matrix with uIf in 1st column and 
            % vIf in 2nd. The simulation will simulate FLORIS for each row.
            inputData = self.inputData;
            for i = 1:size(windRose,1);
                inputData.uInfIf      = WS_range(windRose,1);
                inputData.vInfIf      = WS_range(windRose,2);
                self.outputDataAEP{i} = floris_run(inputData);
            end;
            if nargout > 0; outputDataAEP = self.outputDataAEP; end;
        end        
    end
end