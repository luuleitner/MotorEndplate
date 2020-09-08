%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Copyright (C) 2020  TU Graz, ETH Zurich.
%   
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%       http://www.apache.org/licenses/LICENSE-2.0
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ROI_Fascicle,ROI_nr] = FascicleSampling(Image,ImScale,ROIdim,meth,meth_var)
%
%%%%%%%%%%%%%
% INPUT
%
%  Image    ...   Input imgage, [tensor]
%  ImScale  ...   Scaling factor of image, [float]
%  ROIdim   ...   Height and width of Tracking window, [integer]
%  meth     ...   'mepb' uses meth_var as the number of sampling points, [string]
%           ...   'strain' uses meth_var as distance between sampling points, [string]
%
%%%%%%%%%%%%%
%
% OPEN GUI
figure(1)
imshow(Image)

% Create Line Element
h = images.roi.Line(gca,'Position',[50 50;100 100]);
pos = customWait(h);

% CALCULATE EUCLIDIAN DISTANCE between selected Fascicle end Points
L_Fascicle = (pdist(pos,'euclidean'))*ImScale;

% CALCULATE number of sampling points
swtch=0;
if strcmp(meth,'mepb')
    ROI_nr = meth_var;
    num_points = meth_var;
    swtch=1;
end    
if strcmp(meth,'strain')
    num_points = round(L_Fascicle/meth_var);
    ROI_nr = num_points;
    swtch=1;
end     
if swtch == 0
    error('Wrong - meth - input string!')
    quit force;
end

% CALCULATE SAMPLE POINTS
 j=1;
 for i=1:(num_points+2)
     if i == 1
         raw_Sample_Points(i,1) = pos(2,1);
         raw_Sample_Points(i,2) = pos(2,2);

     elseif i == (num_points+2)
         raw_Sample_Points(i,1) = pos(1,1);
         raw_Sample_Points(i,2) = pos(1,2);

     else   
        raw_Sample_Points(i,1)=(pos(1,1)*j+pos(2,1)*(num_points-j+1))/(num_points+1);
        raw_Sample_Points(i,2)=(pos(1,2)*j+pos(2,2)*(num_points-j+1))/(num_points+1);
        j=j+1;
     end
     
    % Create Rectangle from center Points AND save to ROI_Fascicle (Raw Data)  
    width = ROIdim;
    height = ROIdim; 
    xLeft = raw_Sample_Points(i,1) - width/2;
    yBottom = raw_Sample_Points(i,2) - height/2;
    
    raw_ROIFascicle{i} = [xLeft yBottom width height];
 end
 
%Sample Correction
Sample_Points = flipud(raw_Sample_Points);
ROI_Fascicle = flipud(raw_ROIFascicle);

%% CALLBACK FUNCTIONS for Line ROI Tool
function pos = customWait(hROI)

    % Listen for mouse clicks on the ROI
    l = addlistener(hROI,'ROIClicked',@clickCallback);

    % Block program execution
    uiwait;

    % Remove listener
    delete(l);

    % Return the current position
    pos = hROI.Position;

 end

    function clickCallback(~,evt)

        if strcmp(evt.SelectionType,'double')
        uiresume;
        end
    end
end