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

clear all;
close all;
clc;

%% USER INPUT
% Pathes
file = ('**//path to .avi');        % <<<< Enter path to beamformed *.avi file 
Imfilepath = ('**//path to .tif');  % <<<< Enter file path to the first image frame

% Method and GUI-controls
max_Frames = 4500;  % <<<< Enter number of frames in the video
ROIdim = 20         % <<<< TWS dimension (px)
ImScale = 0.088;    % <<<< Pixel/mm measure-tape: 1px is 0.088mm
Framerate = 1500    % <<<< Enter framerate
meth='mepb'
meth_var = 8;       % <<<< Enter chosen number of SPTs - 2 (e.g. if you choose 15 SPT than enter 13)
PlotResults = 1;    % <<<< Enter plot logic either 0 or 1 (plot sampling points)

%% Indices initialization
ROIFtime = 1/Framerate;  % time per frame [s]
ROI_idx = 1;
i = 1;

%% Tracker
% Define SPT and TWS
[ROIFascicle,ROI_nr] = FascicleSampling(Imfilepath,ImScale,ROIdim,meth,meth_var)
ROI_idx=1;

% Track SPTs in Ultrasound Video
for ROI_idx = 1:(ROI_nr+2)
    videoFileReader = vision.VideoFileReader(file);
    videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);
    objectFrame = videoFileReader();    
    points = detectHarrisFeatures(rgb2gray(objectFrame),'ROI',ROIFascicle{ROI_idx});
    tracker = vision.PointTracker('NumPyramidLevels',5,'MaxBidirectionalError',1);
    initialize(tracker,points.Location,objectFrame);

    i=1;
    while ~isDone(videoFileReader)
        frame = videoFileReader();
        [points,validity] = tracker(frame);
        ROIcenter{i,ROI_idx} = mean(points);
        if i == 1
            ROItime(i,1) = 0;
        else
            ROItime(i,1) = ROItime(i-1,1)+ROIFtime;     
        end
        i=i+1;
    end
    release(videoPlayer);
    release(videoFileReader);
    ROI_idx = ROI_idx+1;
end
