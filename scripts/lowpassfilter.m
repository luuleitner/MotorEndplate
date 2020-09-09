%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Copyright (C) 2020  CU Boulder, TU Graz, ETH Zurich.
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

function fsignal = lowpassfilter(signal, N, fc, fs, plotq)
%% LOWPASSFILTER: Double (zero-phase) butterworth lowpass filter
%
% fsignal = lowpassfilter(signal, N, fc, fs, plotq)
%
% INPUT
%  signal ... signal, numeric vector
%  N    ...   Order, number
%  fc   ...   cutoff frequency [Hz], number
%  fs   ...   sampling frequenzy [Hz], number
%       ...   note: fs !> 2 * (-1 + sqrt(2))^(-(1/2)/N) * fc
%  plotq...   enable/disable plotting, logic either 0 or 1
%  
% OUTPUT
%  fsignal ...   filtered signal signal, numeric vector
%
% additional CREDIT to Ton van den Bogert:
% [1] https://biomch-l.isbweb.org/archive/index.php/t-26625.html


    if plotq > 1
        error('plotq is either 1: true, or 0: false')
    end
    if N < 2
        error('N has to be greater 1 for bi-directional filtering')
    end
    if mod(N,2)
        error('An even filter order is needed for correct butter response at bi-directioal filtering')
    end
    if numel(fs) > 1
        error('fs is only a single number')
    end
    if ~isvector(signal) && length(signal) < 8
        error('signal has to be a single n x 1 or 1 x n vector of length > 3')
    end
    if numel(fc) > 1
        error('fc is only a single number')
    end
    if fs < 2 * (-1 + sqrt(2))^(-(1/2)/N) * fc
        error('Your sampling frequency is too small for the specified cut-off frequency')
    end

    N = N/2; % N is doubled at bi-directional filtering
    
    Wn = (2*fc)/(fs*((sqrt(2)-1).^(1/(2*N)))); % [1]
    [b,a] = butter(N,Wn);
    fsignal = filtfilt(b,a,signal);
        
    if plotq
        figure
        x = 1:numel(signal);
        plot(x,signal,'b-')
        hold on
        plot(x,fsignal,'r-','linewidth',2)
        hold off
        xlabel('samples [-]')
        ylabel('signal Amplitude [xV]')
        if N == 1
            high = 'nd';
        else
            high = 'th';
        end
        title(['Double ',num2str(N*2),high,' order butterworth lowpass filter applied to input'])
    end
end